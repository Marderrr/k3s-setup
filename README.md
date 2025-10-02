# k3s-setup

**NixOS Anywhere Deployment**

nix run github:nix-community/nixos-anywhere --extra-experimental-features "nix-command flakes" -- --flake '.#kepler-1' nixos@<IP>
