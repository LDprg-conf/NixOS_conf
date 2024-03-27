{ lib, stdenv, fetchgit, meson, pkg-config, ninja, xorg, vulkan-headers
, vulkan-loader, wayland-scanner, wayland }:

stdenv.mkDerivation rec {
  pname = "VK_hdr_layer";
  version = "0.0.0";

  src = fetchgit {
    url = "https://github.com/Zamundaaa/VK_hdr_layer.git";
    rev = "f5f13b7ae44135a4d79a60bd4cd4efe7e1534ba6";
    fetchSubmodules = true;
    hash = "sha256-l7L/PadW5h3IIZ95vldHdEd8oHkpA/QB91wwpIgidm8=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];

  buildInputs =
    [ xorg.libX11 vulkan-headers vulkan-loader wayland-scanner wayland ];

  meta = with lib; {
    description = "Vulkan Wayland HDR WSI Layer";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
