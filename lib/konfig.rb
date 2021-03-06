require "active_support/core_ext/hash"
require "dry-schema"
Dir["#{File.dirname(__FILE__)}/konfig/**/*.rb"].each { |f| load(f) }

module Konfig
  def self.configuration
    @config ||= Konfig::Config.new
  end

  def self.load
    provider = ProviderFactory.create_provider(mode: self.configuration.mode, workdir: self.configuration.workdir)
    provider.load
  end

  class Config
    attr_writer :namespace
    attr_writer :delimiter
    attr_writer :default_config_files
    attr_writer :allow_nil
    attr_writer :nil_word
    attr_writer :mode
    attr_writer :workdir
    attr_writer :env_prefix
    attr_writer :logger
    attr_writer :fail_on_validation

    def namespace
      @namespace || "Settings"
    end

    def env_prefix
      @env_prefix || "KONFIG"
    end

    def workdir
      raise NotConfiguredError, "have you set workdir?" unless @workdir

      @workdir
    end

    def mode
      raise NotConfiguredError, "have you set mode?" unless @mode

      @mode
    end

    def logger
      return @logger if @logger
      if defined?(Rails) && Rails.logger
        @logger = Rails.logger
      else
        @logger = Logger.new(STDOUT)
      end
      @logger
    end

    def schema=(value)
      @schema = value
    end

    def schema(&block)
      if block_given?
        @schema = Dry::Schema.define(&block)
      else
        @schema
      end
    end

    def delimiter
      @delimiter || "."
    end

    def default_config_files
      if defined?(Rails)
        @default_config_files || ["#{Rails.env.downcase}.yml", "#{Rails.env.downcase}.local.yml"]
      else
        @default_config_files || ["development.yml", "development.local.yml"]
      end
    end

    def allow_nil
      @allow_nil.nil? ? true : @allow_nil
    end

    def nil_word
      @nil_word || "null"
	end

	def fail_on_validation
		@fail_on_validation.nil? ? true : @fail_on_validation
	end
  end
end
