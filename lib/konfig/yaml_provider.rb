require_relative "config_provider"
require "yaml"
require "hash_dot"
require "erb"

module Konfig
  class YamlProvider < ConfigProvider
    YAML_FILENAME = "development.yml"
    SETTING_NAME = "Settings"
    attr_reader :file
    attr_reader :raw_settings

    def initialize(workdir:, filename: YAML_FILENAME)
      super(mode: :yaml, workdir: workdir)
      @file = File.join(workdir, filename)
      raise FileNotFound, "#{@file} not found" unless File.exists? @file

      content = YAML.load(ERB.new(IO.read(@file)).result) if @file and File.exist?(@file)
      content ||= {}

      @raw_settings = content.to_dot
      Object.send(:remove_const, SETTING_NAME) if Object.const_defined?(SETTING_NAME)
      Object.const_set(SETTING_NAME, @raw_settings)
    rescue Psych::SyntaxError => exc
      raise "YAML syntax error occurred while parsing #{@file}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{exc.message}"
    end
  end
end
