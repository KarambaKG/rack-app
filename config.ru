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
get '/' do
  render '/views/index.html.erb'
end

get '/test' do
  arr =[]
  params.each do |k,v|
    arr<<v
end
  ex = Maksim.detect(Massive.new(arr[0],arr[1],arr[2],arr[3]))
  # example: http://localhost:9292/test/?lang=ru&type=sms&phone_number=privet&code=uy
end

get '/sms' do
  @templates = Dir["sms/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
  render '/views/sms.html.erb'
end

get '/email' do
   @templates = Dir["email/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
  render '/views/email.html.erb'
end

get '/edit' do
  render '/edit_input.html.erb'
end

get '/new' do
 file =File.read("sms_en.json")
end

end

run App