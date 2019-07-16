module Konfig
  class NilClass; end

  NIL_VALUE = NilClass.new

  private

  # deserializers. order matters here
  DESERIALIZERS = [
    lambda { |value| Integer(value) rescue NIL_VALUE }, # integer
    lambda { |value| Float(value) rescue NIL_VALUE }, # float
    lambda { |value| (["true", "false"].include?(value)) ? (value == "true") : NIL_VALUE }, # boolean
    lambda { |value| DateTime.parse(value) rescue NIL_VALUE }, # date time
    lambda { |value| (value == Konfig.configuration.nil_word && Konfig.configuration.allow_nil) ? nil : NIL_VALUE }, # nil value
    lambda do |value|
      result = JSON.parse(value, { symbolize_names: true })
      if result == nil && !Konfig.configuration.allow_nil
        return NIL_VALUE
      else
        result
      end
    rescue
      NIL_VALUE
    end, # json
    lambda { |value| value }, # string. should always be the last one
  ]

  class Utils
    def self.coerce(value)
      # assume a float first
      DESERIALIZERS.each do |deseralizer|
        result = deseralizer.call(value)
        return result unless result == NIL_VALUE
      end

      raise UnsupportedValueType, "'#{value}' is unsupported type"
    end
  end
end
