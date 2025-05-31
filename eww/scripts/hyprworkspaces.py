#!/usr/bin/env python3

import json
import os
import socket
import subprocess
import sys
from pathlib import Path

def get_workspaces() -> list[dict]:
    output = subprocess.check_output(["hyprctl", "-j", "workspaces"])
    return json.loads(output)

def get_monitors():
    output = subprocess.check_output(["hyprctl", "-j", "monitors"])
    return json.loads(output)

def build_by_monitor() -> dict[str, list[dict]]:
    wspaces = get_workspaces()
    monitors = get_monitors()

    active_ws: dict[str, int] = {m["name"]:m["activeWorkspace"]["id"] for m in monitors}
    focused_ws_id = next(
            (m["activeWorkspace"]["id"] for m in monitors if m["focused"]), None
    )
    
    data: dict[str, list] = {}
    for ws in wspaces:
        mon = ws["monitor"]
        wid = ws["id"]
        data.setdefault(mon, []).append(
                {
                    "id": wid,
                    "name": ws["name"],
                    "monitor": mon,
                    "windows": ws["windows"],
                    "visible": wid == active_ws.get(mon),
                    "focused": wid == focused_ws_id,

                }
        )

    for lst in data.values():
        lst.sort(key=lambda w: w["id"])
        return data


def event_stream():
    his = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not his:
        sys.exit("HYPRLAND_INSTANCE_SIGNATURE not set - is hyprland running?")

    sock_path = Path(os.environ["XDG_RUNTIME_DIR"]) / f"hypr/{his}/.socket2.sock"
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(sock_path.as_posix())
    return s.makefile("r", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    try:
        stream = event_stream()
    except OSError as e:
        sys.exit(f"[ERROR] Cannot open Hyprland event socket - {e}")

    print(json.dumps(build_by_monitor()), flush=True)

    for _line in stream:
        print(json.dumps(build_by_monitor()), flush=True)
