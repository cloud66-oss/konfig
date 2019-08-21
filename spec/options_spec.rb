describe Konfig::Option do
  it "contain types" do
    h = { a: 1, b: { c: "hello", d: true, e: nil }, c: [1, 2, 3] }
    o = Konfig::Option.new
    res = o.load(h)

    expect(res.a).to be_a Integer
    expect(res.b).to be_a Konfig::Option
    expect(res.b.c).to be_a String
    expect(res.b.d).to be_a TrueClass
    expect(res.b.e).to be_nil
    expect(res.c).to be_a Array
    expect(res.c[0]).to be_a Integer
  end

  it "should generate schema" do
    h = { a: 1, b: { c: "hello", d: true, e: nil }, c: [1, 2, 3] }
    o = Konfig::Option.new
    res = o.load(h)

    result = res.generate_schema
    expect(result).to eq(["required(:a).filled(:integer)", "required(:b).schema do", ["required(:c).filled(:string)", "required(:d).filled(:bool)", "required(:e)"], "end", "required(:c).filled(:array)"])
  end

  it "should allow checking of the key" do
    h = { a: 1, b: { c: "hello", d: true, e: nil }, c: [1, 2, 3] }
    o = Konfig::Option.new
    res = o.load(h)

    expect(o.key? :a).to be_truthy
    expect(o.key? :whaa).not_to be_truthy
    expect(o.b.key? :bad).not_to be_truthy
  end
end
