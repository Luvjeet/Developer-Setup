#!/bin/bash

# Function to check if anything installed 
command_exists() {
  command -v "$1" &>/dev/null
}

# Installing zsh and oh-my-zsh with plugins like z zsh-autosuggestions etc
echo "Updating Linux..."
sudo apt update && sudo apt upgrade
echo "Installing zsh..."
sudo apt install -y zsh
chsh -s $(which zsh)

echo "Installing oh-my-zsh..."
sh -c "$(curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

zshrc_path="$HOME/.zshrc"
if [ -f "$zshrc_path" ]; then
    echo "Modifying $zshrc_path to include additional plugins..."
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions z web-search)/' "$zshrc_path"
else
    echo "Warning: .zshrc file not found. Please add the plugins manually."
fi

echo "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting


# Installing tmux epic and creating files tmux-cheat-sheet and tmux-sessionizer

echo "Installing Tmux (NOT FOR NOOBS)..."
sudo apt install -y tmux

tmux_file_create="$HOME/.tmux.conf"
if [! -f $tmux_file_create]; then
    echo "Creating tmux configuration..."
    cat <<EOF > $tmux_file_create
set -ga terminal-overrides ",screen-256color*:Tc"
set-option -g default-terminal "screen-256color"
set -s escape-time 0

set -g status-style 'bg=#333333 fg=#5eacd3'

bind r source-file ~/.tmux.conf
set -g base-index 1

set-window-option -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

bind-key -r f run-shell "tmux neww ~/.local/bin/tmux-sessionizer"
bind-key -r i run-shell "tmux neww tmux-cht.sh"
bind-key -r H run-shell "~/.local/bin/tmux-sessionizer ~/personal/Cpp"
bind -r D neww -c "#{pane_current_path}" "[[ -e TODO.md ]] && nvim TODO.md || nvim ~/personal/todo.md"
EOF
else
    echo "Something went wrong tmux file already exits"
fi

echo "Creating folders ~/personal && ~/work"
mkdir personal
mkdir work

tmux_cht="$HOME/.local/scripts/tmux-cht.sh"
if [! -f $tmux_cht]; then
   echo "Creating tmux-cheat-sheat for you..." 
   cat <<EOF > $tmux_cht
#!/usr/bin/env bash

languages=$(echo "golang c cpp javascript python nodejs bash typescript rust" | tr " " "\n")
core_utils=$(echo "find man ls kill ssh cat rm rename tldr tar less cp grep tr xargs sed awk ripgrep curl wget" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "Enter Query: " query

if echo "$languages" | grep -qs $selected; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less
fi
EOF
    chmod +x "$tmux_cht"

else
    echo "File already exits..."
fi

tmux_session_file="$HOME/.local/scripts/tmux-sessionizer"
if [! -f $tmux_session_file]; then
    echo "Creating sessionzer best thing?.."
    cat <<EOF > $tmux_session_file
#!/usr/bin/env bash

session=$(find ~ ~/personal ~/work ~/personal/AdventOfCode -mindepth 1 -maxdepth 1 -type d | fzf)
session_name=$(basename "$session" | tr . _)

if ! tmux has-session -t "$session_name" 2> /dev/null; then
    tmux new-session -s "$session_name" -c "$session" -d
fi

tmux switch-client -t "$session_name"
EOF

else
    echo "Bhai kuch toh gabad hai.."    
fi

# Installing g++, gcc and nvm 
if ! command_exists g++; then
    echo "Installing g++ for chad c++ users..."
    sudo apt install -y g++
else
    echo "Nikal"
fi

if ! command_exists gcc; then
    echo "Installing g++ for chad c++ users..."
    sudo apt install -y gcc
else
    echo "Nikal"
fi


if ! command_exists nvm; then
    echo "Installing g++ for chad c++ users..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
else
    echo "Nikal"
fi

echo "Installing latest version of Node.js (NOT A LANGUAGE) for soy devs..."
nvm install node --latest-npm
