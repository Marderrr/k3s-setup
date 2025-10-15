## First Node
### NixOS Anywhere Deployment
```
nix run github:nix-community/nixos-anywhere --extra-experimental-features "nix-command flakes" -- --flake '.#kepler-1' nixos@\<IP>
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
Uncomment/comment sections in configuration.nix and copy token (`/var/lib/rancher/k3s/server/token`) from node 1 to configuration.nix
### NixOS Anywhere Deployment
```
nix run github:nix-community/nixos-anywhere --extra-experimental-features "nix-command flakes" -- --flake '.#kepler-<NUMBER>' nixos@\<IP>
```
