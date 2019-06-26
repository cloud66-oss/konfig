describe Konfig::FileReader do
  it "should return the correct path" do
    reader = Konfig::FileReader.new(File.join(__dir__, "fixtures"))
    puts reader.foo.bar.fuzz.buzz
  end
end
