require 'rack'
require 'json'
require './template'
require 'erb'
class SendMessage

  def initialize(result)
   @result = result
  end
  def self.detect(tempHash)
   tip = tempHash['typ']
   lang = tempHash['lang']
   temp = File.read("templates/#{tip}_#{lang}.json")
   code = tempHash['code']
   map = {"[code]"=> "#{code}", "[tip]"=> "#{tip}"}
   map.each {|k,v| temp.sub!(k,v)}
   File.open("result_#{tip}_#{lang}.json","w") do |f|
    f.write(temp)
   end
    return temp
  end
end