module Konfig
  class ConfigProvider
    attr_reader :mode
    attr_reader :workdir

    def initialize(mode:, workdir:)
      @mode = mode
      @workdir = @workdir
    end
  end
end
