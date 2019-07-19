require "ostruct"

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
      validate!
      self
    end

    def key?(key)
      table.key?(key)
    end

    def has_key?(key)
      table.has_key?(key)
    end

    def validate!
      if Konfig.configuration.schema
        v_res = Konfig.configuration.schema.(self.marshal_dump)

        unless v_res.success?
          error = Konfig::ValidationError.format(v_res)
          raise Konfig::ValidationError.new("Config validation failed:\n\n#{error}")
        end
      end
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

    def generate_schema(start = nil)
      start = self if start.nil?
      result = []
      start.table.each do |k, v|
        if v.is_a?(Option)
          result << "required(:#{k}).schema do"
          result << generate_schema(v)
          result << "end"
        elsif [String, Integer, Numeric, Array].include? v.class
          result << generate_required(k, v)
        elsif [TrueClass, FalseClass].include? v.class
          result << "required(:#{k}).filled(:bool)"
        elsif v.nil?
          result << "required(:#{k})"
        end
      end

      return result
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

    private

    def generate_required(k, v)
      "required(:#{k}).filled(:#{v.class.name.downcase})"
    end
  end
end
