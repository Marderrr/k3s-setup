## Host
### NixOS Anywhere Deployment
nix run github:nix-community/nixos-anywhere --extra-experimental-features "nix-command flakes" -- --flake '.#kepler-1' nixos@\<IP>

## First Node
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
