require 'rubygems'
require 'rack'
require 'json'
require 'net/http'
require 'uri'
require 'rack/app'
require 'erb'
require 'rack/app/front_end'
require 'bootstrap-sass'
require 'pry'
require './template'
require './send_message'
require './metods'

class App < Rack::App
  extend Rack::App::FrontEnd

  def initialize
    pwd = "#{Dir.pwd}/templates"
    @metods = Metods.new(pwd)
  end

  payload do
     parser do
       accept :json, :www_form_urlencoded
     end
   end

  get '/' do
    render '/views/index.html.erb'
  end

  get '/new_template' do
    render '/views/new_template.html.erb'
  end

  get '/test' do
    arr = []
    params.each do |k,v|
      arr << v
    end
    ex = SendMessage.detect(Template.new(arr[0],arr[1],arr[2],arr[3]))
    # example: http://localhost:9393/test/?lang=ru&typ=sms&phone_number=privet&code=uy
  end

  get '/templates' do
    @templates = @metods.all_templates

    @sort_button = @metods.give_buttons
    render '/views/templates.html.erb'
  end

  get '/templates/:id' do     
    @templates = @metods.templates_by_type(params['id'])
    @sort_button = give_buttons
    render '/views/templates.html.erb'
  end

  get '/show/:id' do
    @file = @metods.read_file(params['id'])
  end

  get '/delete/:id' do
    @file = @metods.delete_file(params['id']) 
    redirect_to request.env["HTTP_REFERER"]
  end

  get '/edit_template/:id' do
    @edit_params = params['id'].split('_')
    @typ = @edit_params.first
    @lang = @edit_params.last
    @old_name = params['id']
    @fparams = @metods.read_file(params['id'])
    render '/views/edit_template.html.erb'
  end

  post '/edit' do
    @old_name = payload['old_name'].to_s
    @typ = payload['typ']
    @lang = payload['lang']
    @fparams = payload['message'].to_s 
    @metods.update_template(@old_name, @typ, @lang, @fparams) 
    redirect_to "/templates" 
  end

  post '/new' do
    @message_saver = SendMessage.detect(payload) 
  end

  # use Rack::Auth::Basic do |username, password|
  #   username == 'maksim'
  #   password == 'secret'
  # end

  post '/create' do 
    @typ = payload['typ']
    @lang = payload['lang']
    @message = payload['message'].to_s
    filename = "#{@typ}_#{@lang}"
      unless @metods.file_exist(filename)
      file = @metods.file_open(filename)
      file << @message
      file.close
      redirect_to "/templates"  
      else
         redirect_to request.env["HTTP_REFERER"]
      end
  end

end

run App