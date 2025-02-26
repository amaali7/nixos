{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) probe-rs-tools;
}
