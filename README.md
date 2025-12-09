# ro

Real-time command output viewer. Execute shell commands as you type and see the output instantly.

## Features

- **Live preview**: Output updates as you type
- **Minimal interface**: One input line at the bottom, all output above
- **History**: Navigate previous commands with Alt-Up/Down
- **ANSI colors**: Full color support for command output

## Installation

```bash
pip install -e .
```

Or with uv:

```bash
uv pip install -e .
```

## Usage

```bash
ro                    # Start with empty prompt
ro ls -la             # Start with initial command
ro "cat /etc/hosts"   # Commands with spaces
```

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

- [fzf](https://github.com/junegunn/fzf) (0.30+)
- Python 3.8+

## How it works

`ro` uses fzf's preview window feature to display command output. The preview window is configured to take up 99% of the terminal, leaving just one line at the bottom for input. Commands are executed via `eval` on each keystroke.

**Note**: This tool executes arbitrary shell commands. While intended for read-only exploration, use with caution.


