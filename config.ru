require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'json'
require 'byebug'
require 'net/http'
require 'uri'
require 'rack/app'
require './massive'
require './maksim'
require 'erb'
require 'rack/app/front_end'
require 'bootstrap-sass'

ROOT_PATH = Dir.pwd

class App < Rack::App
  extend Rack::App::FrontEnd
  get '/' do
    render '/views/index.html.erb'
  end


get '/new_template' do
  render '/views/new_template.html.erb'
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

  get '/show/:id' do
    directory = params['id'].split('_')
    @file = File.read( File.join(ROOT_PATH,"#{directory.first}","#{params['id']}.json") )
        #render '/views/show.html.erb'
  end

  get '/edit' do
    render '/edit_input.html.erb'
  end

  get '/new' do
   file =File.read("sms_en.json")
  end


  payload do
     parser do
       accept :json, :www_form_urlencoded
     end
   end
   use Rack::Auth::Basic do |username, password|
    username == 'maksim'
    password == 'secret'
  end

  post '/create' do
    @message = payload['message']
    @typ = payload['typ']
    @lang = payload['lang']
    direc = "#{@typ.to_s}_#{@lang.to_s}"

    file = File.new("#{@typ}/#{@typ}_#{@lang}.json","w+")
    file<<@message.to_json
    file.close
    redirect_to '/'
  end

  get '/delete/:id' do
    directory = params['id'].split('_')
    @file = File.delete( File.join(ROOT_PATH,"#{directory.first}","#{params['id']}.json"))
    redirect_to '/'
  end


end

run App