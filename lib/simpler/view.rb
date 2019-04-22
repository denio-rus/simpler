require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if @env['simpler.rendering_options'] == :plain
        render_plain_text
      else
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
    end

    def render_plain_text
      @env['simpler.rendering_value']
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
