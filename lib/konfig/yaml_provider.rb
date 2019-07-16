require_relative "config_provider"
require "yaml"
require "hash_dot"
require "erb"

module Konfig
  class YamlProvider < ConfigProvider
    attr_reader :file
    attr_reader :raw_settings

    def initialize(workdir:, filename: Konfig.configuration.default_config_file)
      super(mode: :yaml, workdir: workdir)
      @file = File.join(workdir, filename)
      raise FileNotFound, "#{@file} not found" unless File.exists? @file
    end

    def load
      content = YAML.load(ERB.new(IO.read(@file)).result).deep_symbolize_keys if @file and File.exist?(@file)
      content ||= {}

      content = Konfig::EnvReplacer.replace(content)
      @raw_settings = content.to_dot
      Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)
      Object.const_set(Konfig.configuration.namespace, @raw_settings)
    rescue Psych::SyntaxError => exc
      raise "YAML syntax error occurred while parsing #{@file}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{exc.message}"
    end
  end
end
