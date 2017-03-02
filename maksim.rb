require 'rack'
require 'json'
require './massive'
class Maksim

   def initialize(result)
       @result = result
   end

  # sms_ru = Massive.new("ru","sms","0555556656","RU")
  # sms_en = Massive.new("en","sms","0555556656","EN")
 
   # array = [sms_ru,sms_en]
   # a = rand(0..1)
   #     @result = array[a]
       def self.detect(tempHash)
               tip = tempHash.typ
               lang = tempHash.lang
               temp = File.read("#{tip}/#{tip}_#{lang}.json")
               qw = tempHash.code
               temp1 = JSON.parse(temp)
               temp1.each do |k,v|        
                temp1[k] = v % ["#{qw}"]
              end
              hash = {}
			  tempHash.instance_variables.each {|var| hash[var.to_s.delete("@")] = tempHash.instance_variable_get(var) }

               lastHash = hash.merge(temp1)
               # lastHash = [tempHash.type,tempHash.lang,tempHash.phone_number,tempHash.code,temp1]
               file = File.open("result_#{tip}_#{lang}.json","a"){ |f| f << lastHash.to_json }
               file.close
               # p lastHash['message']
           return lastHash
       end
    # p self.detect(@result)
end