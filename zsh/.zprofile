PATH=$PATH:$HOME/.local/bin

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -f "$HOME/.cargo/env" ]]; then
    . $HOME/.cargo/env
fi

if [[ -f "$HOME/.cargo/bin/rtx" ]]; then
    . <(rtx env)
fi

#if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
#    export MOZ_ENABLE_WAYLAND=1
#fi

if (( $+commands[podman] )) then
    export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
fi

if (( $+commands[sccache] )) then
	export RUSTC_WRAPPER=$(which sccache)
fi

if (( $+commands[zellij] )) then
	alias tmux=zellij
fi

# Wasmer
export WASMER_DIR="/home/zed/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

export PATH
export WLR_NO_HARDWARE_CURSORS=1
