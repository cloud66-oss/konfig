module Konfig
  class ProviderFactory
    def self.create_provider(mode:, workdir:)
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
