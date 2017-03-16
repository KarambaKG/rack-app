When(/^админ на главной странице$/) do
  visit 'localhost:9292/'
  sleep (1)
end

When(/^кликаю на ссылку "([^"]*)"$/) do |link|
  click_link link
  sleep(1)
end

When(/^кликаю на первую ссылку "([^"]*)"$/) do |link|
  first(:link, link).click
  sleep(3)
end

When(/^ввожу в поле "([^"]*)" текст "([^"]*)"$/) do |field, value|
  fill_in field, with:value
  sleep(0.5)
end

When(/^кликаю на кнопку "([^"]*)"$/) do |button|
  click_button button
  sleep(0.5)
end

When(/^должен увидеть текст "([^"]*)"$/) do |text|
  page.assert_text(text)
  sleep(1.5)
end

When(/^должен не увидеть текст "([^"]*)"$/) do |text|
  page.assert_no_text(text)
  sleep(0.5)
end