# frozen_string_literal: true

module Slidea
  class CLI
    DEFAULT_OUTPUT = "slides.md"

    def initialize(input: $stdin, output: $stdout, renderer: MarkdownRenderer.new)
      @input = input
      @output = output
      @renderer = renderer
    end

    def run(argv = [])
      options = parse(argv)
      return print_help if options[:help]

      deck = Deck.new(
        topic: ask("What would you like to talk about?", options[:topic]),
        duration: ask("How long is the presentation?", options[:duration]),
        audience: ask("Who is the audience?", options[:audience]),
        goal: ask("What should the audience remember or do?", options[:goal]),
        framework: options[:framework]
      )

      path = options[:output]
      File.write(path, @renderer.render(deck))
      @output.puts "Created #{path}"
      0
    rescue ArgumentError => error
      @output.puts "Error: #{error.message}"
      @output.puts
      print_help
      1
    end

    private

    def parse(argv)
      options = { output: DEFAULT_OUTPUT, framework: "slidev" }
      args = argv.dup

      until args.empty?
        case (arg = args.shift)
        when "-h", "--help"
          options[:help] = true
        when "-o", "--output"
          options[:output] = fetch_value!(args, arg)
        when "--topic"
          options[:topic] = fetch_value!(args, arg)
        when "--duration"
          options[:duration] = fetch_value!(args, arg)
        when "--audience"
          options[:audience] = fetch_value!(args, arg)
        when "--goal"
          options[:goal] = fetch_value!(args, arg)
        when "--framework"
          options[:framework] = fetch_value!(args, arg)
        else
          raise ArgumentError, "unknown option #{arg}"
        end
      end

      options
    end

    def fetch_value!(args, option)
      value = args.shift
      raise ArgumentError, "#{option} requires a value" if value.nil? || value.start_with?("-")

      value
    end

    def ask(question, provided)
      return provided unless provided.nil? || provided.strip.empty?

      @output.puts question
      @output.print "> "
      @input.gets&.chomp.to_s
    end

    def print_help
      @output.puts <<~HELP
        Usage: slidea [options]

        Generate presentation-ready Markdown slides from a short conversation.

        Options:
            --topic TEXT       Presentation topic
            --duration TEXT    Presentation length, for example "5 minutes"
            --audience TEXT    Target audience
            --goal TEXT        Desired audience takeaway or action
            --framework NAME   slidev, marp, or asciidoctor-revealjs (default: slidev)
        -o, --output PATH      Output file (default: slides.md)
        -h, --help             Show this help
      HELP
      0
    end
  end
end
