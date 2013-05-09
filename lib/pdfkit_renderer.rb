require 'erb'
require 'pdfkit'

class PDFKitRenderer
  attr_accessor :data, :template, :output

  class << self
    def render(data, options = {})
      new(data, options).render
    end
  end

  def initialize(data, options = {})
    self.data = data

    raise "Must specify a template." unless options.has_key?(:template)
    raise "Must specify an output."  unless options.has_key?(:output)

    template = options[:template]
    output   = "#{options[:output]}.pdf"

    self.template = template
    self.output   = output
  end

  def render
    html = ERB.new(template).result(binding)

    kit = PDFKit.new(html)
    kit.to_file(output)

    output
  end
end
