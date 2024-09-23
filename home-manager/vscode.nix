{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
    ];
  };
  home = {
    file = {
      ".config/zed/settings.json".text = ''
{
  "assistant": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-3-5-sonnet-20240620"
    },
    "version": "2"
  },

  "buffer_font_features": {
    "calt": true
  },
  "ui_font_size": 16,
  "buffer_font_size": 16,
  "git": {
    "git_gutter": "tracked_files",
    "inline_blame": {
      "enabled": true
    }
  },
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "check": {
          "command": "clippy"
        }
      }
    }
  },
  "soft_wrap": "editor_width"
}
      '';
    }
  }
}