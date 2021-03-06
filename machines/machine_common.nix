{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
  };

  nix = {
    buildCores = 0;
    useSandbox = true;
    binaryCaches = [
      "https://headcounter.org/hydra/"
      "https://cache.nixos.org/"
    ];
    requireSignedBinaryCaches = true;
    binaryCachePublicKeys = [
      "headcounter.org:/7YANMvnQnyvcVB6rgFTdb8p5LG1OTXaO+21CaOSBzg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    nixPath = lib.mkOptionDefault [ "nixpkgs=/home/dev/git/remote/other_github/nixpkgs" ];
  };

  time = {
    timeZone = "Europe/London";
  };

  system = {
    fsPackages = with pkgs; [
      sshfsFuse
      fuse
      cryptsetup
    ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      s3tcSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = true;
      systemWide = false;
    };
  };

  programs = {
    ssh = {
      startAgent = false;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    bash = {
      enableCompletion = true;
      promptInit = ''
        # Provide a nice prompt.
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
        eval `dircolors ~/.dir_colors`
      '';
    };
  };

  environment = {
    shells = [ "/run/current-system/sw/bin/zsh" ];
    sessionVariables.TERM = "xterm-256color";
  };

  fonts = {
    fontconfig = {
      enable = true;
      ultimate = {
        enable = true;
      };
    };
    enableGhostscriptFonts = true;
    enableCoreFonts = true;
    fonts = with pkgs; [
      clearlyU
      cm_unicode
      dejavu_fonts
      dosemu_fonts
      font-awesome-ttf
      freefont_ttf
      hack-font
      inconsolata
      powerline-fonts
      proggyfonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      terminus_font
      tewi-font
      ttf_bitstream_vera
      ubuntu_font_family
      unifont
      vistafonts
      wqy_microhei
    ] ++ lib.filter lib.isDerivation (lib.attrValues lohit-fonts);
  };
}
