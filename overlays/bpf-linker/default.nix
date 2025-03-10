{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) bpf-linker;
}
