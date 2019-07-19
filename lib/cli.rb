require "thor"
require "konfig"

module Konfig
  class CLI < Thor
    desc "gs", "Generate schema based on a given yaml file"
    option :in, required: true

    def gs
      infile = options[:in]
      workdir = File.dirname(infile)
      filename = File.basename(infile)
      provider = Konfig::YamlProvider.new(workdir: workdir, filename: filename)
      provider.load(false)

      puts Settings.generate_schema
    end
  end
end
