# mili-toolbox

Declarative macOS dev environment. Clone it on any Mac, run one script, done.

Built on [Nix](https://determinate.systems/) + [nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager) pinned to the `26.05` release.

## What it sets up

| Layer | Tool | Config |
|---|---|---|
| System | nix-darwin | `configuration.nix` |
| Home | home-manager | `home.nix` |
| Terminal | WezTerm | `home/.config/wezterm/` |
| Editor | Neovim | `home/.config/nvim/` |
| Shell | Zsh + Starship | `home.nix` |
| AI tools | Claude Code, Codex, opencode | `home/.claude/`, `home/AGENTS.md` |
| Extras | herdr | `home/.config/herdr/` |

### System defaults (configuration.nix)
- Dark mode, fast key repeat, auto-hide menu bar and dock
- Finder in list view, clean desktop, tap-to-click
- Homebrew managed declaratively via `nix-homebrew` — anything not listed gets removed on rebuild

### CLI packages (home.nix)
`ripgrep` · `fd` · `fzf` · `jq` · `lazygit` · `neovim` · Hack Nerd Font

### Shell (Zsh)
- Autosuggestions (`^f` to accept) and syntax highlighting
- Starship prompt: directory → branch → status → duration
- Aliases: `..` `add` `push` `pull` `m` (switch main) `cc` (claude) `co` (codex)

### Neovim
Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)

| Plugin | Purpose |
|---|---|
| oil.nvim | File browser (`<leader>e`) |
| snacks.nvim | Files / grep / buffers / LSP go-to-def (`<leader>f/s/b`, `gd`) |
| neogit + diffview | Git UI (`<leader>g`) |
| gitsigns | Inline blame on every line |
| which-key | Leader key cheatsheet popup |

Custom keymaps: `<Esc>` saves, `<C-a>` selects all, paste-over keeps clipboard.

### WezTerm
Rose Pine Moon theme, JetBrains Mono 14pt, 80% background opacity, no tab bar when single tab.

### Claude Code statusline
`home/.claude/statusline-command.sh` shows the active model, context window usage, and 5-hour rate limit in the Claude Code TUI status bar.

## Bootstrap (fresh Mac)

```bash
git clone <this-repo> ~/dotfiles   # or wherever you like
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` does three things:
1. Installs [Determinate Nix](https://install.determinate.systems/) if not present
2. Symlinks the repo to `~/.dotfiles` (home-manager resolves paths through this)
3. Runs `darwin-rebuild switch --flake ~/.dotfiles#mac` for the first time

After it finishes, open a new terminal — your shell, editor, and apps are ready.

## Apply changes

```bash
./rebuild.sh
```

Edit any file in the repo, then run `rebuild.sh`. It re-symlinks `~/.dotfiles` and runs `darwin-rebuild switch`. Homebrew casks/brews not listed in `configuration.nix` are removed automatically (`onActivation.cleanup = "zap"`).

## Repo structure

```
.
├── flake.nix           # inputs: nixpkgs, nix-darwin, home-manager, nix-homebrew
├── flake.lock          # pinned versions
├── configuration.nix   # system-level: macOS defaults, homebrew, nix-darwin settings
├── home.nix            # user-level: packages, shell, git, dotfile symlinks
├── bootstrap.sh        # run once on a fresh machine
├── rebuild.sh          # run after every change
└── home/               # dotfiles symlinked into ~ by home-manager
    ├── AGENTS.md           # AI agent instructions (Claude, Codex, opencode)
    ├── .claude/
    │   ├── settings.json       # Claude Code TUI settings
    │   └── statusline-command.sh
    └── .config/
        ├── nvim/               # Neovim config (lazy.nvim)
        ├── wezterm/            # WezTerm config
        └── herdr/              # herdr config
```

## Credits

Inspired by [Kun Chen's dotfiles setup](https://www.youtube.com/watch?v=5N-okeDdIuI).

## Notes

- Platform is `aarch64-darwin` (Apple Silicon). Change to `x86_64-darwin` in `configuration.nix` for Intel.
- The flake host label is `mac`. If you rename it, update it in `flake.nix`, `bootstrap.sh`, and `rebuild.sh`.
- Nix daemon is managed by Determinate — `nix.enable = false` in `configuration.nix` prevents nix-darwin from conflicting with it.
- Dotfiles under `home/` use `mkOutOfStoreSymlink` so edits take effect immediately without a rebuild.
