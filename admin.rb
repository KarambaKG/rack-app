require 'rack'
get '/' do
	render '/views/index.html.erb'
end

get '/new_template' do
	@new_template = Admin.new
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
	@template_sort = Dir["templates/*.json"].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
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
	@fparams = File.read("templates/#{@typ}_#{@lang}.json")
	render '/views/edit_template.html.erb'
end


post '/edit' do
	@typ = payload['typ']
	@lang = payload['lang']
	@fparams = payload['message'].to_s
	file = File.open("templates/#{@typ}_#{@lang}.json","w+")
	file<<@fparams
	file.close
	redirect_to "/templates"  
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
class Admin
	def initialize(params)
		@params = params
	end

	def update

	end

	def new

	end

	def show

	end

	def create

	end

end