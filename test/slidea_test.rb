# frozen_string_literal: true

require "minitest/autorun"
require "stringio"
require "tmpdir"
require_relative "../lib/slidea"

class SlideaTest < Minitest::Test
  def test_deck_uses_defaults_for_blank_answers
    deck = Slidea::Deck.new(topic: "", duration: "", audience: "", goal: "")

    assert_equal "Untitled presentation", deck.topic
    assert_equal "5 minutes", deck.duration
    assert_equal "general audience", deck.audience
  end

  def test_renderer_outputs_markdown_slides
    deck = Slidea::Deck.new(topic: "PDF Difference Monitoring Service", duration: "5 minutes", audience: "developers", goal: "try the MVP")
    markdown = Slidea::MarkdownRenderer.new.render(deck)

    assert_includes markdown, "# PDF Difference Monitoring Service"
    assert_includes markdown, "- For developers"
    assert_includes markdown, "---"
  end

  def test_cli_writes_slides_file_from_options
    Dir.mktmpdir do |dir|
      path = File.join(dir, "slides.md")
      output = StringIO.new
      status = Slidea::CLI.new(input: StringIO.new, output: output).run([
        "--topic", "Observability",
        "--duration", "10 minutes",
        "--audience", "SREs",
        "--goal", "adopt the checklist",
        "--output", path
      ])

      assert_equal 0, status
      assert File.exist?(path)
      assert_includes File.read(path), "# Observability"
      assert_includes output.string, "Created #{path}"
    end
  end
end
