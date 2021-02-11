# Delete and reinstall Homebrew from Homebrew Github repo
rm -rf $HOME/goinfre/.brew
rm -rf $HOME/.brew
git clone --depth=1 https://github.com/Homebrew/brew $HOME/goinfre/.brew
# Create .brewconfig script in $HOME dir
cat > $HOME/.brewconfig.zsh <<EOL
# HOMEBREW CONFIG
# Add brew to path
export PATH=\$HOME/goinfre/.brew/bin:\$PATH
# Set Homebrew temporary folders
export HOMEBREW_CACHE=\$HOME/goinfre/tmp/\$USER/Homebrew/Caches
export HOMEBREW_TEMP=\$HOME/goinfre/tmp/\$USER/Homebrew/Temp
mkdir -p \$HOMEBREW_CACHE
mkdir -p \$HOMEBREW_TEMP
# If NFS session
# Symlink Locks folder in /tmp
if df -T autofs,nfs \$HOME 1>/dev/null
then
  HOMEBREW_LOCKS_TARGET=\$HOME/goinfre/tmp/\$USER/Homebrew/Locks
  HOMEBREW_LOCKS_FOLDER=\$HOME/goinfre/.brew/var/homebrew
  mkdir -p \$HOMEBREW_LOCKS_TARGET
  mkdir -p \$HOMEBREW_LOCKS_FOLDER
  # Symlink to Locks target folders
  # If not already a symlink
  if ! [[ -L \$HOMEBREW_LOCKS_FOLDER && -d \$HOMEBREW_LOCKS_FOLDER ]]
  then
     echo "Creating symlink for Locks folder"
     rm -rf \$HOMEBREW_LOCKS_FOLDER
     ln -s \$HOMEBREW_LOCKS_TARGET \$HOMEBREW_LOCKS_FOLDER
  fi
fi
EOL

# Add .brewconfig sourcing in your .zshrc if not already present
if ! grep -q "# Load Homebrew config script" $HOME/.zshrc
then
cat >> $HOME/.zshrc <<EOL
# Load Homebrew config script
source \$HOME/.brewconfig.zsh
export MINIKUBE_HOME="$HOME/goinfre/.minikube"
export KUBECONFIG="$KUBECONFIG:$HOME/goinfre/.kube/config"
export MACHINE_STORAGE_PATH="$HOME/goinfre/.docker"
EOL
fi

# brew update
source $HOME/.brewconfig.zsh
brew update

# Reload .zshrc
source $HOME/.zshrc

# Install minikube
if ls -la $HOME | grep -ce .minikube; then echo "\033[1;4;31mminikube already installed"; else brew install minikube;fi

# Install docker
if ls -la $HOME | grep -ce .docker; then echo "\033[1;4;31mdocker already installed"; else brew install docker;fi

# After

minikube start

source $HOME/.brewconfig.zsh
