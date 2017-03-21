require 'net/http'
require 'json'
require 'byebug'

def create_agent
	lang = ARGV[0]
	typ = ARGV[1]
	var = rand(0..10000)
	uri = URI('http://localhost:9292/new')
	http = Net::HTTP.new(uri.host, uri.port)
	req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')

	req.body = {'lang' => "#{lang}", 'typ' => "#{typ}",'CODE' => "#{var}",'phone_number'=> '232323'  }.to_json
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

