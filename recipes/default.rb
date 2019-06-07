#
# Cookbook:: chef_automate_wrapper
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

chef_automatev2 'chef-automate' do
  channel node['chef_automate_wrapper']['channel'].to_sym
  version node['chef_automate_wrapper']['version']
  config node['chef_automate_wrapper']['config']
  accept_license node['chef_automate_wrapper']['accept_license'].to_s == 'true'
end
