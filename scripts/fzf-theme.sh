# fzf styled like gomuks' Ctrl+k switcher: a dark borderless panel, a centred
# pill title, the prompt at the bottom with the best match right above it,
# a ▌ in the pill's colour on the selected row, one row of space around the list. Typed
# letters show bold in the same colour, so the selected row isn't bold.
# Run in a full-screen herdr pane, it centres itself with --margin (pass e.g.
# --margin=25%,20% for 50% x 60% of the screen); outside it stays transparent.
# usage: fzf_panel "<icon> Title" <pill-bg-hex> <pill-fg-hex> [fzf args...]

fzf_panel() {
    local title=$1 bg=${2#\#} fg=${3#\#}
    shift 3
    local panel='#0e0e13'
    local pill
    pill=$(printf '\e[1;38;2;%d;%d;%d;48;2;%d;%d;%dm %s \e[0m' \
        "0x${fg:0:2}" "0x${fg:2:2}" "0x${fg:4:2}" \
        "0x${bg:0:2}" "0x${bg:2:2}" "0x${bg:4:2}" "$title")
    fzf --layout=default --border=top --border-label="$pill" --border-label-pos=0 \
        --padding=1,1,1,1 --info=default --separator=' ' --no-scrollbar \
        --pointer='▌' --marker=' ' --gutter=' ' --highlight-line --prompt='󰍉  ' \
        --color="bg:$panel,bg+:#1f1f28,gutter:$panel,border:$panel,info:$panel,separator:$panel" \
        --color="fg:#dedede,fg+:#dedede:regular,hl:#dedede:bold,hl+:#dedede:bold" \
        --color="pointer:#$bg,prompt:#a8a9eb,query:#dedede,spinner:$panel" \
        "$@"
}
