{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = lib.mkForce {
    enable = true;
    font = {
      name = "CaskaydiaCove Nerd Font";
      size = 13;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 18;
      background_opacity = "1";
      background_blur = 5;
      cursor_shape = "beam";
      shell = "${pkgs.zsh}/bin/zsh";

      # Charmful
      cursor = "#ffffff";
      cursor_text_color = "#171717";
      background = "#171717";
      foreground = "#b2b5b3";
      selection_foreground = "#ffffff";
      selection_background = "#313234";
      color0 = "#373839";
      color1 = "#e55f86";
      color2 = "#00D787";
      color3 = "#EBFF71";
      color4 = "#51a4e7";
      color5 = "#9077e7";
      color6 = "#51e6e6";
      color7 = "#e7e7e7";
      color8 = "#313234";
      color9 = "#d15577";
      color10 = "#43c383";
      color11 = "#d8e77b";
      color12 = "#4886c8";
      color13 = "#8861dd";
      color14 = "#43c3c3";
      color15 = "#b2b5b3";
    };
  };
}
