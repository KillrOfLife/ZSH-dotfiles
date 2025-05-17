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
3. Uncomment and edit following line in `/etc/default/grub` to your selected
   theme:

    ```shell
    GRUB_THEME="/usr/share/grub/themes/catppuccin-<flavor>-grub-theme/theme.txt"
    ```

4. Update grub:

    ```shell
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

    For Fedora:

    ```shell
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

## Other to install
- portmaster
