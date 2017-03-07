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
   filtered_data = filtered_data.gsub("[tip]", "#{tip}")
   File.open("result_#{tip}_#{lang}.json","w") do |f|
    f.write(filtered_data)
   end
    return filtered_data
  end
end