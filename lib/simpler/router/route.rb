module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path_from_url, env)
        return false unless @method == method

        parsed_path = @path.split('/').reject(&:empty?)
        parsed_url = path_from_url.split('/').reject(&:empty?)

        return false unless parsed_path.size == parsed_url.size

        parsed_path.map { |item| return false if item =~ /^[^:]./ && item != parsed_url[parsed_path.index(item)] } 
        extract_resource_id(parsed_path, parsed_url, env) 
        true
      end

      private

      def extract_resource_id(parsed_path, parsed_url, env)
        route_params = {}
        parsed_path.map { |item| route_params[item] = parsed_url[parsed_path.index(item)] if item =~ /^(:)./ }
        env["simpler.route_resource_id"] = route_params
      end
    end
  end
end
