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

      #   symbol_map = let
      #     mappings = [
      #       "U+23FB-U+23FE"
      #       "U+2B58"
      #       "U+E200-U+E2A9"
      #       "U+E0A0-U+E0A3"
      #       "U+E0B0-U+E0BF"
      #       "U+E0C0-U+E0C8"
      #       "U+E0CC-U+E0CF"
      #       "U+E0D0-U+E0D2"
      #       "U+E0D4"
      #       "U+E700-U+E7C5"
      #       "U+F000-U+F2E0"
      #       "U+2665"
      #       "U+26A1"
      #       "U+F400-U+F4A8"
      #       "U+F67C"
      #       "U+E000-U+E00A"
      #       "U+F300-U+F313"
      #       "U+E5FA-U+E62B"
      #     ];
      #   in
      #     (builtins.concatStringsSep "," mappings) + " CaskaydiaCove Nerd Font";
    };
  };
}
