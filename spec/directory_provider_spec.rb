describe Konfig::DirectoryProvider do
  it "should build the right hash" do
    list = [
      "foo.bar.fuzz.bool",
      "foo.bar.fuzz.string",
      "foo.bar.fuzz.float",
      "foo.bar.fuzz.number",
      "foo.bar.fuzz.json",
      "foo.bar.fuzz.forced_string",
      "foo.bar.fuzz.forced_string_with_quotes",
    ]

    provider = Konfig::DirectoryProvider.new(workdir: File.join(__dir__, "fixtures", "samples"))
    result = provider.send("build_hash_from_list", list)
    expect(result.count).to eq 7
    expect(result[0]["foo"]["bar"]["fuzz"]["bool"]).to be_truthy
    expect(result[1]["foo"]["bar"]["fuzz"]["string"]).to eq "hello"
    expect(result[2]["foo"]["bar"]["fuzz"]["float"]).to eq 1.244
    expect(result[3]["foo"]["bar"]["fuzz"]["number"]).to eq 13
    expect(result[4]["foo"]["bar"]["fuzz"]["json"]).to be_a_kind_of Array
    expect(result[4]["foo"]["bar"]["fuzz"]["json"][0][:this]).to eq 1
  end

  it "should create the right objects" do
    list = [
      "foo.bar.fuzz.bool",
      "foo.bar.fuzz.string",
      "foo.bar.fuzz.float",
      "foo.bar.fuzz.number",
      "foo.bar.fuzz.json",
    ]

    provider = Konfig::DirectoryProvider.new(workdir: File.join(__dir__, "fixtures", "samples"))
    Konfig.configuration.allow_nil = true
    provider.load
    expect(Settings.foo.bar.fuzz.bool).to be_truthy
    expect(Settings.foo.bar.fuzz.number).to eq 13
    expect(Settings.foo.bar.fuzz.float).to eq 1.244
    expect(Settings.foo.bar.fuzz.string).to eq "hello"
    expect(Settings.foo.bar.fuzz.nil).to be_nil
    expect(Settings.foo.bar.fuzz.forced_string).to be_a_kind_of String
    expect(Settings.foo.bar.fuzz.forced_string).to eq "2151604965.732166996786"
    expect(Settings.foo.bar.fuzz.forced_string_with_quotes).to be_a_kind_of String
    expect(Settings.foo.bar.fuzz.forced_string_with_quotes).to eq "2151604965.732166996786"

    Konfig.configuration.allow_nil = false
    provider.load
    expect(Settings.foo.bar.fuzz.nil).to eq "null"
  end

  it "should respect env var overrides" do
    list = [
      "foo.bar.fuzz.bool",
      "foo.bar.fuzz.string",
      "foo.bar.fuzz.float",
      "foo.bar.fuzz.number",
      "foo.bar.fuzz.json",
    ]

    ENV["KONFIG_FOO_BAR_FUZZ_BOOL"] = "false"

    provider = Konfig::DirectoryProvider.new(workdir: File.join(__dir__, "fixtures", "samples"))
    Konfig.configuration.allow_nil = true
    provider.load
    expect(Settings.foo.bar.fuzz.bool).not_to be_truthy
    expect(Settings.foo.bar.fuzz.number).to eq 13
    expect(Settings.foo.bar.fuzz.float).to eq 1.244
    expect(Settings.foo.bar.fuzz.string).to eq "hello"
    expect(Settings.foo.bar.fuzz.nil).to be_nil

    Konfig.configuration.allow_nil = false
    provider.load
    expect(Settings.foo.bar.fuzz.nil).to eq "null"
  end

  it "should handle bad keys" do
    provider = Konfig::DirectoryProvider.new(workdir: File.join(__dir__, "fixtures", "samples"))
    provider.load
    expect { Settings.foo.bar.bad_key }.to raise_error Konfig::KeyError
    expect { Settings.no_available }.to raise_error Konfig::KeyError
  end
end
