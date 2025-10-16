# Preparation
## NixOS Installer
1. Boot into NixOS installer
2. Set nixos user password `passwd`
3. Replace hardware config
   1.  Get IP `ip addr`
   2.  SSH into NixOS Installer
   3.  Generate config `nixos-generate-config`
   4.  Copy hardware config and replace it
## Change Configs
### /nix/configuration.nix
Change `<IP>`, `<INTERFACE>` and `<SSH KEY>`
### /kustomize/metallb/default.yaml
Change `IP Address Pool`
### /kustomize/longhorn/backup-target.yaml
Change `NFS IP`
# Deployment
## First Node
### NixOS Anywhere Deployment
```
nix run github:nix-community/nixos-anywhere --extra-experimental-features "nix-command flakes" -- --flake '.#kepler-1' nixos@<IP>
```
### Clone Repo
```
git clone https://github.com/Marderrr/k3s-setup.git
cd k3s-setup
```
### Helm
```
cd helm
rm -rf /root/.local/share/helm/plugins
rm -rf /root/.cache/helm
helm plugin install https://github.com/jkroepke/helm-diff
helmfile sync
```
### Kustomize
```
cd ../kustomize
kubectl apply -k .
```
## Other Nodes
Uncomment/comment section in configuration.nix and copy token `/var/lib/rancher/k3s/server/token` from node 1 to configuration.nix
### NixOS Anywhere Deployment
```
nix run github:nix-community/nixos-anywhere --extra-experimental-features "nix-command flakes" -- --flake '.#kepler-<NUMBER>' nixos@<IP>
```
