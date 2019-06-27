module Konfig
  class ConfigProvider
    attr_reader :mode
    attr_reader :workdir

    def initialize(mode:, workdir:)
      raise ArgumentError unless workdir
      raise ArgumentError unless [:yaml, :directory].include? mode
      raise FileNotFound, "directory #{workdir} not found" unless Dir.exist? workdir

      @mode = mode
      @workdir = workdir
    end

    def self.provider(mode:, workdir:)
      raise ArgumentError unless workdir
      raise ArgumentError unless [:yaml, :directory].include? mode

      if mode == :yaml
        return YamlProvider.new(workdir: workdir)
      elsif mode == :directory
        return DirectoryProvider.new(workdir: workdir)
      else
        raise ArgumentError
      end
    end
  end
end
