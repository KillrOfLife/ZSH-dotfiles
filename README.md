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
```


## Other to install
- portmaster