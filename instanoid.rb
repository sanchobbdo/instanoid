require 'rubygems'
require 'bundler/setup'

require 'yaml'

puts "Instanoid is running."

print "Reading config.yml..."
config = YAML.load_file('config.yml')
print "Done.\n"

print "\n"
config.each_pair { |k, v| puts "#{k}: #{v}" }
print "\n"

