default['chef_automate_wrapper']['channel'] = :current
default['chef_automate_wrapper']['version'] = 'latest'
default['chef_automate_wrapper']['config'] = ''
default['chef_automate_wrapper']['accept_license'] = true
default['chef_automate_wrapper']['creds_json_path'] = '/tmp/automate-credentials.json'
default['chef_automate_wrapper']['dc_token'] = ''
default['chef_automate_wrapper']['fqdn'] = ''
default['chef_automate_wrapper']['admin_password'] = ''
default['chef_automate_wrapper']['jq_url'] = 'https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64'
default['chef_automate_wrapper']['data_script'] = '/usr/bin/automate-secrets.sh'
default['chef_automate_wrapper']['license'] = ''
default['chef_automate_wrapper']['products'] = ['automate']

# SSL certificate related attribures
default['chef_automate_wrapper']['cert'] = ''
default['chef_automate_wrapper']['cert_key'] = ''

# hostname choice related
default['chef_automate_wrapper']['hostname_method'] = 'ipaddress'

# patching config related
default['chef_automate_wrapper']['patching_toml_file_path'] = '/root/automate_patching.toml'
default['chef_automate_wrapper']['patching_channel'] = 'current'
default['chef_automate_wrapper']['patching_upgrade_strategy'] = 'at-once'
default['chef_automate_wrapper']['patching_deployment_type'] = 'local'
default['chef_automate_wrapper']['patching_override_origin'] = 'chef'
default['chef_automate_wrapper']['patching_hartifacts_path'] = '/hab/results'

# automate deployed chef server
default['chef_automate_wrapper']['chef_users'] = {}
# example of chef users
# node.default['chef_automate_wrapper']['chef_users'] = {
#   'jdoe' => {
#     'first_name' => 'Jane',
#     'last_name' => 'Doe',
#     'email' => 'jdoe@mail.com',
#     'password' => 'somepass',
#     'serveradmin' => true
#   }
# }

default['chef_automate_wrapper']['chef_orgs'] = {}
# example of chef_orgs
# node.default['chef_automate_wrapper']['chef_orgs'] = {
#   'acmecorp' => {
#     'org_full_name' => 'acmecorp chef org',
#     'admins' => ['jdoe']
#   }
# }

default['chef_automate_wrapper']['init_user'] = ''
default['chef_automate_wrapper']['init_org'] = ''
# if users and orgs are being created, set the name of one user and their org in the above attributes
# This will be used by the srb3 terraform modules to export the user name, org name, client pem, and
# org validation pem to other terraform modules
