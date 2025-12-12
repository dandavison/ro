# ro

Live preview interface for read-only shell commands.

## Usage

Requires tmux.

```bash
ro              # empty prompt
ro ls -la       # with initial command
```

## Keys

| Key | Action |
|-----|--------|
| Up/Down | History |
| Ctrl-C / Esc | Exit |
| Ctrl-U | Clear line |

## Install

```bash
uv sync
uv run ro
```
