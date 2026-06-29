# frozen_string_literal: true

RSpec.describe Slidict::Lint::Renderer do
  describe "#render" do
    it "formats findings sorted by slide number" do
      findings = [
        Slidict::Lint::Finding.new(slide: 5, severity: "warning", message: "\"MCP\" is used without explanation"),
        Slidict::Lint::Finding.new(slide: 3, severity: "warning", message: "this slide's main point is unclear")
      ]

      output = described_class.new.render(findings)

      expect(output).to eq(<<~TEXT.strip)
        [warning] Slide 3: this slide's main point is unclear
        [warning] Slide 5: "MCP" is used without explanation
      TEXT
    end
  end
end
