# frozen_string_literal: true

module Slidict
  module Lint
    # Formats findings as one line per finding:
    #   [warning] Slide 3: this slide's main point is unclear
    class Renderer
      def render(findings)
        findings.sort_by(&:slide).map { |finding| line_for(finding) }.join("\n")
      end

      private

      def line_for(finding)
        "[#{finding.severity}] Slide #{finding.slide}: #{finding.message}"
      end
    end
  end
end
