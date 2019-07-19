describe Konfig do
  it "should use configurations" do
    Konfig.configuration.default_config_files = ["test"]
    expect(Konfig.configuration.default_config_files).to eq ["test"]
    Konfig.configuration.allow_nil = false
    expect(Konfig.configuration.allow_nil).not_to be_truthy
    expect { Konfig.configuration.mode }.to raise_error Konfig::NotConfiguredError
    expect { Konfig.configuration.workdir }.to raise_error Konfig::NotConfiguredError
    Konfig.configuration.mode = :yaml
    Konfig.configuration.workdir = "test"
    expect(Konfig.configuration.mode).to eq :yaml
    expect(Konfig.configuration.workdir).to eq "test"
  ensure
    Konfig.configuration.allow_nil = true
    Konfig.configuration.default_config_files = ["development.yml"]
  end

  it "should load" do
    Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)

    Konfig.configuration.mode = :yaml
    Konfig.configuration.workdir = File.join(__dir__, "fixtures")
    Konfig.configuration.default_config_files = ["test.yml"]
    Konfig.load

    expect(Settings.foo.bar.string).to eq "hello"
    expect(Settings.foo.bar.number).to eq 2
    expect(Settings.foo.bar.bool).to be_truthy
  ensure
    Konfig.configuration.default_config_files = ["development.yml"]
  end

  it "should support dry-schemas" do
    Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)

    Konfig.configuration.mode = :yaml
    Konfig.configuration.workdir = File.join(__dir__, "fixtures")
    Konfig.configuration.default_config_files = ["test.yml"]
    Konfig.configuration.schema do
      required(:bad_item).filled(:string)
    end

    expect { Konfig.load }.to raise_error Konfig::ValidationError

    expect do
      Konfig.configuration.schema do
        required(:foo).schema do
          required(:bar).schema do
            required(:string).filled(:string)
            required(:number).filled(:integer)
            required(:bool).filled(:bool)
            required(:nil).filled(:nil)
          end
        end
      end
    end.not_to raise_error
  ensure
    Konfig.configuration.default_config_files = ["development.yml"]
    Konfig.configuration.schema = nil
  end

  it "should choose the right file based on the environment" do
    Konfig.configuration.default_config_files = nil
    Object.send(:remove_const, :Rails) if Object.const_defined?(:Rails)
    expect(defined?(::Rails)).not_to be_truthy

    expect(Konfig.configuration.default_config_files).to eq(["development.yml", "development.local.yml"])

    class Rails; def self.env; :production; end; end # fake rails

    expect(defined?(::Rails)).to be_truthy

    expect(Konfig.configuration.default_config_files).to eq(["production.yml", "production.local.yml"])
  ensure
    Object.send(:remove_const, :Rails)
    Konfig.configuration.default_config_files = nil
  end
end
