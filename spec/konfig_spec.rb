describe Konfig do
  it "should use configurations" do
    Konfig.configuration.default_config_file = "test"
    expect(Konfig.configuration.default_config_file).to eq "test"
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
    Konfig.configuration.default_config_file = "development.yml"
  end

  it "should load" do
    Object.send(:remove_const, Konfig.configuration.namespace) if Object.const_defined?(Konfig.configuration.namespace)

    Konfig.configuration.mode = :yaml
    Konfig.configuration.workdir = File.join(__dir__, "fixtures")
    Konfig.configuration.default_config_file = "test.yml"
    Konfig.load

    expect(Settings.foo.bar.string).to eq "hello"
    expect(Settings.foo.bar.number).to eq 2
    expect(Settings.foo.bar.bool).to be_truthy
  ensure
    Konfig.configuration.default_config_file = "development.yml"
  end
end
