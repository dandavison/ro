# ro

Real-time command output viewer. Execute shell commands as you type in an interactive shell.

## Features

- **Live execution**: Commands run as you type
- **Full shell support**: Aliases, functions, and shell state work
- **Minimal interface**: Top pane shows output, bottom line is input
- **History**: Navigate previous commands with Alt-Up/Down

## Installation

```bash
uv sync
```

## Usage

Must be run inside tmux:

```bash
uv run ro                    # Start with empty prompt
uv run ro ls -la             # Start with initial command
uv run ro "cat /etc/hosts"   # Commands with spaces
```

## How it works

`ro` creates a tmux split:
- **Top pane (90%)**: Interactive shell showing command output
- **Bottom pane (10%)**: fzf-based input line

As you type, commands are sent to the top pane and executed. Your shell aliases and functions work because it's a real interactive shell.

**Safety**: The shell runs inside macOS `sandbox-exec` with file writes denied. This protects against accidental damage since commands execute on every keystroke. Some tools that write files (like shell history, atuin) won't work inside the sandbox.

When you exit (Enter/Esc/Ctrl-C), the shell pane is killed.

## Key Bindings

| Key | Action |
|-----|--------|
| Enter | Exit |
| Ctrl-C / Esc | Abort |
| Alt-Up | Previous history |
| Alt-Down | Next history |
| Ctrl-K | Clear to end of line |
| Ctrl-U | Clear to start of line |
| Ctrl-W | Delete word backward |
| Alt-Right | Forward word |
| Alt-Left | Backward word |

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/junegunn/fzf) (0.30+)
- Python 3.8+
