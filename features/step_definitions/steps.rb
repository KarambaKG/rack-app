When(/^админ на главной странице$/) do
  visit 'localhost:9292/'
  sleep (4)
end

When(/^кликаю на ссылку "([^"]*)"$/) do |link|
  click_link link
  sleep(0.5)
end
