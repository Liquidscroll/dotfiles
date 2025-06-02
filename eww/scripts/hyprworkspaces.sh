#!/usr/bin/env bash

function get_hyprspace_workspaces() {
    local wspaces_json monitors_json
    wspaces_json=$(hyprctl -j workspaces)
    monitors_json=$(hyprctl -j monitors)

    # get active workspaces for each monitor
    local active_ws_map
    active_ws_map=$(echo "$monitors_json" | jq 'map({key: .name, value: .activeWorkspace.id}) | from_entries')

    # get the id of the active workspace on the current focused monitor
    local focused_ws_id
    focused_ws_id=$(echo "$monitors_json" | jq -r '.[] | select(.focused == true) | .activeWorkspace.id // "null"')


    echo "$wspaces_json" | jq -c\
        --argjson active_ws_map "$active_ws_map" \
        --argjson focused_ws_id "$focused_ws_id" \
        '
        [
            .[] | {
                id: .id,
                name: .name,
                monitor: .monitor,
                windows: .windows,
                visible: (.id == ($active_ws_map[.monitor] // false)),
                focused: (.id == ($focused_ws_id // false))
            }
        ]
        | reduce .[] as $item ({}; .[$item.monitor] += [$item])
        | map_values(sort_by(.id))
        '
}

function event_stream() {
    local hyprland_sig sock_path
    hyprland_sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"

    sock_path="${XDG_RUNTIME_DIR}/hypr/${hyprland_sig}/.socket2.sock"

    if [[ ! -S "$sock_path" ]]; then
        echo "[ERROR] Hyprland event socket not found: $sock_path" >&2
        exit 1
    fi

    if ! socat -u "UNIX-CONNECT:$sock_path" - ; then
        echo "[ERROR] socat failed to connect to event socket: $sock_path" >&2
        return 1
    fi


}

output=$(get_hyprspace_workspaces)
echo "$output"

event_stream | while IFS= read -r _event_line; do
    if ! output=$(get_hyprspace_workspaces); then
        echo "[ERROR] Failed to generate workspace/monitor data." <&2
        continue
    fi
    echo "$output"
done

