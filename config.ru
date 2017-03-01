require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'json'
require 'net/http'
require 'uri'
require 'rack/app'
require './massive'
require './maksim'
require 'erb'
require 'rack/app/front_end'
require 'bootstrap-sass'

class App < Rack::App
  extend Rack::App::FrontEnd

 

desc 'health check endpoint'
get '/' do 
  ex = Maksim.detect(Massive.new("en","sms","23323232","your_code_is_3333"))
  end
get '/test' do
  arr =[]
  params.each do |k,v|
    arr<<v
end
  ex = Maksim.detect(Massive.new(arr[0],arr[1],arr[2],arr[3]))
  # example: http://localhost:9292/test/?lang=ru&type=sms&phone_number=privet&code=uy
end
get '/some_url' do
    render '/index.html.erb'
end
get '/admin' do
  render '/admin.html.erb'
end
get '/sms' do
  render '/sms.html.erb'
end
get '/edit' do
  render '/edit_input.html.erb'
end

get '/new' do
 file =File.read("sms_en.json")
end

end

run App