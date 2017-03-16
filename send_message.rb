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
   tempHash.each do |k,v| temp.gsub!(k,v)
   end
   File.open("result_#{tip}_#{lang}.json","w") do |f|
    f.write(temp)
   end
    return temp
  end
end