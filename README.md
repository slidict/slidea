# Slidea

Generate presentation-ready slides from a simple conversation.

Slidea is a CLI tool that helps you turn rough ideas into presentations through AI-guided conversations.

Unlike traditional slide generators, Slidea focuses on communication before slide creation.

## Features

- Interactive CLI conversation
- Generate Markdown slides for Slidev, Marp, Asciidoctor Reveal.js, and other OSS presentation frameworks
- Local-first MVP implemented in Ruby
- Local LLM support (planned)

## Requirements

- Ruby 3.1 or later

## Usage

Run the executable directly from this repository:

```bash
bin/slidea
```

Slidea asks a few questions and writes `slides.md`:

```bash
$ bin/slidea

What would you like to talk about?
> PDF Difference Monitoring Service
How long is the presentation?
> 5 minutes
Who is the audience?
> Engineering managers
What should the audience remember or do?
> Approve an MVP pilot
Created slides.md
```

You can also provide answers non-interactively:

```bash
bin/slidea \
  --topic "PDF Difference Monitoring Service" \
  --duration "5 minutes" \
  --audience "Engineering managers" \
  --goal "Approve an MVP pilot" \
  --framework slidev \
  --output slides.md
```

Output:

```text
slides.md
```

## Philosophy

Slidea helps you communicate ideas, not just create slides.

Many presentation tools focus on layouts, themes, and visual design.

Slidea focuses on the message.

Before generating slides, Slidea helps you:

- Clarify your message
- Build a compelling narrative
- Focus on what matters
- Create presentations people remember

```text
Idea
 ↓
Conversation
 ↓
Story
 ↓
Slides
```

We optimize for communication, not decoration.

## Roadmap

- [x] Interactive CLI
- [x] Slide generation
- [ ] Ollama support
- [ ] LM Studio support

## License

MIT
