require 'rack'
require 'json'
require './template'
require 'erb'
class SendMessage

   def initialize(result)
       @result = result
   end
   def self.detect(tempHash)
           tip = tempHash.typ
           lang = tempHash.lang
           temp = File.read("templates/#{tip}_#{lang}.json")
           code = tempHash.code
           filtered_data = temp.gsub("[code]", "#{code}")
           File.open("result_#{tip}_#{lang}.json","w") do |f|
          #  File.open("templates/#{tip}_#{lang}.json","w") do |f|
            f.write(filtered_data)
          end
          #  temp1 = JSON.parse(temp)
          #  temp1.each do |k,v|        
          #   temp1[k] = v % ["#{code}"]
            
          # end
   #        hash = {}
	  # tempHash.instance_variables.each {|var| hash[var.to_s.delete("@")] = tempHash.instance_variable_get(var) }

   #         lastHash = hash.merge(temp1)
   #         file = File.open("result_#{tip}_#{lang}.json","a"){ |f| f << lastHash.to_json }
   #         file.close
       return filtered_data
   end
end