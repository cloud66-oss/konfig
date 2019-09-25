module Konfig
  class NilClass; end

  NIL_VALUE = NilClass.new

  private

  # deserializers. order matters here
  DESERIALIZERS = [
    lambda { |value| Integer(value) rescue NIL_VALUE }, # integer
    lambda { |value| Float(value) rescue NIL_VALUE }, # float
    lambda { |value| (["true", "false"].include?(value)) ? (value == "true") : NIL_VALUE }, # boolean
    lambda { |value| (value == Konfig.configuration.nil_word && Konfig.configuration.allow_nil) ? nil : NIL_VALUE }, # nil value
    lambda do |value|
      value = value.strip
      # on some platforms, JSON.parse returns value for integer and floats. This is incorrect https://www.json.org/
      return NIL_VALUE if !value.start_with?("[") && !value.start_with?("{")

      result = JSON.parse(value, { symbolize_names: true })
      if result == nil && !Konfig.configuration.allow_nil
        return NIL_VALUE
      else
        result
      end
    rescue
      NIL_VALUE
    end, # json
    lambda do |value| # string. should always be the last one
      # in case we have a string, clean it up. For example, quotes in strings should be escaped or will be removed
      Konfig::Utils.remove_quotations(value)
    end,
  ]

  class Utils
    # coreces the given value (string) into the best possible type
    def self.coerce(value)
      # assume a float first
      DESERIALIZERS.each do |deseralizer|
        result = deseralizer.call(value)
        return result unless result == NIL_VALUE
      end

      raise UnsupportedValueType, "'#{value}' is unsupported type"
    end

    def self.remove_quotations(str)
      str = str.slice(1..-1) if str.start_with?('"') || str.start_with?('\'')
      str = str.slice(0..-2) if str.end_with?('"') || str.end_with?('\'')
      return str
    end
  end
end
