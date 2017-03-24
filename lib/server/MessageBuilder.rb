class MessageBuilder

  def initialize
    @template_path = Dir.pwd + '/lib/server/templates'
    @file_operator = FileOperator.new(@template_path)
  end

  def render_message(payload)
    @typ = payload['typ']
    @lang = payload['lang']
    @message = payload['message'].to_s
    filename = "#{@typ}_#{@lang}"
    unless @file_operator.file_exist(filename)
      @file = @file_operator.file_open(filename)
      messageformer = "{\"message\" : \"#{@message}\"}"
      @file << messageformer
      @file.close
      return true
    else
      return false
    end
  end

end