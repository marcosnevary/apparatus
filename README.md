# apparatus

Setup for a freshly formatted MacBook: installs apps and CLI tools, links dotfiles and applies small system tweaks.

## Install

On a clean macOS, open Terminal and run:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/marcosnevary/apparatus/main/scripts/install.sh)"
```

## What the script does

1. Installs Homebrew and all packages: `git`, `gh`, `stow`, `uv`, Ghostty, Helium, Mos, Bitwarden, Filen, Obsidian, AeroSpace, Claude Code, calibre and MacTeX.
2. Installs Oh My Zsh with the `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins.
3. Sets the global Git name and email.
4. Turns off Claude Code's co-author attribution in commits and PRs.
5. Signs in to GitHub with `gh`, which creates an SSH key and adds it to your account.
6. Creates `~/books`, `~/research` and `~/projects`.
7. Clones this repository over SSH into `~/projects/apparatus`.
8. Links the dotfiles in `config/` into `~` with GNU Stow.
9. Registers a LaunchAgent that removes the Caps Lock delay at login.
10. Opens AeroSpace and Mos so macOS asks for their Accessibility permission.

## Structure

```
config/          dotfiles, one Stow package per app
  aerospace/     ~/.config/aerospace/aerospace.toml
  ghostty/       ~/.config/ghostty/config
  zsh/           ~/.zshrc and the custom "minimal" Oh My Zsh theme
scripts/
  install.sh     setup script
  capslock.sh    removes the Caps Lock delay (run by the LaunchAgent)
```

Each folder in `config/` mirrors the home directory, so `config/ghostty/.config/ghostty/config` becomes `~/.config/ghostty/config`. Since the files are symlinks, editing them in place changes the repository.

To version a new app's config, move its files into `config/<app>/` following the same layout, run `stow -t ~ <app>` from `config/`, and add `<app>` to the `stow` line in `install.sh`.