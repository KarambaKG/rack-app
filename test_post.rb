require 'net/http'
require 'json'
require 'pry'

def create_agent
	ip_address = ARGV[1]
	all_params = Hash.new
	ARGV.each {|arg| c=arg.split('='); all_params[c[0]]=c[1] }
	uri = URI("http://#{ip_address}:9292/new")
	http = Net::HTTP.new(uri.host, uri.port)
	req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	req.body = all_params.to_json
	res = http.request(req)
	if res.kind_of? Net::HTTPSuccess
		p "JSON параметры успешно отправлены"
		p res
	else
		p 'ups! Что то пошло не так('
		p res
	end

end
create_agent