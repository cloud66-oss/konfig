describe Konfig::ProviderFactory do
  it "should creare the right type" do
    provider = Konfig::ProviderFactory.create_provider(mode: :yaml, workdir: File.join(__dir__, "fixtures"))
    expect(provider).to be_a Konfig::YamlProvider
    provider = Konfig::ProviderFactory.create_provider(mode: :directory, workdir: File.join(__dir__, "fixtures"))
    expect(provider).to be_a Konfig::DirectoryProvider
  end

  it "should validate provider args" do
    expect { Konfig::ProviderFactory.create_provider(mode: :bad_type, workdir: File.join(__dir__, "fixtures")) }.to raise_error ArgumentError
    expect { Konfig::ProviderFactory.create_provider(mode: :yaml, workdir: nil) }.to raise_error ArgumentError
    expect { Konfig::ProviderFactory.create_provider(mode: :yaml, workdir: "bad/folder") }.to raise_error Konfig::FileNotFound
    expect { Konfig::ProviderFactory.create_provider(mode: :directory, workdir: "bad/folder") }.to raise_error Konfig::FileNotFound
  end
end
