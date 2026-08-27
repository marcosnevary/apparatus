set -e

printf "> Installing Homebrew...\n"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew update

printf "> Installing CLI tools...\n"
brew install git stow ghostty uv

printf "> Installing applications...\n"
brew install --cask helium-browser mos bitwarden filen obsidian discord nikitabobko/tap/aerospace spotify calibre font-jetbrains-mono-nerd-font

printf "> Installing Oh My Zsh...\n"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

printf "> Configuring Git...\n"
git config --global user.name "marcosnevary"
git config --global user.email "marcos.nevary@gmail.com"

printf "> Creating directories...\n"
mkdir -p ~/Desktop/Books/
mkdir -p ~/Desktop/Projects/
mkdir -p ~/Desktop/Research/

printf "> Cloning setup repository...\n"
cd ~/Desktop/Projects/
git clone https://github.com/marcosnevary/apparatus.git

printf "> Linking dotfiles...\n"
cd apparatus/config
stow -t ~ zsh aerospace

printf "> Setup complete. Please restart.\n"
