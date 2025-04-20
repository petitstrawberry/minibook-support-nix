# minibook-support

This repository provides "minibook-support," a Linux support software package for CHUWI MiniBook (8-inch) and MiniBook X (10-inch). It is designed to simplify installation and configuration using Nix/NixOS with Flake support.

## Features
- **Tablet Mode Support**: Automatically switches to tablet mode when the device is folded.
- **Keyboard Management**: Automatically enables/disables the keyboard based on the mode.
- **Mouse Management**: Calibrates and controls the enable/disable state of the trackpoint and touchpad.

## Requirements
- CHUWI MiniBook (8-inch) or MiniBook X (10-inch)
- Linux Kernel 6.9 or later
- Nix or NixOS

## Installation

### Build and Install with Nix Flake

1. Clone this repository:

   ```zsh
   git clone https://github.com/petitstrawberry/minibook-support-nix.git
   cd minibook-support-nix
   ```

2. Enable Nix Flakes (if not already enabled):

   Add the following to `/etc/nix/nix.conf`:

   ```
   experimental-features = nix-command flakes
   ```

   Then restart the Nix daemon:

   ```zsh
   sudo systemctl restart nix-daemon
   ```

3. Build and install the package:

   ```zsh
   nix build .#packages.x86_64-linux.default
   sudo nix-env -i ./result
   ```

### Enable as a NixOS Module

If you are using NixOS, you can integrate this package into your system configuration to automatically enable its services.

1. Add this repository as an input in your `flake.nix`:

   ```nix
   inputs.minibook-support.url = "github:petitstrawberry/minibook-support-nix";
   ```

2. Import the module in the `outputs` section:

   ```nix
   outputs = { self, nixpkgs, minibook-support, ... }: {
     nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
         ./configuration.nix
         minibook-support.nixosModules.default
       ];
     };
   };
   ```

3. Add the following to your `configuration.nix`:

   ```nix
   services.minibook-support.enable = true;
   ```

4. Rebuild your system:

   ```zsh
   sudo nixos-rebuild switch
   ```

This will automatically enable the `moused`, `keyboardd`, and `tabletmoded` systemd services.

## Contributing

Contributions are welcome! If you find a bug, have a feature request, or want to improve the documentation, feel free to open an issue or submit a pull request.

### How to Contribute
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with clear and concise messages.
4. Push your changes to your fork.
5. Open a pull request to the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

