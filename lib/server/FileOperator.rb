class FileOperator

  def initialize(template_path)
    @template_path = template_path
  end

  def file_open(filename)
    full_path = @template_path + "/#{filename}.json"
    file_edit = File.open(full_path, "w")
  end

  def read_file(filename)
    full_path = File.join(@template_path+ "/#{filename}.json")
    file = File.read(full_path)
  end

  def delete_file(filename)
    full_path = "#{@template_path}/#{filename}.json"
    file = File.delete(full_path)
  end

  def file_rewrite(filename, text)
    full_path = @template_path + "/#{filename}.json"
    File.open(full_path, 'w+') do |file|
      messageformer = "{\"message\" : \"#{text}\"}"
      file << messageformer
      file.close
    end
  end

  def file_rename(old_name, new_name)
    full_path_old = @template_path + "/#{old_name}.json"
    full_path_new = @template_path + "/#{new_name}.json"
    begin
      file = File.rename(full_path_old,full_path_new)
      true
    rescue => e
      Exception.new('File not exist')
    end
  end

  def file_exist(filename)
    full_path = @template_path + "/#{filename}.json"
    File.exist?(full_path)
  end

end