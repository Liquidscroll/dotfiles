#!/usr/bin/env bats

@test "command_exists finds existing command" {
  run bash -c "source \"$BATS_TEST_DIRNAME/../lib/shared.sh\" && command_exists ls"
  [ "$status" -eq 0 ]
}

@test "command_exists fails for missing command" {
  run bash -c "source \"$BATS_TEST_DIRNAME/../lib/shared.sh\" && command_exists cmd_does_not_exist_12345"
  [ "$status" -eq 1 ]
}

@test "symlink_dotfiles creates a link" {
  tmpdir=$(mktemp -d)
  run bash -c "source \"$BATS_TEST_DIRNAME/../lib/shared.sh\" && symlink_dotfiles README.md \"$tmpdir/readme\""
  [ "$status" -eq 0 ]
  [ -L "$tmpdir/readme" ]
  target=$(readlink "$tmpdir/readme")
  expected="$(cd "$BATS_TEST_DIRNAME/.." && pwd)/README.md"
  [ "$target" = "$expected" ]
}

@test "is_arch returns true on Arch systems" {
  run grep -q '^ID=arch' /etc/os-release
  if [ "$status" -ne 0 ]; then
    skip "Not running on Arch Linux"
  fi
  run bash -c "source \"$BATS_TEST_DIRNAME/../lib/shared.sh\" && is_arch"
  [ "$status" -eq 0 ]
}

@test "install.sh dry run" {
  run grep -q '^ID=arch' /etc/os-release
  if [ "$status" -ne 0 ]; then
    skip "Not running on Arch Linux"
  fi
  run bash "$BATS_TEST_DIRNAME/../install.sh" --dry-run
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Running setup.sh"
}
