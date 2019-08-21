require_relative "config_provider"
require "date"
require "json"

module Konfig
  class DirectoryProvider < ConfigProvider
    def initialize(workdir:)
      super(mode: :yaml, workdir: workdir)
      @files = Dir.children(@workdir)
      # exclude any directories there
      @files = @files.delete_if { |x| File.directory?(File.join(@workdir, x)) }
    end

    def load
      Konfig.configuration.logger.info "Loading files from #{@workdir}"
      build_object_from_list(@files)
    end

    private

    def get_value(filepath)
      fullpath = File.join(@workdir, filepath)
      raise FileNotFound, "key #{filepath} not found. Expecting to find it in #{fullpath}" unless File.exist? fullpath
      content = File.read(fullpath).chomp
      return Konfig::Utils.coerce(content)
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

      full_hash = Konfig::EnvReplacer.replace(full_hash)
      os = Konfig::Option.new
      full_hash = os.load(full_hash)
      Object.const_set(Konfig.configuration.namespace, full_hash)
    end

    def build_hash(key, value)
      parts = key.split(Konfig.configuration.delimiter)
      parts << value
      parts.reverse.inject { |a, n| { n => a } }
    end
  end
end
