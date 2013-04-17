require 'rubygems'
require 'bundler/setup'

require 'yaml'
require 'instagram'

puts "Instanoid is running."

print "Reading config.yml..."
config = YAML.load_file('config.yml')
print "Done.\n"

print "\n"
config.each_pair { |k, v| puts "#{k}: #{v}" }
print "\n"

Instagram.configure do |c|
  c.client_id = config['client_id']
  c.client_secret = config['client_secret']
end
