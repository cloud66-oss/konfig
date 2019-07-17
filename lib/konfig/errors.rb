module Konfig
  class Error < StandardError; end
  class FileNotFound < Error; end
  class NotConfiguredError < Error; end
  class InvalidSettingName < Error; end
  class KeyError < Error; end
end
