require_relative "config_provider"
require "yaml"
require "ostruct"
require "erb"

module Konfig
  class YamlProvider < ConfigProvider
    attr_reader :files
    attr_reader :raw_settings

    def initialize(workdir:, filenames: Konfig.configuration.default_config_files)
      super(mode: :yaml, workdir: workdir)
      @files = filenames.map { |f| File.join(workdir, f) }
      raise FileNotFound, "none of the configuration files (#{@files}) found" if @files.all? { |f| !File.exists?(f) }
    end

    def load(parse = true)
      content = {}
      @files.each do |f|
        file_content = IO.read(f)
        raise FileError, "file #{f} is empty" if file_content.blank?

        yaml_content = parse ? ERB.new(file_content).result : file_content
        current_content = YAML.load(yaml_content).deep_symbolize_keys if f and File.exist?(f)
        current_content = Konfig::EnvReplacer.replace(current_content)

        content = content.deep_merge(current_content)
      end

      os = Konfig::Option.new
      @raw_settings = os.load(content)
      Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)
      Object.const_set(Konfig.configuration.namespace, @raw_settings)
    rescue Psych::SyntaxError => exc
      raise "YAML syntax error occurred while parsing #{f}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{exc.message}"
    end
  end
end
