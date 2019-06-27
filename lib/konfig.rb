require "active_support/core_ext/hash"
Dir["#{File.dirname(__FILE__)}/konfig/**/*.rb"].each { |f| load(f) }

module Konfig
  def self.configuration
    @config ||= Konfig::Config.new
  end

  class Config
    attr_writer :namespace
    attr_writer :delimiter
    attr_writer :default_config_file
    attr_writer :allow_nil
    attr_writer :nil_word

    def namespace
      @namespace || "Settings"
    end

    def delimiter
      @delimiter || "."
    end

    def default_config_file
      @default_config_file || "development.yml"
    end

    def allow_nil
      @allow_nil.nil? ? true : @allow_nil
    end

    def nil_word
      @nil_word || "null"
    end
  end
end
