# Ze best zshell

This is my personal configuration of zsh. Enjoy!

## Initialization
```sh
#optional
sudo rpm-ostree install thefuck zsh git stow

git clone https://xxx ~/dotfiles
cd ~/dotfiles
stow .
#or
stow --adopt .


sudo usermod --shell $(which zsh) $USER

#grub
sudo cp -r root/* /
```
