# Laptop

```sh
# copy ssh key
git clone git@github.com:killroflife/zsh-dotfiles dotfiles
sudo rpm-ostree install thefuck zsh git stow 
sudo rpm-ostree install zscroll polybar pavucontrol dunst pulseaudio-utils playerctl
stow .
sudo usermod --shell /usr/sbin/zsh arcana


gsettings set org.gnome.desktop.wm.preferences workspace-names "['Web', 'Code', 'Term', 'Music']"

sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon\
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install



```

install grencode
