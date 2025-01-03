{
  inputs,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # plugins = inputs.hyprland-plugins.packages.${pkgs.system};

  yt = pkgs.writeShellScript "yt" ''
    notify-send "Opening video" "$(wl-paste)"
    mpv "$(wl-paste)"
  '';

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  swayosd-client = "${pkgs.swayosd}/bin/swayosd-client";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  screenshot = import ./scripts/screenshot.nix pkgs;
in {
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-hyprspace.packages.${pkgs.system}.default
      # plugins.hyprexpo
      # plugins.hyprbars
      # plugins.borderspp
    ];

    settings = {
      env = [
        "HYPRCURSOR_THEME, Hypr-Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE, 24"
      ];
      exec-once = [
        "hyprctl setcursor Hypr-Bibata-Modern-Ice 24"
        "1password --silent"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nwg-dock-hyprland -d"
        "hyprpaper"
        "hypridle"
        "jetbrains-toolbox"
        "${pkgs.swayosd}/bin/swayosd-server"
        "walker --gapplication-service"
        "swaync"
        "waybar"
      ];

      monitor = [
        "eDP-1, 1920x1080, 0x0, 1"
      ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" = "rgba(00a2f8ff) rgba(00e5cfff) 45deg";
      };

      misc = {
        disable_splash_rendering = false;
        force_default_wallpaper = -1;
        enable_swallow = true;
        swallow_regex = "(foot|kitty|allacritty|Alacritty)";
        focus_on_activate = true;
      };

      input = {
        kb_layout = "es";
        follow_mouse = 1;
        mouse_refocus = false;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          drag_lock = true;
        };
        sensitivity = 0;
        float_switch_override_focus = 2;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_use_r = true;
      };

      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      windowrule = let
        f = regex: "float, ^(${regex})$";
      in [
        (f "org.gnome.Calculator")
        (f "org.gnome.Nautilus")
        (f "pavucontrol")
        (f "nm-connection-editor")
        (f "blueberry.py")
        (f "org.gnome.Settings")
        (f "org.gnome.design.Palette")
        (f "Color Picker")
        (f "xdg-desktop-portal")
        (f "xdg-desktop-portal-gnome")
        (f "de.haeckerfelix.Fragments")
        "workspace 7, title:Spotify"
      ];

      windowrulev2 = [
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
      ];

      bind = let
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        mvfocus = binding "SUPER" "movefocus";
        ws = binding "SUPER" "workspace";
        resizeactive = binding "SUPER CTRL" "resizeactive";
        mvactive = binding "SUPER ALT" "moveactive";
        mvtows = binding "SUPER SHIFT" "movetoworkspace";
        arr = [1 2 3 4 5 6 7];
      in
        [
          "SUPER SHIFT, R, exec, pkill waybar; sleep 1; waybar & disown"
          "ALT, SPACE,     exec, walker"
          ",XF86PowerOff,  exec, wleave -p layer-shell"
          ",Print,         exec, ${screenshot}"
          "SHIFT,Print,    exec, ${screenshot} --full"
          "SUPER, Return, exec, kitty" # xterm is a symlink, not actually xterm
          "SUPER, W, exec, xdg-open https://"
          "SUPER, E, exec, kitty lf"
          "SUPER SHIFT, E, exec, dolphin"
          "SUPER, L, exec, hyprlock"

          # youtube
          ", XF86Launch1,  exec, ${yt}"

          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "SUPER, Q, killactive"
          "ALT,   V, togglefloating"
          "Alt+Shift, Return, fullscreen, 0"
          "Alt, Return, fullscreen, 1"
          "SUPER, P, togglesplit"
          "Super, V, exec, /home/loseardes77/.config/dotfiles-nixos/home-manager/scripts/show-clipboard.sh"
          "Super, F, exec, firefox -new-window file:///home/loseardes77/Downloads/empresa-e-iniciativa-emprendedora-2022-libro_compress.pdf &> /dev/null & disown && gnome-calculator &> /dev/null &"

          (mvfocus "up" "u")
          (mvfocus "down" "d")
          (mvfocus "right" "r")
          (mvfocus "left" "l")
          (ws "mouse_down" "e-1")
          (ws "mouse_up" "e+1")
          (mvtows "left" "e-1")
          (mvtows "right" "e+1")
          (resizeactive "k" "0 -20")
          (resizeactive "j" "0 20")
          (resizeactive "l" "20 0")
          (resizeactive "h" "-20 0")
          (mvactive "k" "0 -20")
          (mvactive "j" "0 20")
          (mvactive "l" "20 0")
          (mvactive "h" "-20 0")
        ]
        ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr);

      bindle = [
        ",XF86MonBrightnessUp,   exec, ${swayosd-client} --brightness +5"
        ",XF86MonBrightnessDown, exec, ${swayosd-client} --brightness -5"
        ",XF86AudioRaiseVolume,  exec, ${swayosd-client} --output-volume 5"
        ",XF86AudioLowerVolume,  exec, ${swayosd-client} --output-volume -5"
      ];

      bindl = [
        ",XF86AudioPlay,    exec, ${playerctl} play-pause"
        ",XF86AudioStop,    exec, ${playerctl} pause"
        ",XF86AudioPause,   exec, ${playerctl} pause"
        ",XF86AudioPrev,    exec, ${playerctl} previous"
        ",XF86AudioNext,    exec, ${playerctl} next"
        ",XF86AudioMute,    exec, ${swayosd-client} --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, ${swayosd-client} --input-volume mute-toggle"
        ",switch:on:[Lid Switch],  exec, hyprctl keyword monitor \"eDP-1, disable\""
        ",switch:off:[Lid Switch], exec, hyprctl keyword monitor \"eDP-1, 1920x1080, 0x0, 1\""
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      decoration = {
        rounding = 5;
        dim_inactive = true;
        dim_strength = 0.1;

        shadow = {
          enabled = true;
          range = 8;
          render_power = 3;
          sharp = true;
          color = "rgba(00000044)";
          color_inactive = "rgba(00000088)";
          offset = "5 5";
        };

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      plugin = {
        overview = {
          centerAligned = true;
          hideTopLayers = true;
          hideOverlayLayers = true;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          reverseSwipe = true;
        };
        hyprbars = {
          bar_color = "rgb(2a2a2a)";
          bar_height = 28;
          col_text = "rgba(ffffffdd)";
          bar_text_size = 11;
          bar_text_font = "Ubuntu Nerd Font";

          buttons = {
            button_size = 0;
            "col.maximize" = "rgba(ffffff11)";
            "col.close" = "rgba(ff111133)";
          };
        };
      };
    };
  };
}
