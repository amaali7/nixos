{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) freetube;
}
# { channels, ... }:

# final: prev: {
#   freetube = prev.freetube // rec{
#     version = "0.23.2";

#     src = fetchFromGitHub {
#       owner = "FreeTubeApp";
#       repo = "FreeTube";
#       tag = "v${version}-beta";
#       hash = "sha256-I3C6gPPSTD/GzCoyyAxTfNEW83etJKJFb3uUKLUT79c=";
#     };
#   };

#   inherit (channels.unstable) freetube;
# }
