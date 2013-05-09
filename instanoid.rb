$:.unshift(File.dirname(__FILE__)+'/lib')

require 'rubygems'
require 'bundler/setup'

require 'hashie'
require 'yaml'
require 'instagram'
require 'open-uri'
require 'cupsffi'

require 'instanoid'
require 'prawn_renderer'

puts "Instanoid is running."

Instanoid.config do
  parameter :client_id
  parameter :client_secret
  parameter :tag
  parameter :printer
  parameter :renderer
end

if File.exist?('config.rb')
  print "Reading config.rb..."
  require 'config' if File.exist?('config.rb')
  print "Done.\n"
else
  puts 'No config file found' unless File.exist?('config.rb')
end

printer = CupsPrinter.new(Instanoid.printer)

Instagram.configure do |c|
  c.client_id = Instanoid.client_id
  c.client_secret = Instanoid.client_secret
end

tag = Instanoid.tag

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
    filename = PrawnRenderer.render(entry, Instanoid.renderer)
    print " Done.\n"

    print "Printing entry #{i}..."
    printer.print_file(filename)
    print " Done.\n"
  end

  min_tag_id = entries.pagination.min_tag_id if entries.pagination.min_tag_id

  puts "Sleeping (20s)..."
  sleep(20)
  puts "Waking up."
end while true
