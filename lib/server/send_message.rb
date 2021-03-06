require 'rack'
require 'json'
require 'erb'
require 'byebug'

class SendMessage

  def initialize(result)
   @result = result
  end
  def self.arrange(hash,file)
    hash.each {|k,v| file.gsub!("[#{k}]",v)}
  end

  def self.detect(tempHash)
    begin
     tip = tempHash['typ']
     lang = tempHash['lang']
     temp = File.read(ROOT_PATH + "/#{tip}_#{lang}.json")
    rescue => error
      print "Присланный json не соответствует шаблонам на web-сервере. Добавьте новый шаблон в админке, чтобы обработать присланные параметры."
    end
    arrange(tempHash,temp)
    File.open("lib/server/all_formed_messages/result_#{tip}_#{lang}.json","w") do |f|
      f.write(temp)
      print "Сообщение с присланными параметрами успешно сохранено. "
    end
      return temp
  end
end