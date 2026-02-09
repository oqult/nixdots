# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, callPackage, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./tuxedo.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn networkmanager-vpnc networkmanager-openconnect ];
    };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  #environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  # Enable COSMIC
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johnny = {
    isNormalUser = true;
    description = "johnny";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "input" "video" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # steam
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # flatpak
  services.flatpak.enable = true;

  # nix-command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # virtmanager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  # tailscale
  services.tailscale.enable = true;

  # noisetorch
  programs.noisetorch.enable = true;

  # xdg portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-cosmic ];
    config.common.default = "*";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    mangohud
    protonup-qt
    lutris
    heroic
    discord-ptb
    wineWowPackages.staging
    winetricks
    git
    curl
    vscode
    python3
    binutils
    distrobox
    podman
    distroshelf
    spotify
    rar
    bluez
    vscode
    dnsmasq
    openvpn
    moonlight-qt
    (vivaldi.overrideAttrs
      (oldAttrs: {
        dontWrapQtApps = false;
        dontPatchELF = true;
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.kdePackages.wrapQtAppsHook];
      }))
  ];


  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
      enable = "Source,Sink,Media,Socket";
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
        #FastConnectable = true;
      };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
      };
    };
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
  # services.openssh.enable = true;

  # avahi
 # services.avahi = {
 #   enable = true;
 #   nssmdns4 = true;
 #   openFirewall = true;
 #   publish = {
 #     enable = true;
 #     addresses = true;
 #     userServices = true;
 #   };
 # };

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 47984 47989 47990 48010 ];
   networking.firewall.allowedUDPPorts = [ 5353 47998 47999 48000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
