#!/usr/bin/env bash
set -e

printf "> Installing Homebrew...\n"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

printf "> Installing packages...\n"
brew install git gh stow uv ghostty helium-browser mos bitwarden filen obsidian obs nikitabobko/tap/aerospace claude-code calibre mactex-no-gui

printf "> Installing Oh My Zsh...\n"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

printf "> Installing Zsh plugins...\n"
ZSH_PLUGINS="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
[ -d "$ZSH_PLUGINS/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS/zsh-autosuggestions"
[ -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS/zsh-syntax-highlighting"

printf "> Configuring Git...\n"
git config --global user.name "marcosnevary"
git config --global user.email "marcos.nevary@gmail.com"

printf "> Configuring Claude Code...\n"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
mkdir -p "$(dirname "$CLAUDE_SETTINGS")"
[ -f "$CLAUDE_SETTINGS" ] || echo '{}' >"$CLAUDE_SETTINGS"
jq '.attribution = {"commit": "", "pr": ""}' "$CLAUDE_SETTINGS" >"$CLAUDE_SETTINGS.tmp"
mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"

printf "> Authenticating with GitHub...\n"
gh auth status &>/dev/null || gh auth login -h github.com -p ssh -w

printf "> Creating directories...\n"
mkdir -p ~/books/
mkdir -p ~/obsidian/
mkdir -p ~/projects/
mkdir -p ~/ufpa/

printf "> Cloning setup repository...\n"
cd ~/projects/
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone git@github.com:marcosnevary/apparatus.git

printf "> Linking dotfiles...\n"
cd apparatus/config
[ -L ~/.zshrc ] || rm -f ~/.zshrc
mkdir -p ~/.config
stow -t ~ zsh aerospace ghostty

printf "> Setting up capslock LaunchAgent...\n"
CAPSLOCK_SCRIPT="$HOME/projects/apparatus/scripts/capslock.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.marcos.capslock.plist"

chmod +x "$CAPSLOCK_SCRIPT"
mkdir -p "$(dirname "$PLIST_PATH")"

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

printf "> Enabling DRM in Helium...\n"
bash "$HOME/projects/apparatus/scripts/helium-drm.sh"

printf "> Opening apps that need Accessibility permission...\n"
open -a AeroSpace
open -a Mos

printf "> Setup complete. Please restart.\n"
