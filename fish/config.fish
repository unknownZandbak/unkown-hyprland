if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    export PATH="$HOME/.cargo/bin:$PATH"
    export TERM=xterm
    neofetch
end
