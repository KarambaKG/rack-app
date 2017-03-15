require 'net/http'
require 'json'


def create_agent	
	
	begin
		# "192" "168" "40" "63"
		# @w = ARGV[0].to_i
		# @w1 = ARGV[1].to_i
		# @w2 = ARGV[2].to_i
		# @w3 = ARGV[3].to_i
		var = rand(0..10000)
	     # uri = URI("http://#{@w}.#{@w1}.#{@w2}.#{@w3}:9292/new")
	    uri = URI("http://192.168.40.63:9292/new")
	    http = Net::HTTP.new(uri.host, uri.port)
	    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	    req.body = {'lang' => 'en', 'typ' => 'sms','phone_number'=> '232323','code' => "#{var}"}.to_json
	    res = http.request(req)
	    return res
	rescue => e
	    puts "failed #{e}"
	end
end
create_agent