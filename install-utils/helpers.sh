
sudoPrompt() {
    if sudo -n true 2>/dev/null; then
        sudo $1
    else
        info "${2}"
        sudo $1
    fi      
}