{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      family = "monospace";
      size = 16.0;
    };
    scrollback_lines = 10000;
    window_padding_width = 2;
    tab_bar_edge = "bottom";
    hide_window_decorations = true;
    background_opacity = 0.9;
  };
}
