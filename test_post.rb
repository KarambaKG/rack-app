require 'net/http'
require 'json'

def create_agent
	begin
	    uri = URI('http://localhost:9292/new')
	    http = Net::HTTP.new(uri.host, uri.port)
	    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	    req.body = {'lang' => 'kz', 'typ' => 'smsotp', 'CODE' => '112as'}.to_json
	    res = http.request(req)
	    return res
	rescue => e
	    puts "failed #{e}"
	end
end
create_agent