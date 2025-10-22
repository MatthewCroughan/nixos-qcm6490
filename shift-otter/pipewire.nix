{
  security.rtkit.enable = true;
  services.pipewire = {
    jack.enable = true;
    raopOpenFirewall = true;
    extraConfig.pipewire."raop-sink" = {
      "context.modules" = [
        { name = "libpipewire-module-raop-discover"; args = { }; }
      ];
    };
    extraConfig.pipewire."92-less-crackles" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 1024;
      };
    };
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}

