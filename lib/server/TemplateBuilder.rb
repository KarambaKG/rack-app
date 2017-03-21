# ROOT_PATH = Dir.pwd + '/lib/server/templates'
class TemplateBuilder

  def initialize(template_path)
    @template_path = template_path
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
      file_edit = FileOperator.file_open(new_filename)
      messageformer = "{\"message\" : \"#{fparams}\"}"
      file_edit << messageformer
      file_edit.close
    elsif FileOperator.file_exist(new_filename)
    else
          FileOperator.file_rename(old_name, new_filename)
          FileOperator.file_rewrite(new_filename, fparams)
    end
  end

  def all_templates
    full_path = "#{ROOT_PATH}/*.json"
    template_files = Dir[full_path].select{ |f| File.file? f }
    template_files.map{ |f| File.basename f ,'.json'}
  end

  def templates_by_type(template_type)
    full_path = "#{@template_path}/#{template_type}_*.json"
    templates = Dir[full_path].select{ |f| File.file? f }.map{ |f| File.basename f ,'.json'}
  end

end