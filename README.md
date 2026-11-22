# My Windows dotfiles

Some of my dotfiles. Managed by [chezmoi](https://www.chezmoi.io/).

## How to use

### Apply configs from this repo

- Apply configs from this repo on a new, empty machine:

  ```powershell
  chezmoi init --apply https://github.com/jalaxy33/win-dotfiles
  ```

  > <details>
  > <summary>Easier clone for CN user:</summary>
  >
  > ```powershell
  > chezmoi init --apply https://gh-proxy.org/https://github.com/jalaxy33/win-dotfiles
  > ```
  >
  > </details>

- Sync with latest configs:

  ```powershell
  chezmoi update
  ```

- Sync with certain config file:

  ```powershell
  chezmoi apply <path-to-file>
  ```

### Check difference with remote

- Check changed files:

  ```powershell
  chezmoi status
  ```

- Check differences:

  ```powershell
  chezmoi diff
  ```

### Deal with conflicts

- Go to local chezmoi folder, and deal with `git`:

  ```powershell
  chezmoi cd
  git <command>
  exit
  ```

## Advanced Usages

Please check [chezmoi](https://www.chezmoi.io/) for details.

<details>
<summary>More tips</summary>

### Sync with local changes

- Manage new configs:

  ```powershell
  chezmoi add <path-to-config_file>
  ```

- After editing local configs, update all chezmoi managed configs by:

  ```powershell
  chezmoi re-add
  ```

- Commit and push changes:

  ```powershell
  chezmoi cd
  git add -A
  git commit -m "<commit messages>"
  git push
  exit
  ```

### Ignore files

Edit `.chezmoiignore`:

```powershell
chezmoi cd
vi .chezmoiignore
```

Add files you want to ignore:

```gitignore
README.md
```

### Use profiles in PowerShell

- PowerShell 7 reads `~/Documents/PowerShell/profile.ps1`.
- Windows PowerShell 5.1 reads `~/Documents/WindowsPowerShell/profile.ps1`,
  which loads the PowerShell 7 profile, so both shells share one config.

</details>
