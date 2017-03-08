ROOT_PATH = Dir.pwd
class Metods

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

