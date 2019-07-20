module Konfig
  class EnvReplacer
    def self.replace(h)
      return iterate(h)
    end

    private

    def self.iterate(h, keychain = "")
      h.each_with_object({}) { |(k, v), g|
        chain = "#{keychain.upcase}_#{k.to_s.upcase}"
        if Hash === v
          g[k] = self.iterate(v, chain)
        else
          g[k] = self.get_env(chain, v, g)
        end
      }
    end

    def self.get_env(key, value, obj)
      raise InvalidSettingNameError if key.length <= 1

      env_key = "#{Konfig.configuration.env_prefix}_#{key[1..-1]}"
      if ENV.has_key? env_key
        return Konfig::Utils.coerce(ENV[env_key])
      else
        return value
      end
    end
  end
end
