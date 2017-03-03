require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'json'
require 'byebug'
require 'net/http'
require 'uri'
require 'rack/app'
require './template'
require './send_message'
require 'erb'
require 'rack/app/front_end'
require 'bootstrap-sass'
# use Rack::Flash
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
    ex = SendMessage.detect(Template.new(arr[0],arr[1],arr[2],arr[3]))
    # example: http://localhost:9292/test/?lang=ru&type=sms&phone_number=privet&code=uy
  end

  get '/templates' do

    @templates = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    # @templates = @templates.select{|x| x.include?("#{sms}")}

    render '/views/templates.html.erb'
  end

  get '/templates/:id' do 
    directory=params['id'].split('_')
    @templates = Dir["templates/#{directory.first}_*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    render '/views/templates.html.erb'
  end

  get '/show/:id' do

    @file = File.read( File.join(ROOT_PATH,"templates","#{params['id']}.json") )

  end

  get '/delete/:id' do
    filename =params['id'].to_s
    directory=params['id'].split('_')
    file= File.delete("templates/#{filename}.json") 
    redirect_to '/'

  end

  get '/edit' do
    render '/edit_input.html.erb'
  end

  get '/new' do
   # file =File.read("sms_en.json")
  end


  get '/delete/:id' do
    directory = params['id'].split('_')
    @file = File.delete( File.join(ROOT_PATH,"templates","#{params['id']}.json"))
    redirect_to request.env["HTTP_REFERER"]
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
  @message = payload['message'].to_s
  @typ = payload['typ']
  @lang = payload['lang']

    unless File.exist?("templates/#{@typ}_#{@lang}.json")
    file = File.new("templates/#{@typ}_#{@lang}.json","w+")
    file<<@message
    file.close
    redirect_to "/templates"  
    else
       redirect_to request.env["HTTP_REFERER"]
    end

end
end

run App