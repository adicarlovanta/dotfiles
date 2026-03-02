#!/bin/bash


# Get the directory in which this script lives.
script_dir=$(dirname "$(readlink -f "$0")")

create_symlinks() {

    # Get a list of all files in this directory that start with a dot.
    files=$(find . -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename "$file")
        echo "Creating symlink to $name in home directory."
        cat "$script_dir/$name" >> "$HOME/$name"
    done

}

cat "$script_dir/template.bashrc" >> "$HOME/.bashrc"

create_symlinks

while read -r line; do
    echo "Installing package: $line"
    sudo apt-get install -y "$line"
done < pkglist

wget https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz 
tar xvf ble-nightly.tar.xz
chmod +x ble-nightly/ble.sh
bash ble-nightly/ble.sh --install "$HOME/.local/share/"

bash "$HOME"/.local/share/blesh/ble.sh --update 



