{ lib, stdenv, fetchFromGithub, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "printer-driver-ptouch";
  version = "1.7";

  src = fetchFromGithub {
    owner = "philpem";
    repo = "printer-driver-ptouch";
    rev = "6d065b94a56927083bbfdf911912fd1d8d1a5a66";
    sha256 = "";
  };

  nativeBuildInputs = [ autoconf automake ];

  meta = with lib; {
    description =
      "Makes applications run faster by prefetching binaries and shared objects";
    homepage = "https://github.com/philpem/printer-driver-ptouch";
    license = licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
