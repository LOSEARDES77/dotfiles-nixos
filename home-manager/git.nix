let
  name = "LOSEARDES77";
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
    };
    userEmail = "loseardes77@gmail.com";
    userName = name;
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = "
Host losecloud
  HostName 143.47.56.219
  User ubuntu
  IdentityFile ~/.ssh/losecloud.key
  Port 22
";
  };


  services.ssh-agent.enable = true;
}
