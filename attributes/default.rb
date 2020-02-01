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
