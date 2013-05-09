require 'erb'

class Renderer
  attr_accessor :template, :output

  class << self
    def render(vars, options = {})
      new(vars, options).render
    end
  end

  def metaclass
    class << self
      self
    end
  end

  def initialize(vars, options = {})
    vars.each_pair do |k, v|
      metaclass.send :attr_accessor, k
      send "#{k}=", v
    end

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
