module ChefAutomateWrapper
  # Helper for getting user and org pems
  module ServerHelpers
    def self.read_pem(type, name)
      path = case type
             when 'org'
               "/etc/opscode/orgs/#{name}-validation.pem"
             when 'client'
               "/etc/opscode/users/#{name}.pem"
             else
               ''
             end
      ::File.file?(path) ? ::File.read(path) : ''
    end
  end
end
