require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'json'
require 'net/http'
require 'rack/app'
require 'erb'
require 'byebug'
require 'rack/app/front_end'
require 'bootstrap-sass'

class App < Rack::App
  extend Rack::App::FrontEnd

  get '/index' do
    render 'views/index.html.erb'
  end

  get '/sms' do
    render '/sms.html.erb'
  end

  get '/email' do
    render '/email.html.erb'
  end

  get '/' do
    array = [{
              "lang" => "ru",
              "type" => "sms",
              "phone_number" => "0555121212",
              "code" => 'RU'
            },
            {
              "lang" => "en",
              "type" => "sms",
              "phone_number" => "0555121212",
              "code" => 'EN'
            }]
    a = rand(0..array.size-1)
    result=array[a]

    def detect(tempHash)
      tip = tempHash["type"]
      lang = tempHash["lang"]
      temp = File.read('/home/maxim/RubymineProjects/server/sms/'"#{tip}_#{lang}.json")
      qw = tempHash["code"]
      temp1 = eval(temp)
      temp1.each do |k,v|
        temp1[k] = v % ["#{qw}"]
      end
      lastHash = tempHash.merge(temp1)
      file = File.open("result_#{tip}_#{lang}.json", "w"){ |f| f << lastHash.to_json }
      file.close
      return lastHash['message']
    end
    p detect(result)

  end

  get '/hello' do
    File.read('/home/maxim/RubymineProjects/server/sms/sms_ru.json')
  end

end
run App