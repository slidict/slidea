# frozen_string_literal: true

RSpec.describe Slidict::Lint::SlideParser do
  describe ".parse" do
    it "splits slidev/marp style markdown on --- separators and drops frontmatter" do
      content = <<~MARKDOWN
        ---
        theme: default
        class: text-center
        ---

        # Title

        - one
        - two

        ---

        # Second

        - three
      MARKDOWN

      slides = described_class.parse(content, format: "markdown")

      expect(slides.size).to eq(2)
      expect(slides[0]).to include("# Title")
      expect(slides[1]).to include("# Second")
    end

    it "splits plain markdown without --- separators on top-level headings" do
      content = <<~MARKDOWN
        # First

        body one

        # Second

        body two
      MARKDOWN

      slides = described_class.parse(content, format: "markdown")

      expect(slides.size).to eq(2)
      expect(slides[0]).to include("First")
      expect(slides[1]).to include("Second")
    end

    it "treats markdown without any separator or heading as a single slide" do
      slides = described_class.parse("just some text", format: "markdown")

      expect(slides).to eq(["just some text"])
    end

    it "splits asciidoc on level-1 slide headings and drops the document title/preamble" do
      content = <<~ASCIIDOC
        = My Talk
        :revealjs_theme: white

        == First

        * one

        == Second

        * two
      ASCIIDOC

      slides = described_class.parse(content, format: "asciidoc")

      expect(slides.size).to eq(2)
      expect(slides[0]).to include("First")
      expect(slides[1]).to include("Second")
      expect(slides.join).not_to include("My Talk")
    end
  end
end
