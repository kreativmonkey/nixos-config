{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "lychee";
  version = "4.3.4";

  src = fetchurl {
    url = "https://github.com/LycheeOrg/Lychee/releases/download/v${version}/Lychee.zip";
    sha256 = "sha256-6f51e8239bc38cba0ae8f0759b7eb4c87a09009cab07b3694f4666f7411b0f8d";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R * $out/
  '';

  meta = with lib; {
    homepage = "https://lycheeorg.github.io";
    description = "Lychee is a free photo-management tool, which runs on your server or web-space.";
    longDescription = ''
        Lychee is a free photo-management tool, which runs on your server or web-space.
        Installing is a matter of seconds. Upload, manage and share photos like from a native application. 
        Lychee comes with everything you need and all your photos are stored securely.
    '';
    license = [ licenses.mit ];
    maintainers = [ maintainers.kreativmonkey ];
    platforms = platforms.all;
  };
}