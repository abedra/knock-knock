require 'rack'
require 'logger'

class KnockKnock
  def call(env)
    [200, {"Content-Type" => "text/html"}, [env.inspect]]
  end
end

run KnockKnock.new
