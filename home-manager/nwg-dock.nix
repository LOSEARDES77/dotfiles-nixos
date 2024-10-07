{pkgs, ...}: {
  home.packages = with pkgs; [
    nwg-dock-hyprlan
  ];

  home.file."~/.config/nwg-dock-hyprland/style.css" = {
    text = ''
      window {
        background: #171717;
      	border-radius: 10px;
      	border-style: none;
      	border-width: 1px;
      	/*border-color: rgba(156, 142, 122, 0.7)*/
      }

      #box {
        /* Define attributes of the box surrounding icons here */
        padding: 10px
      }

      #active {
      	/* This is to underline the button representing the currently active window */
      	border-bottom: solid 1px;
      	border-color: rgba(255, 255, 255, 0.3)
      }

      button, image {
      	background: none;
      	border-style: none;
      	box-shadow: none;
      	color: #b2b5b3
      }

      button {
      	padding: 4px;
      	margin-left: 4px;
      	margin-right: 4px;
      	color: #b2b5b3;
        font-size: 12px
      }

      button:hover {
      	background-color: rgba(255, 255, 255, 0.15);
      	border-radius: 2px;
      }

      button:focus {
      	box-shadow: none
      }
    '';
  };
}
