#!/usr/bin/env bash -e
#
echo ''

info () {
  printf "  [ \033[00;34mINFO\033[0m ] $1 \n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo '' 
  exit
}


update() {
  info "Updating dotfiles"
  git pull origin master
  #git submodule init
  #git submodule update
}

download() {
  info "=== Downloading dotfiles"
  git clone --recursive git://git.merikan.com/dotfiles.git $DOTFILES_ROOT
}

backup() {
  info "=== Backing up local dotfiles to directory $backupdir"
  mkdir -p $backupdir

  local files=( $(find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink) )
  for source in "${files[@]}"; do
    local dest="$destdir/.`basename \"${source%.*}\"`"
    if [ -L "$dest" ] && [ "$dest" -ef $source ]
    then
      info "$(basename $dest) is already a symlink pointing to $source, no need to backup"
      rm $dest
    elif [ -f $dest ] || [ -d $dest ] || [ -L "$dest" ]
    then
      echo "Kommando: mv $dest $backupdir"
      mv $dest $backupdir
      success "moved $dest to $backupdir"
    else
      echo "$dest pointing to $(readlink $dest)"
    fi
  done
}

apply() {
  info "=== Applying dotfiles"

  local files=( $(find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink) )
  for source in "${files[@]}"; do
    local dest="$destdir/.`basename \"${source%.*}\"`"
    # link file
    echo "ln -s $source $dest"
    ln -s $source $dest
    success "linked $source to $dest"
  done
}


#-----------------------------------------------------------------------------
# Initialize
#-----------------------------------------------------------------------------

destdir="$HOME"
DOTFILES_ROOT="$destdir/.dotfiles"
backupdir="$DOTFILES_ROOT-backup/$(date "+%Y%m%d%H%M.%S")"

#-----------------------------------------------------------------------------
# Just do it
#-----------------------------------------------------------------------------

# Is it already installed? Update or download
if [ -d $DOTFILES_ROOT ]; then
  pushd $DOTFILES_ROOT > /dev/null
  update
else
  download
  pushd $DOTFILES_ROOT > /dev/null
fi
echo "working directory: $(pwd)"

# backup before applying
backup
# Apply
apply

#-----------------------------------------------------------------------------
# Finished
#-----------------------------------------------------------------------------
popd > /dev/null
success "Done applying dotfiles"
#exec $SHELL -l