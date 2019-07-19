module Konfig
  class Error < StandardError; end
  class FileNotFound < Error; end
  class NotConfiguredError < Error; end
  class InvalidSettingName < Error; end
  class KeyError < Error; end
  class FileError < Error; end

  class ValidationError < Error
    def self.format(v_res)
      v_res.errors.group_by(&:path).map do |path, messages|
        "#{" " * 2}#{path.join(".")}: #{messages.map(&:text).join("; ")}"
      end.join("\n")
    end
  end
end
