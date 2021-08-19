{pkgs, config, ...}:

{
  # Setup the right timezone
  time.timeZone = "Europa/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
}