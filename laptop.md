# Laptop

```sh
# copy ssh key
git clone git@github.com:killroflife/zsh-dotfiles dotfiles
sudo rpm-ostree install thefuck zsh git stow 
sudo rpm-ostree install zscroll polybar pavucontrol dunst pulseaudio-utils playerctl
stow .
sudo usermod --shell /usr/sbin/zsh arcana


gsettings set org.gnome.desktop.wm.preferences workspace-names "['Web', 'Code', 'Term', 'Music']"
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

install grencode