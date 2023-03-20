{ stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, python310Packages
, libuuid
, libtool
, nasm
, zlib
, liburing
, libaio
, libvfn
}:

stdenv.mkDerivation rec {
  pname = "xnvme";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "OpenMPDK";
    repo = "xNVMe";
    rev = "v${version}";
    hash = "sha256-0NiAmpDshsfGAeeU2Ed9d17y1s+XENrXkwKQKVh/UEE="; # how to get
  };

  patches = [
    ./rm-bundle.patch
    ./use-sys-libvfn.patch
  ];

  mesonFlags = [
    "-Dwith-fio=false"
    "-Dwith-spdk=false"
  ];

  nativeBuildInputs = [
    libvfn
    meson
    ninja
    pkg-config
    python310Packages.pyelftools
  ];

  buildInputs = [
    libuuid
    libtool
    nasm
    zlib
    liburing
    libaio
    libvfn
  ];
}
