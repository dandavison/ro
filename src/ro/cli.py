"""CLI entry point for ro."""

import subprocess
import sys
from pathlib import Path


def main():
    """Main entry point for ro command."""
    ro_script = Path(__file__).parent / "scripts" / "ro"

    if not ro_script.exists():
        print(f"Error: ro script not found at {ro_script}", file=sys.stderr)
        sys.exit(1)

    try:
        result = subprocess.run([str(ro_script)] + sys.argv[1:], check=False)
        sys.exit(result.returncode)
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:
        print(f"Error running ro: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

