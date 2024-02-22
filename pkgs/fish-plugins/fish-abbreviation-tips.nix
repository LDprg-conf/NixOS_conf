{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "fish-abbreviation-tips";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Gazorby";
    repo = "fish-abbreviation-tips";
    rev = "v${version}";
    sha256 = "";
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description = "Help you remembering your abbreviations.";
    homepage = "https://github.com/Gazorby/fish-abbreviation-tips";
    license = licenses.mit;
    maintainers = with maintainers; [ ldprg ];
  };
}
