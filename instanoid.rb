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

tag = config['tag']

puts "Asking instagram about the last posted under ##{tag}"
min_tag_id = Instagram.tag_recent_media(tag).pagination.min_tag_id
puts "min_tag_id: #{min_tag_id}"

puts "Start polling ..."
begin
  data = Instagram.tag_recent_media(tag, :min_tag_id => min_tag_id)

  min_tag_id = data.pagination.min_tag_id

  puts "Sleeping (20s)..."
  sleep(20)
  puts "Waking up."
end while true
