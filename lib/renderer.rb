require 'erb'

class Renderer
  attr_accessor :template

  class << self
    def render(vars, template)
      new(vars, template).render
    end
  end

  def metaclass
    class << self
      self
    end
  end

  def initialize(vars, template)
    vars.each_pair do |k, v| 
      metaclass.send :attr_accessor, k
      send "#{k}=", v
    end

    self.template = ERB.new(template)
  end

  def render
    template.result(binding)
  end
end
