{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "gitnow";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "joseluisq";
    repo = "gitnow";
    rev = version;
    sha256 = "";
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description =
      "GitNow contains a command set that provides high-level operations on the top of Git. ";
    homepage = "https://github.com/wfxr/joseluisq";
    license = licenses.mit;
    maintainers = with maintainers; [ ldprg ];
  };
}
