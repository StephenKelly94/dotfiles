Add to bashrc
```sh
  alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Add .cfg to gitignore
```
  echo ".cfg" >> .gitignore
```

Clone the repo
```
  git clone --bare <git-repo-url> $HOME/.cfg
```

Add to current shell scope
```
  alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout the changes
```
  config checkout
```

Remove untracked changes
```
  config config --local status.showUntrackedFiles no
```
