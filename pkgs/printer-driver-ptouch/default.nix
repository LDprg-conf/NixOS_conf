{ lib, stdenv, fetchFromGitHub, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "printer-driver-ptouch";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "philpem";
    repo = "printer-driver-ptouch";
    rev = "6d065b94a56927083bbfdf911912fd1d8d1a5a66";
    sha256 = "sha256-3ZotSHn7lERp53hAzx47Ct/k565rEoensCcltwX/Xls=";
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
