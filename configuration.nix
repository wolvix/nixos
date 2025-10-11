# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.wolven = import ./home.nix;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "minix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "no";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wolven = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Allow DRM content i Chromium. Needed for Spotify

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config = {
    chromium = {
      enableWideVine = true;
    };
  };


  # Programs
  programs.firefox.enable = true;
  programs.chromium.enable = true;

  ######################
  ### Hyprland START ###
  ######################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #nvidiaPatches = true; # ONLY use this line if you have an nvidia card  
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
  ####################
  ### Hyprland END ###
  ####################

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim 			# Most popular clone of the VI editor
    neovim 			# Vim text editor fork focused on extensibility and agility
    wget			# Tool for retrieving files using HTTP, HTTPS, and FTP
    yazi 			# Blazing fast terminal file manager written in Rust, based on async I/O
    kitty 			# The fast, feature-rich, GPU based terminal emulator
    foot 			# Fast, lightweight and minimalistic Wayland terminal emulator
    waybar 			# Highly customizable Wayland bar for Sway and Wlroots based compositors
    hyprpaper 			# Blazing fast wayland wallpaper utility
    wofi 			# Launcher/menu program for wlroots based wayland compositors such as sway
    pavucontrol 		# PulseAudio Volume Control
    ncpamixer 			# Terminal mixer for PulseAudio inspired by pavucontrol
    git 			# Distributed version control system
    geany 			# Small and lightweight IDE
    nwg-look 			# GTK settings editor
    nwg-displays 		# Output management utility for Sway and Hyprland
    tokyonight-gtk-theme 	# GTK theme based on the Tokyo Night colour palette
    adwaita-icon-theme 		# Private UI icon set for GNOME core apps.
    adwaita-icon-theme-legacy 	# Fullcolor icon theme providing fallback for legacy apps
    mpv 			# General-purpose media player
    deluge-gtk 			# Torrent client
    material-black-colors 	# Material Black Colors icons
    rose-pine-hyprcursor 	# Rose Pine theme for Hyprcursor
    stow 			# A symlink farm manager
    chromium 			# Open source web browser from Google
    widevine-cdm 		# Widevine CDM
    vscode 			# Code editor developed by Microsoft
  ];

  # Install fonts
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.font-awesome
  ];

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

  # Enable SDDM Display Mananger
  services.displayManager.sddm.enable = true; #This line enables sddm
  services.displayManager.sddm.wayland.enable = true;



  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

