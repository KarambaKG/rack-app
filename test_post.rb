require 'net/http'
require 'json'
require 'byebug'

def create_agent
	uri = URI('http://localhost:9292/new')
	http = Net::HTTP.new(uri.host, uri.port)
	req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	req.body = {'lang' => 'ru', 'typ' => 'smsotp', 'CODE' => 'omka'}.to_json
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