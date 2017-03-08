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
require 'pry'
require './metods'

ROOT_PATH = Dir.pwd

class App < Rack::App
  extend Rack::App::FrontEnd

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
    @templates = all_templates
    @sort_button = give_buttons
    render '/views/templates.html.erb'
  end

  get '/templates/:id' do     
    @templates = templates_by_type(params['id'])
    @sort_button = give_buttons
    render '/views/templates.html.erb'
  end

  get '/show/:id' do
    @file = read_file(params['id'])
  end

  get '/delete/:id' do
    @file= delete_file(params['id']) 
    redirect_to request.env["HTTP_REFERER"]
  end

  get '/edit_template/:id' do
    @edit_params = params['id'].split('_')
    @typ = @edit_params.first
    @lang = @edit_params.last
    @old_name = params['id']
    @fparams = read_file(params['id'])
    render '/views/edit_template.html.erb'
  end

  post '/edit' do
    @old_name = payload['old_name'].to_s
    @typ = payload['typ']
    @lang = payload['lang']
    @fparams = payload['message'].to_s 
    filename = "#{@typ}_#{@lang}"
      if @old_name == filename
      file_edit = file_open(filename)
      file_edit.write(@fparams)
      file_edit.close
      redirect_to "/templates"
      elsif file_exist(filename)
        redirect_to request.env["HTTP_REFERER"]
      else
        file = rename_file(@old_name, filename) 
        file_edit = file_open(filename)
        file_edit.write(@fparams)
        file_edit.close
        redirect_to "/templates"
      end 
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
      unless file_exist(filename)
      file = file_open(filename)
      file << @message
      file.close
      redirect_to "/templates"  
      else
         redirect_to request.env["HTTP_REFERER"]
      end
  end

  def give_buttons
    template_sort = all_templates
    buttons = []
    template_sort.each do |f|
      item = f.split('_').first
      buttons.push(item)
     end
    return buttons
  end

  def all_templates
    templates = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
  end

  def templates_by_type(template_type)
    templates = Dir["templates/#{template_type}_*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
  end

  def read_file(filename)
    file = File.read( File.join(ROOT_PATH,"templates","#{filename}.json") )
  end

  def delete_file(filename)
    file= File.delete("templates/#{filename}.json")
  end

  def file_open(filename)
   file_edit = File.open("templates/#{filename}.json","w") 
  end

  def file_exist(filename)
    File.exist?("templates/#{filename}.json")    
  end

  def rename_file(old_name, new_name)
    file = File.rename("templates/#{old_name}.json","templates/#{new_name}.json")
  end

end

run App