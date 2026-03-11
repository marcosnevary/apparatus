#!/bin/bash
set -e

printf "> Installing Homebrew...\n"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew update

printf "> Installing CLI tools...\n"
brew install git stow kitty neovim node uv oven-sh/bun/bun

printf "> Installing applications...\n"
brew install --cask google-chrome mos raycast bitwarden filen obsidian discord nikitabobko/tap/aerospace
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font

printf "> Installing fonts...\n"
brew install --cask font-jetbrains-mono-nerd-font

printf "> Installing Oh My Zsh...\n"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

printf "> Configuring Git...\n"
git config --global user.name "marcosnevary"
git config --global user.email "marcos.nevary@gmail.com"
ssh-keygen -t ed25519 -C "marcos.nevary@gmail.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
pbcopy <~/.ssh/id_ed25519.pub
printf "> SSH key copied to clipboard!\n"
printf "> Go to: https://github.com/settings/ssh/new\n"
printf "> Paste the key and save.\n"
printf "> Press ENTER when done...\n"
read
ssh -T git@github.com || true

printf "> Creating directories...\n"
mkdir -p ~/Desktop/omnia/
mkdir -p ~/Desktop/repositories/

printf "> Cloning setup repository...\n"
cd ~/Desktop/repositories/
git clone git@github.com:marcosnevary/apparatus.git

printf "> Linking dotfiles...\n"
cd apparatus/config
stow -t ~ zsh kitty nvim aerospace yazi

printf "> Setup complete. Please restart Kitty.\n"
