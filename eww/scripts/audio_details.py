#!/usr/bin/env python3
import subprocess
import re
import time
import os
import shutil
import argparse
from typing import Optional, List, Tuple

_DEBUG: bool = False
_IS_SPEAKER: bool = False
_SPEAKER_SYMBOL: str = ""
_SPEAKER_SYMBOL_MUTE: str = ""
_HEADSET_SYMBOL: str = "󰋋"
_HEADSET_SYMBOL_MUTE: str = "󰟎"
_EWW_CONFIG_PATH: str = os.path.expanduser("~/.config/eww/")


def _command_exists(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def run_command(
    command_parts: List[str],
    args: Optional[str] = "",
    check_status: bool = True,
) -> Optional[str]:
    """
    Helper function to run a shell command and return its stdout.
    Optionally raises an exception if the command fails.
    Returns None if the command fails or is not found.
    """

    if _DEBUG:
        print(f"[DEBUG]: Running command: {' '.join(command_parts)}")

    try:
        result = subprocess.run(command_parts,
                                capture_output=True,
                                input=args,
                                text=True,
                                check=check_status,
                                encoding='utf-8')

        if _DEBUG:
            print(f"[DEBUG]: Command stdout: {result.stdout.strip()}")
            if result.stderr:
                print(f"[DEBUG]: Command error: {result.stderr.strip()}")
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        if _DEBUG:
            print(
                f"[DEBUG]: Error executing command: {' '.join(command_parts)}")
            print(f"[DEBUG]: Stderr: {e.stderr.strip()}")
            print(f"[DEBUG]: Stdout: {e.stdout.strip()}")
        return None
    except FileNotFoundError:
        if _DEBUG:
            print(f"[DEBUG]: Command not found: {command_parts[0]}")
        return None


def get_all_sinks() -> List[Tuple[str, str]]:
    output = run_command(["wpctl", "status"])
    if not output:
        if _DEBUG:
            print("[ERROR]: wpctl status returned no output for sink listing.")
        return []

    sinks: List[Tuple[str, str]] = []
    in_sinks: bool = False

    # Regex to match sink lines: [* or -] ID. Name [status]
    # Group 1: ID, Group 2: Name
    sink_pattern = re.compile(r'^[^0-9]*(\d+)\.\s*(.*?)\s*\[')

    for line in output.splitlines():
        if _DEBUG:
            print(f"[DEBUG]: Processing line: {line}")
        if "Sinks:" in line:
            in_sinks = True
        if "Sources:" in line:
            break

        if in_sinks:
            match = sink_pattern.match(line)
            if match:
                if _DEBUG:
                    print(f"[DEBUG]: Found match(s): {match}")
                    print(f"[DEBUG]: Found match(s): {match.group(1)}")
                id = match.group(1).strip()
                name = match.group(2).strip()
                sinks.append((name, id))
                if _DEBUG:
                    print(f"[DEBUG]: Found sink: {name} (ID={id})")

    return sinks


def get_default_sink_line() -> Optional[str]:
    output = run_command(["wpctl", "status"])
    if not output:
        if _DEBUG:
            print("[DEBUG]: wpctl status return no output.")
        return None

    in_sinks_section: bool = False
    for line in output.splitlines():
        if "Sinks:" in line:
            in_sinks_section = True
            continue
        if "Sources:" in line:
            break  # Reached sources section, default sink must be before this.

        if in_sinks_section and "*" in line:  # '*' denotes default sink
            if _DEBUG:
                print(f"[DEBUG]: Found default sink line: {line.strip()}")
            return line.strip()

    if _DEBUG:
        print("[DEBUG]: No default sink line found in wpctl status output.")
    return None


def get_default_sink_id() -> Optional[str]:
    # Extracts ID of the default sink
    sink_line = get_default_sink_line()
    if sink_line:
        match = re.search(r'\*\s*([0-9]+\.', sink_line)

        if match:
            sink_id: str = match.group(1)

            if _DEBUG:
                print(f"[DEBUG]: Extracted default sink ID: '{sink_id}'")
            return sink_id
        elif _DEBUG:
            print(f"[DEBUG]: Could not parse sink ID from line: '{sink_line}'")
    return None


def get_default_sink_name() -> Optional[str]:
    sink_line = get_default_sink_line()
    if sink_line:
        match = re.search(r'\*\s*[0-9]+\.\s+([^\[]+)', sink_line)
        if match:
            sink_name: str = match.group(1).strip()
            if _DEBUG:
                print(f"[DEBUG]: Extraced defaiult sink name: '{sink_name}'")
            return sink_name
        elif _DEBUG:
            print(
                f"[DEBUG]: Could not parse sink name from line: '{sink_line}'")

    return None


def get_volume_percent() -> Optional[str]:
    output = run_command(["wpctl", "get-volume", "@DEFAULT_SINK@"])
    if output:
        parts: List[str] = output.split()
        if len(parts) >= 2:
            try:
                volume_float: float = float(parts[1])
                percent: str = f"{int(volume_float * 100)}"
                if _DEBUG:
                    print(f"[DEBUG]: Extracted volume percent: {percent}%")
                return percent
            except ValueError:
                if _DEBUG:
                    print(f"[DEBUG]: Could not parse volume from: '{output}'")
                pass
    return None


def get_mute_status() -> str:
    output = run_command(check_status=False,
                         command_parts=[
                             "wpctl",
                             "get-volume",
                             "@DEFAULT_SINK@",
                         ])
    if output and "MUTED" in output:
        if _DEBUG:
            print(f"[DEBUG]: Sink mute status is {output}.")
        return "MUTED"
    if _DEBUG:
        print("[DEBUG]: Sink is not muted.")
    return ""


def change_mute_symbol(set_mute: bool) -> None:
    if _IS_SPEAKER:
        if set_mute:
            run_command([
                "eww", "-c", _EWW_CONFIG_PATH, "update",
                f'audio_sink_icon={_SPEAKER_SYMBOL_MUTE}'
            ])
        else:
            run_command([
                "eww", "-c", _EWW_CONFIG_PATH, "update",
                f'audio_sink_icon={_SPEAKER_SYMBOL}'
            ])
    else:
        if set_mute:
            run_command([
                "eww", "-c", _EWW_CONFIG_PATH, "update",
                f'audio_sink_icon={_HEADSET_SYMBOL_MUTE}'
            ])
        else:
            run_command([
                "eww", "-c", _EWW_CONFIG_PATH, "update",
                f'audio_sink_icon={_HEADSET_SYMBOL}'
            ])


def command_symbol() -> None:
    curr_sink_name: str = ""
    while True:
        new_sink_name: Optional[str] = get_default_sink_name()
        if new_sink_name is not None and new_sink_name != curr_sink_name:
            global _IS_SPEAKER
            if "LogitechSpeakers" == curr_sink_name:
                _IS_SPEAKER = True
            else:
                _IS_SPEAKER = False

            curr_sink_name = new_sink_name
        time.sleep(0.5)


def set_audio_device() -> None:
    sink_name: Optional[str] = get_default_sink_name()
    if sink_name is not None:
        global _IS_SPEAKER
        if "LogitechSpeakers" == sink_name:
            _IS_SPEAKER = True
        else:
            _IS_SPEAKER = False


def command_volume() -> None:
    last_vol: str = ""
    while True:
        vol: Optional[str] = get_volume_percent()
        if vol is not None and vol != last_vol:
            print(vol, flush=True)
            last_vol = vol
        time.sleep(0.25)


def command_mute() -> None:
    set_audio_device()
    last_mute: str = get_mute_status()
    run_command(["wpctl", "set-mute", "@DEFAULT_SINK@", "toggle"])

    if last_mute == "":
        change_mute_symbol(True)
    else:
        change_mute_symbol(False)

    if _DEBUG:
        print(f"[DEBUG]: Muted audio, is now {last_mute}")


def command_menu() -> None:
    if not _command_exists("tofi") and _DEBUG:
        print("[ERROR]: Tofi not found in PATH.")
        return

    sinks = get_all_sinks()
    if not sinks:
        print("[ERROR]: No audio sinks found.")
        return

    tofi_options = [f"{name} | {_id}" for name, _id in sinks]

    tofi_cmd = [
        "tofi",
        "--prompt-text=Audio Devices:",
        "--font=sans-serif",
        "--font-size=16",
        "--width=600",
        "--height=200",
        "--hide-input=true",
        "--hidden-character=",
        "--padding-top=20",
        "--padding-bottom=20",
        "--corner-radius=10",
        "--background-color=#282a36BB",
        "--text-color=#f8f8f2",
        "--placeholder-color=#6272a4",
        "--border-color=#bd93f9",
        "--border-width=2",
        "--outline-width=0",
        "--padding-right=100",
        "--margin-left=0",
    ]

    try:
        selected_line = run_command(tofi_cmd, "\n".join(tofi_options), True)
        if not selected_line:
            if _DEBUG:
                print("[DEBUG]: Tofi menu cancelled or no selection made.")
            return

        parts = selected_line.split('|')
        if len(parts) == 2:
            desc = parts[0]
            id = parts[1]

            if _DEBUG:
                print(
                    f"[DEBUG]: Selected Sink:\n\tDescription: '{desc}'\n\tId: '{id}'"
                )

            set_result = run_command(["wpctl", "set-default", id])
            if set_result is not None:
                if _DEBUG:
                    print(f"[DEBUG]: Default audio sink set to: {desc}")
            else:
                if _DEBUG:
                    print(
                        f"[ERROR]: Error setting default sink to {desc} (ID: {id})"
                    )
    except Exception as e:
        if _DEBUG:
            print(f"[ERROR]: Error running Tofi Sound Menu: {e}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="A script to manage audio.",
        formatter_class=argparse.RawTextHelpFormatter,
    )

    parser.add_argument(
        "--debug",
        "-d",
        action="store_true",
        help="Enable debug output for command execution and parsing")

    subparsers = parser.add_subparsers(dest="command",
                                       required=True,
                                       help="Available commands")

    subparsers.add_parser("volume",
                          help="""Continuously monitors default sink volume and
prints the percentage.""",
                          description="""
        This command runs in a loop, checking the current default audio sink's
        volume percentage. It prints the volume to stdout when it changes.
        Useful for status bars.
        """)
    subparsers.add_parser(
        "mute",
        help="Checks mute status of the default sink (no visible output).",
        description="""
        This command is a direct translation of the original shell script's
        'mute' command. The original script's logic did not perform any
        action or print any output based on the mute status.
        This script maintains that behavior.
        """)
    subparsers.add_parser(
        "menu",
        help=
        "Displays a Tofi menu to select and change the default audio sink.",
        description="""
        This command fetches all available audio output devices (sinks) using
        'wpctl status', presents them in a Tofi menu, and sets the selected
        device as the default audio sink using 'wpctl set-default-sink'.
        It also sends a desktop notification on success or failure.
        """)
    # Toggle command
    subparsers.add_parser(
        "toggle",
        help=
        "Toggles default sink behavior for LogitechSpeakers and updates Eww.",
        description="""
        This command checks if the current default sink is "LogitechSpeakers".
        - If it is, it sets the Eww 'audio_sink' variable to the speaker symbol
          and explicitly sets "LogitechSpeakers" as the default sink (redundant
          if already default, but matches original script's behavior).
        - If it is NOT "LogitechSpeakers", it sets the Eww 'audio_sink' variable
          to the headphone symbol.
        Note: This command does NOT automatically switch *to* a different sink
        if it's not LogitechSpeakers. It only updates Eww or confirms LogitechSpeakers.
        """)

    args: argparse.Namespace = parser.parse_args()
    global _DEBUG
    _DEBUG = args.debug

    if args.command == "volume":
        command_volume()
    elif args.command == "mute":
        command_mute()
    elif args.command == "menu":
        command_menu()
    elif args.command == "toggle":
        print("Toggle not implemented...")
        pass


if __name__ == "__main__":
    main()
