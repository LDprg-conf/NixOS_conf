{ lib, fishPlugins, fetchFromGitHub }:

fishPlugins.buildFishPlugin rec {
  pname = "fish-abbreviation-tips";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Gazorby";
    repo = "fish-abbreviation-tips";
    rev = "v${version}";
    sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
  };

  meta = with lib; {
    description = "Help you remembering your abbreviations.";
    homepage = "https://github.com/Gazorby/fish-abbreviation-tips";
    license = licenses.mit;
    maintainers = with maintainers; [ ldprg ];
  };
}
