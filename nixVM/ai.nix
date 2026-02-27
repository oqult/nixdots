{ config, pkgs, ... }:

{
  # Ensure the GPU is ready for compute
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      libvdpau-va-gl
      libva
      libva-vdpau-driver
    ];
  };

  # Enable Podman backend
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      # Ollama Container
      ollama = {
        image = "ollama/ollama:latest";
        autoStart = true;
        volumes = [ "ollama_data:/root/.ollama" ];
        extraOptions = [
          "--device=/dev/kfd:/dev/kfd"
          "--device=/dev/dri:/dev/dri"
        ];
        environment = {
          HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # Critical for 6950 XT
        };
      };

      # Open WebUI Container
      open-webui = {
        image = "ghcr.io/open-webui/open-webui:main";
        autoStart = true;
        ports = [ "3000:8080" ];
        volumes = [ "open_webui_data:/app/backend/data" ];
        environment = {
          OLLAMA_BASE_URL = "http://ollama:11434";
        };
        dependsOn = [ "ollama" ];
      };
    };
  };
}
