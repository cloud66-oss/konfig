require_relative "config_provider"
require "yaml"
require "ostruct"
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

    def load(parse = true)
      file_content = IO.read(@file)
      raise FileError, "file #{@file} is empty" if file_content.blank?

      yaml_content = parse ? ERB.new(file_content).result : file_content
      content = YAML.load(yaml_content).deep_symbolize_keys if @file and File.exist?(@file)
      content ||= {}

      content = Konfig::EnvReplacer.replace(content)
      os = Konfig::Option.new
      @raw_settings = os.load(content)
      Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)
      Object.const_set(Konfig.configuration.namespace, @raw_settings)
    rescue Psych::SyntaxError => exc
      raise "YAML syntax error occurred while parsing #{@file}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{exc.message}"
    end
  end
end
