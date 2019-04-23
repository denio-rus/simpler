require "logger"

class AppLogger

  def initialize(app)
    @logger = Logger.new('log/app.log')
    @app = app
  end

  def call(env)
    log_request(env)
    status, headers, body = @app.call(env)
    log_response(status, headers, env)
    [status, headers, body]
  end

  private 

  def log_request(env)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
    @logger.info("Parameters: #{env['QUERY_STRING'].split('&').map{|n| n.split('=')}.to_h}")
  end

  def log_response(status, headers, env)
    handler = "#{env['simpler.controller'].name}##{env['simpler.action']}"
    @logger.info("Handler: #{handler}")
    @logger.info("Response: #{status} [#{headers["Content-Type"]}] "\
                 "#{env['simpler.template'] || handler.gsub('#', '/') unless env['simpler.rendering_options']}")
  end
end