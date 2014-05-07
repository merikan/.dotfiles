#!/usr/bin/env bash -e
#
echo "      _       _    __ _ _             "
echo "     | |     | |  / _(_) |            "
echo "   __| | ___ | |_| |_ _| | ___  ___   "
echo "  / _\` |/ _ \| __|  _| | |/ _ \/ __|  "
echo " | (_| | (_) | |_| | | | |  __/\__ \  "
echo "(_)__,_|\___/ \__|_| |_|_|\___||___/  "
echo "______________________________________________"
echo
echo "Installing dotfiles into user's home directory"
echo

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
  git clone --recursive $dotfiles_repo $DOTFILES_ROOT
}

backup() {
  info "=== Backing up local dotfiles to directory $backupdir"
  mkdir -p $backupdir


  # Backup symlinks
  local files=( $(find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink) )
  for source in "${files[@]}"; do
    local dest="$destdir/.`basename \"${source%.*}\"`"
    if [ -L "$dest" ] && [ "$dest" -ef $source ]
    then
      info "$(basename $dest) is already a symlink pointing to $source, no need to backup"
      rm $dest
    elif [ -f $dest ] || [ -d $dest ] || [ -L "$dest" ]
    then
      mv $dest $backupdir
      success "moved $dest to $backupdir"
    fi
  done

# TODO fix this
  # Backup template files
  #local files=( $(find $DOTFILES_ROOT -maxdepth 2 -name \*.template) )
  #for source in "${files[@]}"; do
  #  local dest="$destdir/.`basename \"${source%.*}\"`"
  #  if [ -f $dest ] || [ -d $dest ] || [ -L "$dest" ]
  #    mv $dest $backupdir
  #    success "moved $dest to $backupdir"
  #  fi
  #done
}

cleanup() {
  info "=== Removing symlinks that targets $DOTFILES_ROOT"
  # this is done incase we have restructured our dotfiles
  for file in $HOME/.[^.]*
  do
  if [ -L "$file" ] && [[ $(readlink "$file") == $DOTFILES_ROOT* ]]; then
    rm -rf $file
 fi 

done
}

apply() {
  info "=== Applying dotfiles"

  local files=( $(find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink) )
  for source in "${files[@]}"; do
    local dest="$destdir/.`basename \"${source%.*}\"`"
    # link file
    ln -s $source $dest
    success "linked $dest to $source"
  done

  info "=== Copying template files"

  local files=( $(find $DOTFILES_ROOT -maxdepth 2 -name \*.template) )
  for source in "${files[@]}"; do
    local dest="$destdir/.`basename \"${source%.*}\"`"
    # link file
    cp $source $dest
    success "linked $dest to $source"
  done
}


#-----------------------------------------------------------------------------
# Initialize
#-----------------------------------------------------------------------------

destdir="$HOME"
DOTFILES_ROOT="$destdir/.dotfiles"
backupdir="$DOTFILES_ROOT-backup/$(date "+%Y%m%d%H%M.%S")"
dotfiles_repo="git://git.merikan.com/dotfiles.git"

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

# cleanup
cleanup
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