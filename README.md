# GNOME for Chromebook One-Click Setup Script

This project provides a one-click Bash script for rapidly configuring GNOME desktop to be Chromebook-friendly on Linux systems (Arch, Debian, Ubuntu, Fedora). The script automatically configures Chromebook function keys, applies convenient shortcuts, a beautiful panel, and basic settings.

## Features

- Automatic detection of popular Linux distributions.
- Applies GNOME settings for keyboard shortcuts/function keys, panels and menus.
- One-step extension setup: [ArcMenu](https://extensions.gnome.org/extension/3628/arcmenu/), [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/), [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/).
- Installs and configures [keyd](https://github.com/rvaiya/keyd) for Chromebook-style function keys.
- Handles dependencies for your distribution automatically.

## Supported Distributions

- **Arch Linux**
- **Debian / Ubuntu**
- **Fedora**

## Requirements

- GNOME Shell 40+
- GNOME Extensions: [ArcMenu](https://extensions.gnome.org/extension/3628/arcmenu/), [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/), [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/) (please install them from [extensions.gnome.org](https://extensions.gnome.org/) before running)

## Usage

1. Download/copy the repository files.
    ```bash
    git clone https://github.com/Gometroluc/gnome-on-chromebook.git
    ```
2. Allow execution.
    ```bash
    chmod +x gnome-on-chromebook/CONFIGURE.sh
    ```
3. Run the script **as a regular user** (not via `sudo`!):
    ```bash
    ./gnome-on-chromebook/CONFIGURE.sh
    ```
    You will be prompted for **sudo password**.

## Keyd Configuration Warning

If multiple `.conf` files are present in `/etc/keyd/`, the script will display all and prompt for confirmation before overwriting them. If you don't know what **keyd** is, you can safely proceed.

## Troubleshooting

- **Extensions not detected**: Make sure you installed and activated each GNOME extension.
- **Keyd install failed**: For Fedora, the script enables COPR for keyd. For other distros, make sure [keyd](https://github.com/rvaiya/keyd) is available in repo or following manual install instructions.

## License

See [LICENSE](LICENSE) for details.

## Questions & Feedback

If you encounter any bugs or compatibility [issues](https://github.com/Gometroluc/gnome-on-chromebook/issues), please let me know: [rachuquito3@gmail.com](mailto:rachuquito3@gmail.com)
---

*Tested on Arch Linux, Ubuntu, Debian, and Fedora 38+. If you find bugs or incompatibility—open an issue!*
