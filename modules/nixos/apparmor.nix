{ ... }: {
  security.apparmor.enable = true;
  services.dbus.apparmor = "enabled";
}
