ROOT_PATH = Dir.pwd + '/lib/server/templates'
class FileOperator

  def initialize(template_path)
    @template_path = template_path
  end

  def self.file_open(filename)
    full_path = ROOT_PATH + "/#{filename}.json"
    file_edit = File.open(full_path, "w")
  end

  def self.read_file(filename)
    full_path = File.join(ROOT_PATH + "/#{filename}.json")
    file = File.read(full_path)
  end

  def delete_file(filename)
    full_path = "#{@template_path}/#{filename}.json"
    file = File.delete(full_path)
  end

  def self.file_rewrite(filename, text)
    text = "#{@fparams}"
    full_path = ROOT_PATH + "/#{filename}.json"
    File.open(full_path, 'w+') do |file|
      file.write(text)
      file.close
    end
  end

  def self.file_rename(old_name, new_name)
    full_path_old = ROOT_PATH + "/#{old_name}.json"
    full_path_new = ROOT_PATH + "/#{new_name}.json"
    begin
      file = File.rename(full_path_old,full_path_new)
      true
    rescue => e
      Exception.new('File not exist')
    end
  end

  def self.file_exist(filename)
    full_path = ROOT_PATH + "/#{filename}.json"
    File.exist?(full_path)
  end

end