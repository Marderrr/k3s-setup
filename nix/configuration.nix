{ config, lib, pkgs, meta, ... }:

{
  imports = [];

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sg-latin1";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chef = {
    isNormalUser = true;
    initialPassword = "123";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5QqPCxSkG7+Zvb+t5pTOgqjdxR3zfw1zPTfeDpFgfGLgyl8tiULL+OZMK2jAGKV5Te6bBJncxr9gUFnARXVwdkTqiOWB9hChBYL8ln3LKhu/euALK76Jc1ZB6MMKqs0D2Ve1rGmZnam3+hKeXgSfHMcGDatxESnZQN7k3rJDRpBAfLWiaKL+8VyG4S0Z/n8DcMNo12kIb5lImi0otWx70t9RLANFHK+TfvbtcSq4xOZLLKPEhuNi4cZucXoGKlm+Re5sVeHriKE57IGzmqewE0a52a8wGQYd1dAnMVQiSbdrWKTUA3rFaMJeJ5VSL49mCmiPUEEAhMDB0Nk64BbxBla4gvagW/Wxj/yUJnPK5p9y47e1BHjMQL/X++oC8Ab4sqYeT5fLoWhwpdzo+S7weN+B+MpdARpsnpF5DGQS78TvQ9Ao1LmaehjlyfYXowRUMV7nk1qTH6WrPj9xSLjOvt8pr8ckhQm/XEz4Dfc+GwDM+FqaRxJXztWfw7c0tGPUrhe1X+/6PVY1Sa+t9YC8hTDW/dpqimMUukjLJMOyVdIAYCGE/8zIZMPyR/qZo9vNrVs9JIVGdcP+wo+OzIQDzCr2fVgH7ctw9Gm4wOwp94rcIVSxNdANESvncjV95zIhMDBJ0rsMcKtqt/GVZfU2+ej+XH/Usma4XKmYTA975Gw== umb\tim.bosshard@UMB-PF31ACCF" ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    k3s
    git
    vim
    nfs-utils
    kubernetes-helm
    helmfile
  ];

  # K3s
  # first node
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = toString [
      "--disable=servicelb"
      "--disable=local-storage"
      "--disable-helm-controller"
    ];
  };

  # rest of the nodes
  #services.k3s = {
  #  enable = true;
  #  role = "server"; # Or "agent" for worker only nodes
  #  token = "K1081f371390e8ace4a19d8675eac54ccfb9d053e9cca77717e6990e4f667df7c99::server:e823c7d3744016ab1b0b2f9e77b8bb4d";
  #  serverAddr = "https://192.168.68.133:6443";
  #  extraFlags = toString [
  #    "--disable=servicelb"
  #    "--disable=local-storage"
  #    "--disable-helm-controller"
  #  ]; 
  #};

  # Longhorn-Things + fix
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost";
  };
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  # System wide env
  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  # Open ports in the firewall.
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
