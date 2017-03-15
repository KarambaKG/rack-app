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
    filename = "#{typ}_#{lang}"
    if old_name == filename
      file_edit = file_open(filename)
      file_edit.write(fparams)
      file_edit.close
      elsif file_exist(filename)
      else
        file = rename_file(old_name, filename) 
        file_edit = file_open(filename)
        file_edit.write(fparams)
        file_edit.close
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

  def read_file(filename)
    full_path = File.join(@template_path,"#{filename}.json")
    file = File.read(full_path)
  end

  def delete_file(filename)
    full_path = "#{@template_path}/#{filename}.json"
    file = File.delete(full_path)
  end

  def file_open(filename)
    full_path = "#{@template_path}/#{filename}.json"
    file_edit = File.open(full_path,"w+")
  end

  def file_exist(filename)
    full_path = "#{@template_path}/#{filename}.json"
    File.exist?(full_path)
  end

  def rename_file(old_name, new_name)
    full_path_old = "#{@template_path}/#{old_name}.json"
    full_path_new = "#{@template_path}/#{new_name}.json"
    file = File.rename(full_path_old,full_path_new)
  end

end

