# Ze best zshell

This is my personal configuration of zsh. Enjoy!

## Initialization
```sh
#optional
sudo apt install -y build-essential yacc

git clone https://xxx ~/dotfiles
cd ~/dotfiles
stow .
#or
stow --adopt .


sudo usermod --shell $(which zsh) $USER
hydectl theme import --name "Nordic Blue" --url "https://github.com/HyDE-Project/hyde-themes/tree/Nordic-Blue"
hydectl theme import --name "Tokyo Night" --url "https://github.com/HyDE-Project/hyde-themes/tree/Tokyo-Night"
hydectl theme import --name "Catppuccin Mocha" --url "https://github.com/HyDE-Project/hyde-themes/tree/Catppuccin-Mocha"

```


## Other to install
- portmaster
