# InSpec test for recipe chef_automate_wrapper::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

data = OpenStruct.new(JSON.parse(command('/usr/bin/automate-secrets.sh').stdout))

describe data do
  its('password') { should eq 'zaq12wsx' }
  its('token') { should eq 'thisismytoken' }
  its('username') { should eq 'admin' }
  its('url') { should match %r{^https?://\S+$} }
  its('validation_pem') { should_not eq '' }
  its('validation_client_name') { should match %r{^[a-zA-Z0-9]*-validator$} }
  its('client_pem') { should_not eq '' }
  its('org_name') { should eq 'acmecorp' }
  its('org_url') { should match %r{^https?://\S+/acmecorp$} }
  its('base_url') { should match %r{^https?://\S+$} }
  its('node_name') { should eq 'jdoe' }
end
