class Massive

    attr_reader :lang, :type, :phone_number, :code

def initialize(lang, type, phone_number, code)
    @lang = lang
    @type = type
    @phone_number = phone_number
    @code = code
end

end