{ ... }:

{
  networking.dns = [
    "1.1.1.1" # Cloudflare DNS
    "8.8.8.8" # Google DNS
  ];

  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Ethernet Slot 2"
    "Thunderbolt Bridge"
  ];
}
