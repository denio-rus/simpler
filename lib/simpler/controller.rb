require_relative 'view'

module Simpler
  class Controller

    CONTENT_TYPE_LIST = { plain: "text/plain", html: "text/html"}
    CONTENT_TYPE_LIST.default = 'unknown type'
    CONTENT_TYPE_LIST.freeze
    
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end  

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      
      set_default_headers

      send(action)
      write_response
      
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= CONTENT_TYPE_LIST[:html]
    end

    def write_response
      body = render_body 

      @response.write(body)
    end

    def render_body
      @response['Content-Type'] = CONTENT_TYPE_LIST[@request.env['simpler.rendering_options']] if @request.env['simpler.rendering_options']
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge @request.env["simpler.route_params"]
    end

    def render(options)
      return @request.env['simpler.template'] = options unless options.is_a?(Hash)

      @request.env['simpler.rendering_options'], @request.env['simpler.rendering_value'] = options.first
    end

    def set_response_status(status)
      @response.status = status.to_i
    end

    def set_custom_headers(headers)
      headers.each_pair { |key, value| @response[key.to_s] = value.to_s }
    end
  end
end
