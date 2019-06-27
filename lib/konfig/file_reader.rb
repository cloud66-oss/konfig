require "date"

module Konfig
  class FileReader
    NAME_DELIMITER = "."
    SETTING_NAME = "Settings"

    def initialize(workdir:)
      raise ArgumentError unless workdir
      @workdir = workdir
    end

    private

    # deserializers. order matters here
    DESERIALIZERS = [
      lambda { |value| Integer(value) rescue nil }, # integer
      lambda { |value| Float(value) rescue nil }, # float
      lambda { |value| (["true", "false"].include?(value)) ? (value == "true") : nil }, # boolean
      lambda { |value| DateTime.parse(value) rescue nil }, # date time
      lambda { |value| value }, # string. should always be the last one
    ]

    def get_value(filepath)
      fullpath = File.join(@workdir, filepath)
      raise FileNotFound, "key #{filepath} not found. Expecting to find it in #{fullpath}" unless File.exist? fullpath
      content = File.read(fullpath).chomp
      return coerce(content)
    end

    def coerce(value)
      # assume a float first
      DESERIALIZERS.each do |deseralizer|
        result = deseralizer.call(value)
        return result if result
      end

      raise UnsupportedValueType, "'#{value}' is unsupported type"
    end

    def build_hash_from_list(list)
      result = []
      list.each do |item|
        value = get_value(item)
        result << build_hash(item, value)
      end

      return result
    end

    def build_object_from_list(list)
      Object.send(:remove_const, SETTING_NAME) if Object.const_defined?(SETTING_NAME)

      result = []
      hash_list = build_hash_from_list(list)
      hash_list.each do |item|
        Object.const_set(SETTING_NAME, item.to_dot)
      end
    end

    def build_hash(key, value)
      parts = key.split(NAME_DELIMITER)
      parts << value
      parts.reverse.inject { |a, n| { n => a } }
    end
  end
end
