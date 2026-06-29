# frozen_string_literal: true

module Slidict
  module Lint
    # A single diagnostic produced by the linter: which slide it concerns,
    # how severe it is ("warning" blocks understanding, "info" is a
    # suggestion), and the human-readable message to show the user.
    Finding = Struct.new(:slide, :severity, :message, keyword_init: true)
  end
end
