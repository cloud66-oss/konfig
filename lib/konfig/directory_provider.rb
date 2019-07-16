require_relative "config_provider"
require "date"
require "json"

module Konfig
  class NilClass; end

  NIL_VALUE = NilClass.new

  class DirectoryProvider < ConfigProvider
    def initialize(workdir:)
      super(mode: :yaml, workdir: workdir)
      @files = Dir.children(@workdir)
    end

    def load
      build_object_from_list(@files)
    end

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
        return result unless result == NIL_VALUE
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
      Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)

      full_hash = {}
      hash_list = build_hash_from_list(list)
      hash_list.each do |item|
        full_hash.deep_merge!(item)
      end

      Object.const_set(Konfig.configuration.namespace, full_hash.to_dot)
    end

    def build_hash(key, value)
      parts = key.split(Konfig.configuration.delimiter)
      parts << value
      parts.reverse.inject { |a, n| { n => a } }
    end
  end
end
