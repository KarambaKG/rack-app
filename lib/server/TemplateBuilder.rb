class TemplateBuilder

  def initialize
    @template_path = Dir.pwd + '/lib/server/templates'
    @file_operator = FileOperator.new(@template_path)
  end

  def give_template(template_name)
    @file_operator.read_file(template_name)
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

  def update_template(old_name, typ, lang, fparams)
    new_filename = "#{typ}_#{lang}"
    if old_name == new_filename
      # file_edit = FileOperator.file_open(new_filename)
      file_edit = @file_operator.file_open(new_filename)
      messageformer = "{\"message\" : \"#{fparams}\"}"
      file_edit << messageformer
      file_edit.close
    elsif @file_operator.file_exist(new_filename)
    else
          @file_operator.file_rename(old_name, new_filename)
          @file_operator.file_rewrite(new_filename, fparams)
    end
  end

  def all_templates
    full_path = "#{@template_path}/*.json"
    template_files = Dir[full_path].select{ |f| File.file? f }
    template_files.map{ |f| File.basename f ,'.json'}
  end

  def templates_by_type(template_type)
    full_path = "#{@template_path}/#{template_type}_*.json"
    templates = Dir[full_path].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
  end

end