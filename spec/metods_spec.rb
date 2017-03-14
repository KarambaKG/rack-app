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
    expect(@metods.file_rename("sms1_en", "sms5_en")).to eql(true)
  end

  it 'ошибка при переименовать файл' do
    old_file_directory = @file_directory
    new_file_directory = "#{@test_templates_path}/sms5_en.json"
    # allow(File).to receive(:rename).with('1', new_file_directory).and_return(new_file_directory)
    expect{ raise @metods.file_rename("1", "sms5_en") }.to raise_error('File not exist')
  end

  it 'должен удалить файл' do
    allow(File).to receive(:delete).with(@file_directory).and_return(true)
    file = @metods.delete_file("sms1_en")
    expect(file).to eql(true)
  end

  it 'должен открыть файл' do
    allow(File).to receive(:open).with(@file_directory, 'w+').and_return(false)
    file = @metods.file_rewrite("sms1_en", "w+")
    expect(file).to eql(false)
  end

  it 'должен проверить существует ли файл' do
    allow(File).to receive(:exist?).with(@file_directory).and_return("sms1_en")
    file = @metods.file_exist("sms1_en")
    expect(file).to eql("sms1_en")
  end

  it 'должен обновить шаблон' do
    old_name = "sms1_en"
    typ = "sms1"
    lang = "en"
    fparams = "Ok google"
    filename = "#{typ}_#{lang}"
    # allow(@metods).to receive(:file_open).with(filename).and_return("Ok google")
    #
    # allow(@metods).to receive(:write).with(fparams).end_return("Message Hello")

    k = @metods.update_template(old_name, typ, lang, fparams)
    k
    # open_file = @metods.file_open("sms1_en", fparams)
    # expect(open_file).to eql("Ok google")
  end

end