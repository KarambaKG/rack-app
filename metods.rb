ROOT_PATH = Dir.pwd
class Metods

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
      file_edit = file_open(new_filename)
      messageformer = "{\"message\" : \"#{fparams}\"}"
      file_edit << messageformer
      # file_edit.write(fparams)
      file_edit.close
      # file_rewrite(new_filename, fparams)
    elsif file_exist(new_filename)
    else
      file_rename(old_name, new_filename)
      file_rewrite(new_filename, fparams)
    end
  end

  def file_open(filename)
    full_path = "#{@template_path}/#{filename}.json"
    file_edit = File.open(full_path, "w")
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

  def read_file(filename)
    full_path = File.join(@template_path,"#{filename}.json")
    file = File.read(full_path)
  end

  def delete_file(filename)
    full_path = "#{@template_path}/#{filename}.json"
    file = File.delete(full_path)
  end

  def file_rewrite(filename, text)
    text = "#{@fparams}"
    full_path = "#{@template_path}/#{filename}.json"
    File.open(full_path, 'w+') do |file|
      file.write(text)
      file.close
    end

    # f = File.open(full_path, 'w+'){|f| f.read}
    # f == text ? true : false
  end

  # def file_rewrite(filename, text)
  #   full_path = "#{@template_path}/#{filename}.json"
  #   f = File.open(full_path, 'w+'){|f| f.read}
  #   f == text ? true : false
  #   f.write(text)
  # end


  def file_exist(filename)
    full_path = "#{@template_path}/#{filename}.json"
    File.exist?(full_path)
  end

  def file_rename(old_name, new_name)
    full_path_old = "#{@template_path}/#{old_name}.json"
    full_path_new = "#{@template_path}/#{new_name}.json"
    begin
      file = File.rename(full_path_old,full_path_new)
      true
    rescue => e
      Exception.new('File not exist')
    end
  end

end

