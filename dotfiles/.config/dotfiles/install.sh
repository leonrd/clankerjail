git clone --separate-git-dir=$HOME/.dotfiles.git . $HOME/.dotfiles-tmp
rm -r $HOME/.dotfiles-tmp
function dotfiles {
  git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $@
}
dotfiles checkout
if [ $? = 1 ]; then
  echo "Checked out dotfiles.";
else
  echo "Stashing up pre-existing dot files.";
  dotfiles stash save
fi;
dotfiles checkout $HOME/
dotfiles config status.showUntrackedFiles no