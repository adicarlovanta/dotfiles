#!/bin/bash


# Get the directory in which this script lives.
script_dir=$(dirname "$(readlink -f "$0")")

write_files() {

    # Get a list of all files in this directory that start with a dot.
    files=$(find . -maxdepth 1 -type f -name ".*")

    # Add the contents of each dotfile to the corresponding file in the home directory.
    # Use a >> to append the contents rather than overwriting existing files.
    for file in $files; do
        name=$(basename "$file")
        echo "Creating symlink to $name in home directory."
        cat "$script_dir/$name" >> "$HOME/$name"
    done
}

cat "$script_dir/template.bashrc" >> "$HOME/.bashrc"
cat "$script_dir/.claude/settings.local.json" >> "$HOME/.claude/settings.local.json"
ln -sf "$HOME/.claude/settings.local.json" /workspaces/obsidian/.claude/settings.local.json

write_files

while read -r line; do
    echo "Installing package: $line"
    sudo apt-get install -y "$line"
done < pkglist

wget https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz 
tar xvf ble-nightly.tar.xz
chmod +x ble-nightly/ble.sh
bash ble-nightly/ble.sh --install "$HOME/.local/share/"

bash "$HOME"/.local/share/blesh/ble.sh --update 

claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman
npm install -g @caveman-ai/cli


just enable-claude-plugin issue-management
