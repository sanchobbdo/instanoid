require 'erb'

class ErbRenderer
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
    output   = "#{options[:output]}.html"

    self.template = ERB.new(template)
    self.output   = output
  end

  def render
    rendered = template.result(binding)
    File.open(output, 'w') { |f| f.write(rendered) }

    output
  end
end
