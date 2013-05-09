require 'prawn'

class PrawnRenderer
  attr_accessor :template, :output, :data

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
    Prawn::Document.generate(output) { |pdf| template.call(pdf, data) }
    output
  end
end
