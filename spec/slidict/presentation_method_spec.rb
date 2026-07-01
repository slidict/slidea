# frozen_string_literal: true

RSpec.describe Slidict::PresentationMethodRegistry do
  it "loads built-in presentation methods" do
    methods = described_class.new(include_plugins: false).all

    expect(methods.map(&:id)).to include("scqa", "prep", "pyramid")
    expect(methods.find { |method| method.id == "scqa" }.slides.first.title).to eq("Situation")
  end

  it "raises a useful error for unknown methods" do
    expect { described_class.new(include_plugins: false).fetch("unknown") }
      .to raise_error(ArgumentError, /unknown presentation method unknown/)
  end
end
