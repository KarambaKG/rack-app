require_relative '../lib/server/FileOperator'
require_relative '../lib/server/TemplateBuilder'

require 'spec_helper'
require 'byebug'
require 'rspec'

describe  FileOperator do

  before :each do
    @test_templates_path = "#{Dir.pwd}/spec/fixtures/templates"
    @file_operator = FileOperator.new(@test_templates_path)
    @file_directory = "#{@test_templates_path}/sms1_en.json"
    # @template_builder = TemplateBuilder.new(@test_templates_path)
  end

  it 'должен показывать все шаблоны' do
    allow(@file_operator).to receive(:all_templates).and_return(['a','b'])
    expect(@file_operator.all_templates).to eql(['a','b'])
  end

  it 'должен прочитать файл' do
    file = @file_operator.read_file("sms1_en")
    expect(file).to eql("Ok google")
  end

  it 'должен прочитать файл mock' do
    allow(File).to receive(:read).with(@file_directory).and_return("Ok google")
    file = @file_operator.read_file("sms1_en")
    expect(file).to eql("Ok google")
  end

  it 'переименовать файл' do
    old_file_directory = @file_directory
    new_file_directory = "#{@test_templates_path}/sms5_en.json"
    allow(File).to receive(:rename).with(old_file_directory, new_file_directory).and_return(new_file_directory)
    expect(@file_operator.file_rename("sms1_en", "sms5_en")).to eql(true)
  end

  it 'ошибка при переименовать файл' do
    old_file_directory = @file_directory
    new_file_directory = "#{@test_templates_path}/sms5_en.json"
    # allow(File).to receive(:rename).with('1', new_file_directory).and_return(new_file_directory)
    expect{ raise @file_operator.file_rename("1", "sms5_en") }.to raise_error('File not exist')
  end

  it 'должен удалить файл' do
    allow(File).to receive(:delete).with(@file_directory).and_return(true)
    file = @file_operator.delete_file("sms1_en")
    expect(file).to eql(true)
  end

  it 'должен открыть файл' do
    allow(File).to receive(:open).with(@file_directory, 'w+').and_return(false)
    file = @file_operator.file_rewrite("sms1_en", "w+")
    expect(file).to eql(false)
  end

  it 'должен проверить существует ли файл' do
    allow(File).to receive(:exist?).with(@file_directory).and_return("sms1_en")
    file = @file_operator.file_exist("sms1_en")
    expect(file).to eql("sms1_en")
  end

  # it 'должен обновить шаблон' do
  #   old_name = "sms1_en"
  #   typ = "sms1"
  #   lang = "en"
  #   fparams = "Ok google"
  #   filename = "#{typ}_#{lang}"
  #   k = @file_operator.update_template(old_name, typ, lang, fparams)
  #   k
  # end

end