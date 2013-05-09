$:.unshift(File.dirname(__FILE__)+'/lib')

require 'rubygems'
require 'bundler/setup'

require 'yaml'
require 'instagram'
require 'open-uri'
require 'cupsffi'

require 'renderer'

puts "Instanoid is running."

print "Reading config.yml..."
config = YAML.load_file('config.yml')
print "Done.\n"

print "\n"
config.each_pair { |k, v| puts "#{k}: #{v}" }
print "\n"

printer = CupsPrinter.new(config['printer'])

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
  print "Getting new pictures..."

  entries = Instagram.tag_recent_media(tag, :min_tag_id => min_tag_id)
  print " #{entries.count} found.\n"

  entries.each_with_index do |entry, i|
    print "Rendering entry #{i}..."

    rendered = Renderer.render(entry, File.read(config['template']))
    File.open('.temp.html', 'w') { |f| f.write(rendered) }

    print " Done.\n"

    print "Printing entry #{i}..."
    printer.print_file('.temp.html')
    print " Done.\n"
  end

  min_tag_id = entries.pagination.min_tag_id if entries.pagination.min_tag_id

  puts "Sleeping (20s)..."
  sleep(20)
  puts "Waking up."
end while true
