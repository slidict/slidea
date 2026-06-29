# frozen_string_literal: true

module Slidict
  module Lint
    # Splits raw Markdown/Asciidoc slide source into one text block per
    # slide, so the linter can refer to slides by number. Frontmatter
    # (Markdown) and the document title/preamble (Asciidoc) are dropped
    # since they are not slides a reader sees.
    class SlideParser
      MARKDOWN_SEPARATOR = /\A-{3,}\s*\z/
      ASCIIDOC_SLIDE_HEADING = /\A==\s+/
      MARKDOWN_HEADING = /\A#\s+/

      def self.parse(content, format: "markdown")
        format == "asciidoc" ? parse_asciidoc(content) : parse_markdown(content)
      end

      def self.parse_markdown(content)
        blocks = split_lines(content, MARKDOWN_SEPARATOR)
        blocks = blocks.drop(2) if content.lines.first&.match?(MARKDOWN_SEPARATOR)

        if blocks.size <= 1
          by_heading = split_lines(content, MARKDOWN_HEADING, keep_separator: true, drop_preamble: true)
          blocks = by_heading unless by_heading.empty?
        end

        clean(blocks)
      end
      private_class_method :parse_markdown

      def self.parse_asciidoc(content)
        clean(split_lines(content, ASCIIDOC_SLIDE_HEADING, keep_separator: true, drop_preamble: true))
      end
      private_class_method :parse_asciidoc

      # Splits `content` into blocks every time a line matches `separator`.
      # With keep_separator: true the matching line starts a new block
      # instead of being discarded (used for heading-based splitting).
      # With drop_preamble: true, any lines before the first match are
      # discarded rather than kept as a leading block.
      def self.split_lines(content, separator, keep_separator: false, drop_preamble: false)
        blocks = []
        current = drop_preamble ? nil : []
        content.each_line do |line|
          current = append_line(blocks, current, line, separator, keep_separator)
        end
        blocks << current.join if current
        blocks
      end
      private_class_method :split_lines

      def self.append_line(blocks, current, line, separator, keep_separator)
        return current << line if current && !line.match?(separator)

        blocks << current.join if current
        return current unless line.match?(separator)

        keep_separator ? [line] : []
      end
      private_class_method :append_line

      def self.clean(blocks)
        blocks.map(&:strip).reject(&:empty?)
      end
      private_class_method :clean
    end
  end
end
