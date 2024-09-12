{
  services.openssh = {
    enabled = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["loseardes77"];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
