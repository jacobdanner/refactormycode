use Rack::CommonLogger, STDOUT

run Rack::Adapter::Rails.new