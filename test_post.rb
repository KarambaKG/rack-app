require 'net/http'
require 'json'

def create_agent
	begin
	    uri = URI('http://192.168.40.92:9292/new')
	    http = Net::HTTP.new(uri.host, uri.port)
	    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	    req.body = {'lang' => 'ru', 'typ' => 'smsotp','CODE' => 'test_console'}.to_json
	    res = http.request(req)
	    return res
	rescue => e
	    puts "failed #{e}"
	end
end
create_agent