{ ... }:
{
  imports = [
    # device specific hardware configuration
    ./hardware-configuration.nix


    # device specific hardware configuration
    ./users/sebastian.nix
    ./machines/pegasus.nix
    #./machines/anarchy.nix
    #./machines/bulido.nix
  ];

  # Set your time zone.
  time.timeZone = "Europa/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
}