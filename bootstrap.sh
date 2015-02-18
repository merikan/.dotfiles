#!/usr/bin/env bash -e
#
echo "      _       _    __ _ _                     "
echo "     | |     | |  / _(_) |                    "
echo "   __| | ___ | |_| |_ _| | ___  ___           "
echo "  / _\` |/ _ \| __|  _| | |/ _ \/ __|         "
echo " | (_| | (_) | |_| | | | |  __/\__ \          "
echo "(_)__,_|\___/ \__|_| |_|_|\___||___/          "
echo "______________________________________________"
echo "                                              "
echo "Installing dotfiles into user's home directory"
echo "                                              "

reset='\e[0m'           # Text Reset
red='\e[0;31m'          # Red
green='\e[0;32m'        # Green
yellow='\e[0;33m'       # Yellow
blue='\e[0;34m'         # Blue
purple='\e[0;35m'       # Purple
cyan='\e[0;36m'         # Cyan
white='\e[0;37m'        # White

heading() {
    printf "\n${white}$1${reset}\n"
}

info() {
    printf "  [ ${blue}..${reset} ] $1\n"
}

success() {
    printf "  [ ${green}OK${reset} ] $1\n"
}

warn() {
    printf "  [${yellow}WARN${reset}] $1\n"
}

fail() {
    printf "  [${red}FAIL${reset}] $1\n"
    exit 1
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
  # this is done in case we have restructured our dotfiles
  for file in $HOME/.[^.]*
  do
    if [ -L "$file" ] && [[ $(readlink "$file") == $DOTFILES_ROOT* ]]; then
      rm -rf $file
    fi
  done
  
  #TODO: purge old backups
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
    success "copied $source to $dest"
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
