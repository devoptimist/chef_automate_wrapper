#
# Cookbook:: chef_automate_wrapper
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

remote_file '/bin/jq' do
  source node['chef_automate_wrapper']['jq_url']
  mode '0755'
end

config = node['chef_automate_wrapper']['config']

if node['chef_automate_wrapper']['fqdn'] != ''
  node.override['chef_automate_wrapper']['hostname_method'] = 'external_fqdn'
end

hostname = case node['chef_automate_wrapper']['hostname_method']
           when 'external_fqdn'
             node['chef_automate_wrapper']['fqdn']
           when 'fqdn'
             node['fqdn']
           when 'ipaddress'
             node['ipaddress']
           when 'hostname'
             node['hostname']
           when 'cloud'
             node['cloud']['public_ipv4_addrs'].first
           else
             node['ipaddres']
           end

config += if node['chef_automate_wrapper']['dc_token'] != ''
            <<~CONFIG
              [auth_n.v1.sys.service]
              a1_data_collector_token = "#{node['chef_automate_wrapper']['dc_token']}"

            CONFIG
          else
            ''
          end

config += if node['chef_automate_wrapper']['cert'] != '' &&
             node['chef_automate_wrapper']['cert_key'] != ''
            <<~CONFIG
              [[global.v1.frontend_tls]]
              cert = """#{node['chef_automate_wrapper']['cert']}"""
              key = """#{node['chef_automate_wrapper']['cert_key']}"""
            CONFIG
          else
            ''
          end

config += <<~CONFIG
  [global.v1]
  fqdn = "#{hostname}"

CONFIG

chef_automatev2 'chef-automate' do
  channel node['chef_automate_wrapper']['channel'].to_sym
  products node['chef_automate_wrapper']['products']
  version node['chef_automate_wrapper']['version']
  config (platform_family?('suse') || platform?('ubuntu')) ? '' : config
  accept_license node['chef_automate_wrapper']['accept_license'].to_s == 'true'
  notifies :run, 'ruby_block[parse_creds]', :delayed
end

execute 'apply_license' do
  command "chef-automate license apply #{node['chef_automate_wrapper']['license']}"
  only_if { node['chef_automate_wrapper']['license'] != '' }
  not_if 'chef-automate license status | grep Expiration'
end

execute 'update_admin_password' do
  command "chef-automate iam admin-access restore #{node['chef_automate_wrapper']['admin_password']}"
  not_if { node['chef_automate_wrapper']['admin_password'] == '' }
  notifies :run, 'ruby_block[parse_creds]', :delayed
end

# suse is different
if platform_family?('suse') || platform?('ubuntu')

  link '/usr/bin/chef-automate' do
    to '/bin/chef-automate'
    only_if { ::File.file?('/bin/chef-automate') }
  end

  chef_automatev2 'chef-automate' do
    action :reconfigure
    channel node['chef_automate_wrapper']['channel'].to_sym
    products node['chef_automate_wrapper']['products']
    version node['chef_automate_wrapper']['version']
    config config
    accept_license node['chef_automate_wrapper']['accept_license'].to_s == 'true'
    notifies :run, 'ruby_block[parse_creds]', :delayed
  end

end



directory node['chef_automate_wrapper']['patching_hartifacts_path'] do
  recursive true
  not_if { node['chef_automate_wrapper']['patching_override_origin'] == 'chef' }
end

template node['chef_automate_wrapper']['patching_toml_file_path'] do
  source 'automate_patch.toml.erb'
  variables(
    channel: node['chef_automate_wrapper']['patching_channel'],
    upgrade_strategy: node['chef_automate_wrapper']['patching_upgrade_strategy'],
    deployment_type: node['chef_automate_wrapper']['patching_deployment_type'],
    override_origin: node['chef_automate_wrapper']['patching_override_origin'],
    hartifacts_path: node['chef_automate_wrapper']['patching_hartifacts_path']
  )
  not_if { node['chef_automate_wrapper']['patching_override_origin'] == 'chef' }
  notifies :run, 'execute[chef_automate_patching_config]', :immediate
end

execute 'chef_automate_patching_config' do
  command "chef-automate config patch #{node['chef_automate_wrapper']['patching_toml_file_path']}"
  action :nothing
  notifies :run, 'ruby_block[parse_creds]', :delayed
end

chef_server = node['chef_automate_wrapper']['products'].include?('chef-server')

if node['chef_automate_wrapper']['chef_orgs'] != {} && node['chef_automate_wrapper']['chef_users'] != {} && chef_server
  node['chef_automate_wrapper']['chef_users'].each do |name, params|
    chef_user name do
      first_name params['first_name']
      last_name params['last_name']
      email params['email']
      password params['password']
      serveradmin params['serveradmin']
      notifies :run, 'ruby_block[parse_creds]', :delayed
    end
  end

  node['chef_automate_wrapper']['chef_orgs'].each do |name, params|
    chef_org name do
      org_full_name params['org_full_name']
      admins params['admins']
      notifies :run, 'ruby_block[parse_creds]', :delayed
    end
  end
end

ruby_block 'parse_creds' do
  block do
    require 'json'
    require 'tomlrb'
    src = Tomlrb.load_file("#{Chef::Config[:file_cache_path]}/automate-credentials.toml")
    org = node['chef_automate_wrapper']['init_org']
    user = node['chef_automate_wrapper']['init_user']
    dest = node['chef_automate_wrapper']['creds_json_path']
    pass = node['chef_automate_wrapper']['admin_password']
    tkn = node['chef_automate_wrapper']['dc_token']
    src['url'] = "https://#{hostname}" if hostname != ''
    src['password'] = pass if pass != ''
    src['token'] = tkn
    src['validation_pem'] = ChefAutomateWrapper::ServerHelpers.read_pem('org', org)
    src['validation_client_name'] = org != '' ? "#{org}-validator" : ''
    src['client_pem'] = ChefAutomateWrapper::ServerHelpers.read_pem('client', user)
    src['org_name'] = org
    src['org_url'] = org != '' ? "https://#{hostname}/organizations/#{org}" : ''
    src['base_url'] = org != '' ? "https://#{hostname}" : '' # kept for backwards compat
    src['node_name'] = user
    ::File.write(dest, src.to_json)
    action :nothing
  end
end

file node['chef_automate_wrapper']['data_script'] do
  content <<~SCRIPT
    #!/bin/bash
    cat #{node['chef_automate_wrapper']['creds_json_path']} | /bin/jq -r '.'
  SCRIPT
  mode '0755'
end
