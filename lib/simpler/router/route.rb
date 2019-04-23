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

      def match?(method, path_from_url)
        return false unless @method == method

        parsed_path = parse @path
        parsed_url = parse path_from_url

        return false unless parsed_path.size == parsed_url.size

        comparison = parsed_path.map.with_index.with_object([]) { |(item, i), arr| arr.push(item == parsed_url[i]) unless item[0] == ':' } 
        return false if comparison.include? false 
        
        true
      end

      def params(path_from_url)
        parsed_path = parse @path
        parsed_url = parse path_from_url
        parsed_path.each.with_index.with_object({}) { |(item, i), params| params[item] = parsed_url[i] if item[0] == ':' }
      end

      private

      def parse(path)
        path.split('/').reject(&:empty?)
      end
    end
  end
end
