describe Konfig::FileReader do
  it "should build the right hash" do
    list = [
      "foo.bar.fuzz.bool",
      "foo.bar.fuzz.string",
      "foo.bar.fuzz.float",
      "foo.bar.fuzz.number",
      "foo.bar.fuzz.date",
    ]

    provider = Konfig::FileReader.new(workdir: File.join(__dir__, "fixtures", "samples"))
    result = provider.send("build_hash_from_list", list)
    expect(result.count).to eq 5
    expect(result[0]["foo"]["bar"]["fuzz"]["bool"]).to be_truthy
    expect(result[1]["foo"]["bar"]["fuzz"]["string"]).to eq "hello"
    expect(result[2]["foo"]["bar"]["fuzz"]["float"]).to eq 1.244
    expect(result[3]["foo"]["bar"]["fuzz"]["number"]).to eq 13
    expect(result[4]["foo"]["bar"]["fuzz"]["date"]).to eq DateTime.parse("12/4/2011 10:21:22")
  end

  it "should create the right objects" do
    list = [
      "foo.bar.fuzz.bool",
      "foo.bar.fuzz.string",
      "foo.bar.fuzz.float",
      "foo.bar.fuzz.number",
      "foo.bar.fuzz.date",
    ]

    provider = Konfig::FileReader.new(workdir: File.join(__dir__, "fixtures", "samples"))
    provider.send("build_object_from_list", list)
  end
end
