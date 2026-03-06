To replicate it on another system.

To automatically set up
curl -sL https://jesushrek.github.io/install | sh

For manual 
git clone --bare https://gitlab.com/shrek68/dotfiles $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
dotfiles checkout 
dotfiles config --local status.showUntrackedFiles no

To fetch all the packages
sudo xbps-install -S $(cat ~/.config/pkglist.txt)

To get the packges 
xbps-query -m | xargs -n1 xbps-uhelper getpkgname > ~/.config/pkglist.txt

to Fetch all the wallpapers 

git clone https://gitlab.com/shrek68/wallpapers.git

- GO AWAY FROM THIHS PAGE -
