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
  end
end
