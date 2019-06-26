module Konfig
  class FileReader
    def initialize(workdir, trace = [])
      raise ArgumentError unless workdir
      @trace = trace
      @workdir = workdir
    end

    def method_missing(method, *args)
      @trace << method.to_s
      filepath = File.join(@workdir, path)
      if File.exist? filepath
        puts "Found file #{filepath}"
      else
        return FileReader.new(@workdir, @trace)
      end
    end

    private

    def path
      @trace.join(".")
    end
  end
end
