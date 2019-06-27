describe Konfig::ConfigProvider do
  it "should creare the right type" do
    provider = Konfig::ConfigProvider.provider(mode: :yaml, workdir: File.join(__dir__, "fixtures"))
    expect(provider).to be_a Konfig::YamlProvider
    provider = Konfig::ConfigProvider.provider(mode: :directory, workdir: File.join(__dir__, "fixtures"))
    expect(provider).to be_a Konfig::DirectoryProvider
  end

  it "should validate provider args" do
    expect { Konfig::ConfigProvider.provider(mode: :bad_type, workdir: File.join(__dir__, "fixtures")) }.to raise_error ArgumentError
    expect { Konfig::ConfigProvider.provider(mode: :yaml, workdir: nil) }.to raise_error ArgumentError
    expect { Konfig::ConfigProvider.provider(mode: :yaml, workdir: "bad/folder") }.to raise_error Konfig::FileNotFound
    expect { Konfig::ConfigProvider.provider(mode: :directory, workdir: "bad/folder") }.to raise_error Konfig::FileNotFound
  end

  it "should use configurations" do
    Konfig.configuration.default_config_file = "test"
    expect(Konfig.configuration.default_config_file).to eq "test"
    expect(Konfig.configuration.allow_nil).to be_truthy
    Konfig.configuration.allow_nil = false
    expect(Konfig.configuration.allow_nil).not_to be_truthy
  ensure
    Konfig.configuration.allow_nil = true
    Konfig.configuration.default_config_file = "development.yml"
  end
end
