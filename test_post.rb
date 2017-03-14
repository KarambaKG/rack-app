require 'net/http'
require 'json'

def create_agent
	begin
	    uri = URI('http://0.0.0.0:9292/new')
	    http = Net::HTTP.new(uri.host, uri.port)
	    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	    req.body = {'lang' => 'en', 'typ' => 'sms','phone_number'=> '232323','code' => '654321'}.to_json
	    res = http.request(req)
	    return res
	rescue => e
	    puts "failed #{e}"
	end
end
create_agent