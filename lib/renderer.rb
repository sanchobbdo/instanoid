require 'erb'

class Renderer
  attr_accessor :template

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
    template = options[:template]

    self.template = ERB.new(template)
  end

  def render
    template.result(binding)
  end
end
