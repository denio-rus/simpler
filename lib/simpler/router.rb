require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = convert_path_to_route_form(env)
  
      @routes.find { |route| route.match?(method, path) }
    end

    def resource_id(env)
      path_elements_array = env['PATH_INFO'].downcase.split('/')
      path_elements_array.shift
 
      size = path_elements_array.size
      route_params = {}

      n = 0 
      while n < size do
        if n.even?
          controller_name = path_elements_array[n]
        elsif n.odd? && n + 1 == size
          resource_id = ":id"
        else
          resource_id = ":#{controller_name}_id"
        end
        route_params["#{resource_id}"] = path_elements_array[n] if n.odd?
        n += 1
      end 
      route_params
    end

    private

    def convert_path_to_route_form(env)
      path_elements_array = env['PATH_INFO'].downcase.split('/')
      path_elements_array.shift

      path = []
      size = path_elements_array.size

      n = 0
      while n < size do 
        if n.even? 
          path << path_elements_array[n]
        elsif n.odd? && n + 1 == size
          path << ":id"
        else 
          path << ":#{path_elements_array[n-1]}_id" 
        end
        n += 1
      end
      '/' + path.join('/')
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end    
  end
end
