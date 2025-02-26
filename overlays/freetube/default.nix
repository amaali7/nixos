# { channels, ... }:

# final: prev:

# {
#   inherit (channels.unstable) freetube;
# }
{ channels, ... }:

final: prev: {

  #inherit (channels.unstable) freetube;
  final.freetube = prev.freetube // rec {
    version = "0.23.2";

    src = prev.fetchFromGitHub {
      owner = "FreeTubeApp";
      repo = "FreeTube";
      tag = "v${version}-beta";
      hash = "sha256-P0ENx8PDWbqfiBEsWv11R3Q/FE+rAFhhk49VyQgXIz4=";
    };
  };

}
