#!/bin/bash

# Test suite for ro
# Runs tests using tmux to verify the tool works correctly

set -e

echo "======================================"
echo "  ro Test Suite"
echo "======================================"
echo

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

test_count=0
failed_count=0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RO_PATH="$(cd "$SCRIPT_DIR/../../src/ro/scripts" && pwd)/ro"

echo "Using ro at: $RO_PATH"
echo

# Use a separate tmux server for tests
TMUX_SOCKET="ro-test-$$"

cleanup() {
    tmux -L "$TMUX_SOCKET" kill-server 2>/dev/null || true
}
trap cleanup EXIT

run_test() {
    local test_name="$1"
    local query="$2"
    local expected_pattern="$3"
    local wait_time="${4:-1.5}"

    test_count=$((test_count + 1))
    echo -n "Test $test_count: $test_name... "

    SESSION="ro-test-session-$$"

    # Start a tmux session that runs ro with the query
    tmux -L "$TMUX_SOCKET" new-session -d -s "$SESSION" -x 120 -y 30 \
        "cd /tmp && $RO_PATH '$query'"

    # Wait for ro to start and execute
    sleep "$wait_time"

    # Capture the output from the shell pane (pane 0 is the top/shell pane)
    # ro creates: pane 0 = shell (top), pane 1 = fzf (bottom)
    output=$(tmux -L "$TMUX_SOCKET" capture-pane -t "$SESSION:0.0" -p 2>/dev/null || true)

    # Kill the session
    tmux -L "$TMUX_SOCKET" kill-session -t "$SESSION" 2>/dev/null || true

    if echo "$output" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}PASS${NC}"
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        echo "  Expected to find: '$expected_pattern'"
        echo "  Query: $query"
        echo "  Output: $(echo "$output" | head -5 | tr '\n' ' ')"
        failed_count=$((failed_count + 1))
        return 1
    fi
}

echo "=== Basic Functionality Tests ==="
echo

# Test 1: Basic echo command
run_test "echo hello world" \
    "echo hello" \
    "hello"

# Test 2: Command with arguments
run_test "echo with multiple words" \
    "echo foo bar baz" \
    "foo bar baz"

# Test 3: Command with pipe
run_test "command with pipe" \
    "echo test | cat" \
    "test"

echo
echo "=== Results ==="
echo "Total tests: $test_count"
echo -e "Passed: ${GREEN}$((test_count - failed_count))${NC}"
if [[ $failed_count -gt 0 ]]; then
    echo -e "Failed: ${RED}$failed_count${NC}"
    exit 1
else
    echo -e "Failed: ${GREEN}0${NC}"
    echo
    echo -e "${GREEN}All tests passed!${NC}"
fi

