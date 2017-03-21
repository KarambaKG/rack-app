class TemplateMessenger < Rack::App
  extend Rack::App::FrontEnd

  def initialize
    pwd = "#{Dir.pwd}/lib/server/templates"
    @templateBuilder = TemplateBuilder.new
    @file_operator = FileOperator.new(pwd)
  end

  payload do
    parser do
      accept :json, :www_form_urlencoded
    end
  end

  get '/' do
    render '/lib/server/views/index.html.erb'
  end

  get 'new_template' do
    render '/lib/server/views/new_template.html.erb'
  end

  get '/templates' do
    @templates = @templateBuilder.all_templates
    @sort_button = @templateBuilder.give_buttons
    render '/lib/server/views/templates.html.erb'
  end

  get '/templates/:id' do
    @templates = @templateBuilder.templates_by_type(params['id'])
    @sort_button = @templateBuilder.give_buttons
    render '/lib/server/views/templates.html.erb'
  end

  get '/show/:id' do
    @file = @templateBuilder.give_template(params['id'])
  end

  get '/delete/:id' do
    @file = @file_operator.delete_file(params['id'])
    redirect_to request.env["HTTP_REFERER"]
  end

  get '/edit_template/:id' do
    @name_template = params['id'].split('_')
    @typ = @name_template.first
    @lang = @name_template.last
    @old_name = params['id']
    @file_content = @file_operator.read_file(params['id'])
    @parse_file_content = JSON.parse(@file_content)
    @fparams = @parse_file_content['message']
    render '/lib/server/views/edit_template.html.erb'
  end

  post '/edit' do
    @old_name = payload['old_name'].to_s
    @typ = payload['typ']
    @lang = payload['lang']
    @fparams = payload['message'].to_s
    @templateBuilder.update_template(@old_name, @typ, @lang, @fparams)
    redirect_to '/templates'
  end

  post '/new' do
    @message_saver = SendMessage.detect(payload)
    'ok'
  end

  post '/create' do
    @typ = payload['typ']
    @lang = payload['lang']
    @message = payload['message'].to_s
    filename = "#{@typ}_#{@lang}"
    unless @file_operator.file_exist(filename)
      file = @file_operator.file_open(filename)
      messageformer = "{\"message\" : \"#{@message}\"}"
      file << messageformer
      file.close
      redirect_to '/templates'
    else
      redirect_to request.env["HTTP_REFERER"]
    end
  end

end
