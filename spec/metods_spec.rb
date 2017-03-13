require_relative '../metods'
require 'spec_helper'
require 'byebug'
require 'rspec'

describe  Metods do

  before :each do
    @test_templates_path = "#{Dir.pwd}/spec/fixtures/templates_test"
    @metods = Metods.new(@test_templates_path)
    @file_directory = "#{@test_templates_path}/sms1_en.json"
  end

  it 'должен показывать все шаблоны' do
    allow(@metods).to receive(:all_templates).and_return(['a','b'])
    expect(@metods.all_templates).to eql(['a','b'])
  end

  it 'должен прочитать файл' do
    file = @metods.read_file("sms1_en")
    expect(file).to eql("Ok google")
  end

  it 'должен прочитать файл mock' do
    allow(File).to receive(:read).with(@file_directory).and_return("Ok google")
    file = @metods.read_file("sms1_en")
    expect(file).to eql("Ok google")
  end

  it 'переименовать файл' do
    old_file_directory = @file_directory
    new_file_directory = "#{@test_templates_path}/sms5_en.json"
    allow(File).to receive(:rename).with(old_file_directory, new_file_directory).and_return(new_file_directory)
    file = @metods.rename_file("sms1_en", "sms5_en")
    expect(file).to eql(new_file_directory)
  end

  it 'должен удалить файл' do
    allow(File).to receive(:delete).with(@file_directory).and_return(true)
    file = @metods.delete_file("sms1_en")
    expect(file).to eql(true)
  end

  it 'должен открыть файл' do
    allow(File).to receive(:open).with(@file_directory).and_return("Ok google")
    file = @metods.file_open("sms1_en")
    expect(file).to eql("Ok google")
  end

  it 'должен проверить существует ли файл' do
    allow(File).to receive(:exist?).with(@file_directory).and_return("sms1_en")
    file = @metods.file_exist("sms1_en")
    expect(file).to eql("sms1_en")
  end

  it 'должен показывать все кнопки' do
    allow(@metods).to receive(:give_buttons).and_return(['a','b'])
    button = @metods.give_buttons
    expect(button).to eql(['a','b'])
  end

end