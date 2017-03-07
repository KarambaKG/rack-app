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
    # example: http://localhost:9393/test/?lang=ru&type=sms&phone_number=privet&code=uy
  end

  get '/templates' do
    @templates = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    @template_sort = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    # @templates = @templates.select{|x| x.include?("#{sms}")}
    @sort=[]
    @template_sort.each do |f|
      item=f.split('_').first
      @sort.push(item)
     end
    render '/views/templates.html.erb'
  end

  get '/templates/:id' do     
    directory=params['id']
    @templates = Dir["templates/#{directory}_*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
    @template_sort = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}  
    @sort=[]
    @template_sort.each do |f|
      item=f.split('_').first
      @sort.push(item)
     end
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

  get '/edit_template/:id' do

    @qwqw = params['id'].split('_')
    @typ = @qwqw.first
    @lang = @qwqw.last
    @old_name = params['id']
    @fparams = File.read("templates/#{@typ}_#{@lang}.json")
    # @fparams = JSON.parse(@fparams).to_s
    
    # @fparams = @fparams.to_json# @fparams = JSON.parse(file)
    render '/views/edit_template.html.erb'
  end


  post '/edit' do
    @old_name = payload['old_name'].to_s
    @typ = payload['typ']
    @lang = payload['lang']
    @fparams = payload['message'].to_s
    # unless File.exist?("templates/#{@typ}_#{@lang}.json")
    # file = File.rename("templates/#{@old_name}.json","templates/#{@typ}_#{@lang}.json") 
    if @old_name == "#{@typ}_#{@lang}"
    file2 = File.open("templates/#{@typ}_#{@lang}.json","w")
    file2.write(@fparams)
    file2.close
    redirect_to "/templates"
    elsif File.exist?("templates/#{@typ}_#{@lang}.json")
      redirect_to request.env["HTTP_REFERER"]
    else
      file = File.rename("templates/#{@old_name}.json","templates/#{@typ}_#{@lang}.json") 
      file2 = File.open("templates/#{@typ}_#{@lang}.json","w")
      file2.write(@fparams)
      file2.close
      redirect_to "/templates"
      # redirect_to request.env["HTTP_REFERER"]
    end 
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