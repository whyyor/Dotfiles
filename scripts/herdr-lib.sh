#!/usr/bin/env bash
# shared helpers for the herdr keybinding scripts (hgo, hnew) -- sourced, not executed

herdr_bin=${HERDR_BIN_PATH:-herdr}

focus_ghostty() {
    local wid
    wid=$(aerospace list-windows --monitor all \
        --app-bundle-id com.mitchellh.ghostty \
        --format '%{window-id}' 2>/dev/null | head -n1)

    if [[ -n $wid ]]; then
        aerospace focus --window-id "$wid"
    else
        open -a Ghostty
    fi
}

# is this pane's foreground process $2?
pane_matches() {
    local pane=$1 re=$2
    "$herdr_bin" pane process-info --pane "$pane" 2>/dev/null |
        jq -e --arg re "$re" '.result.process_info.foreground_processes[]?
            | select((.argv0 | test($re)) or (.name | test($re)))' >/dev/null
}

# a pane accepts input only when its own shell is the foreground process
pane_ready() {
    "$herdr_bin" pane process-info --pane "$1" 2>/dev/null |
        jq -e '.result.process_info
            | .shell_pid as $s | any(.foreground_processes[]?; .pid == $s)' >/dev/null
}

# first pane in a workspace sitting idle at a prompt, optionally filtered by cwd
# the workspace's active tab wins so the takeover never feels arbitrary
# echoes "<pane_id> <tab_id>"
idle_pane_in() {
    local ws=$1 want_cwd=${2:-} active pane tab pcwd

    active=$("$herdr_bin" workspace get "$ws" 2>/dev/null |
        jq -r '.result.workspace.active_tab_id // empty')

    while IFS=$'\t' read -r pane tab pcwd; do
        [[ -n $want_cwd && $pcwd != "$want_cwd" ]] && continue
        pane_ready "$pane" && {
            printf '%s %s\n' "$pane" "$tab"
            return 0
        }
    done < <("$herdr_bin" pane list 2>/dev/null |
        jq -r --arg w "$ws" --arg a "$active" '
            [.result.panes[] | select(.workspace_id == $w)]
            | sort_by(.tab_id != $a)
            | .[] | [.pane_id, .tab_id, (.foreground_cwd // .cwd)] | @tsv')
    return 1
}

# type a command into a pane once its shell is actually at a prompt
# usage: pane_launch <pane_id> <proc_regex> <command> [args...]
pane_launch() {
    local pane=$1 proc_re=$2 attempt i
    shift 2

    for attempt in 1 2; do
        # shell init (rbenv, plugins) owns the foreground first, typing then gets swallowed
        for ((i = 0; i < 60; i++)); do
            pane_ready "$pane" && break
            sleep 0.1
        done

        "$herdr_bin" pane run "$pane" "$@" >/dev/null || return 1

        for ((i = 0; i < 20; i++)); do
            pane_matches "$pane" "$proc_re" && return 0
            sleep 0.15
        done

        # still idle at a prompt means the command never landed, so retyping is safe
        # anything else running is presumably ours, just slow to draw
        pane_ready "$pane" || return 0
    done
    return 1
}
