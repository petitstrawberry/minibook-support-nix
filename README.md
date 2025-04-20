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
  - Only tested on NixOS 24.11
- iio-sensor-proxy (<3.7)
  - v3.7 is broken on MiniBook
- Nix Flakes enabled

## Installation

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

