require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'json'
require 'net/http'
require 'uri'
require 'rack/app'
require './template'
require './send_message'
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
    arr = []
    params.each do |k,v|
      arr<<v
    end
    ex = SendMessage.detect(Template.new(arr[0],arr[1],arr[2],arr[3]))
    # example: http://localhost:9393/test/?lang=ru&type=sms&phone_number=privet&code=uy
  end

  get '/templates' do
    @templates = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    @template_sort = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    @sort = []
    @template_sort.each do |f|
      item = f.split('_').first
      @sort.push(item)
     end
    render '/views/templates.html.erb'
  end

  get '/templates/:id' do     
    file_params = params['id']
    @templates = Dir["templates/#{file_params}_*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    @template_sort = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}  
    @sort = []
    @template_sort.each do |f|
      item = f.split('_').first
      @sort.push(item)
     end
    render '/views/templates.html.erb'
  end

  get '/show/:id' do
    @file = File.read( File.join(ROOT_PATH,"templates","#{params['id']}.json") )

  end

  get '/delete/:id' do
    filename = params['id'].to_s
    file_params = params['id'].split('_')
    file = File.delete("templates/#{filename}.json") 
    redirect_to '/'
  end

  get '/edit_template/:id' do

    @edit_params = params['id'].split('_')
    @typ = @edit_params.first
    @lang = @edit_params.last
    @old_name = params['id']
    @fparams = File.read("templates/#{@typ}_#{@lang}.json")
    render '/views/edit_template.html.erb'
  end

  post '/edit' do
    @old_name = payload['old_name'].to_s
    @typ = payload['typ']
    @lang = payload['lang']
    @fparams = payload['message'].to_s 
      if @old_name == "#{@typ}_#{@lang}"
      file_edit = File.open("templates/#{@typ}_#{@lang}.json","w")
      file_edit.write(@fparams)
      file_edit.close
      redirect_to "/templates"
      elsif File.exist?("templates/#{@typ}_#{@lang}.json")
        redirect_to request.env["HTTP_REFERER"]
      else
        file = File.rename("templates/#{@old_name}.json","templates/#{@typ}_#{@lang}.json") 
        file_edit = File.open("templates/#{@typ}_#{@lang}.json","w")
        file_edit.write(@fparams)
        file_edit.close
        redirect_to "/templates"
      end 
  end

  get '/new' do
   # file =File.read("sms_en.json")
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
    @typ = payload['typ']
    @lang = payload['lang']
    @message = payload['message'].to_s
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