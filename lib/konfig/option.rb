require 'ostruct'

module Konfig
  class Option < OpenStruct
    include Enumerable

    def keys
      marshal_dump.keys
    end

    def empty?
      marshal_dump.empty?
    end

    def load(h)
      marshal_load(__convert(h).marshal_dump)
      self
    end

    def key?(key)
      table.key?(key)
    end

    def has_key?(key)
      table.has_key?(key)
    end

    SETTINGS_RESERVED_NAMES = %w[select collect test count zip min max].freeze

    SETTINGS_RESERVED_NAMES.each do |name|
      define_method name do
        self[name]
      end
    end

    def [](param)
      return super if SETTINGS_RESERVED_NAMES.include?(param)
      send("#{param}")
    end

    def []=(param, value)
      send("#{param}=", value)
    end

    def method_missing(method_name, *args)
      raise KeyError, "key not found: #{method_name.inspect}" unless key?(method_name) if method_name !~ /.*(?==\z)/m

      super
    end

    def respond_to_missing?(*args)
      super
    end

    protected

    def __convert(h)
      s = self.class.new

      h.each do |k, v|
        k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)
        s.new_ostruct_member(k)

        if v.is_a?(Hash)
          v = v["type"] == "hash" ? v["contents"] : __convert(v)
        elsif v.is_a?(Array)
          v = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
        end

        s.send("#{k}=".to_sym, v)
      end
      s
    end
  end
end
