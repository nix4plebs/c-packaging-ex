{ stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, perl
}:

stdenv.mkDerivation rec {
  pname = "libvfn";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "OpenMPDK";
    repo = "libvfn";
    rev = "c61ad01";
    hash = "sha256-uge5PqQBmZMPwnVersQ7R+xZWPajk7P5GcRxcy+Qltg=";
  };

  patches = [
    ./trace_pl_pathfix.patch
  ];

  mesonFlags = [
    "-Ddocs=disabled"
    "-Dlibnvme=disabled"
    "-Dprofiling=false"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    perl
  ];
}