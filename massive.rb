class Massive

    attr_reader :lang, :typ, :phone_number, :code

def initialize(lang, typ, phone_number, code)
    @lang = lang
    @typ = typ
    @phone_number = phone_number
    @code = code
end

end