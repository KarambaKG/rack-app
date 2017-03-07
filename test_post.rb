require 'net/http'
require 'json'

def create_agent
    uri = URI('http://localhost:9393/new')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = {'lang' => 'ts', 'typ' => 'kg','phone_number'=> '232323','code' => 'abrakadabra'}.to_json
    res = http.request(req)
    return res
    puts "response #{res.body}"
rescue => e
    puts "failed #{e}"
end
create_agent