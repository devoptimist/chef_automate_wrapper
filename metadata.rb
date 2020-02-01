name 'chef_automate_wrapper'
maintainer 'Steve Brown'
maintainer_email 'sbrown@chef.io'
license 'Apache-2.0'
description 'Installs/Configures a chef automate server'
long_description 'Installs/Configures a chef automate server'
version '0.1.9'
chef_version '>= 13.0'
depends 'chef-ingredient'

%w(redhat centos debian ubuntu).each do |os|
  supports os
end

issues_url 'https://github.com/devoptimist/chef_automate_wrapper/issues'
source_url 'https://github.com/devoptimist/chef_automate_wrapper'
