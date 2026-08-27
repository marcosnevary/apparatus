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

printf "> Setting up capslock LaunchAgent...\n"
CAPSLOCK_SCRIPT="$HOME/Desktop/Projects/apparatus/scripts/capslock.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.marcos.capslock.plist"

chmod +x "$CAPSLOCK_SCRIPT"

cat >"$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.marcos.capslock</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${CAPSLOCK_SCRIPT}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/capslock.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/capslock.error.log</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)/com.marcos.capslock" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"

printf "> Setup complete. Please restart.\n"