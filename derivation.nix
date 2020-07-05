{ stdenv, lib, darwin, nodejs, python3, ... }:
stdenv.mkDerivation rec {
  name = "franz-${version}";
  version = "5.5.0";

  src = ./. ;
  buildInputs = [
    nodejs
    python3
  ] ++ lib.lists.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    Foundation
    ApplicationServices
  ]);

  enableParallelBuilding = true;
  releaseName = name;

  buildPhase = ''
    mkdir -p $TMP/build-support/bin
    export PATH=$TMP/build-support/bin:$PATH
    ln -s /usr/bin/hdiutil $TMP/build-support/bin/hdiutil
    ln -s /usr/bin/sips $TMP/build-support/bin/sips

    export HOME=$TMP/home
    npx lerna bootstrap
    npm run build
  '';

  installPhase = ''

  '';

  meta = with stdenv.lib; {
    description = "Messaging app for WhatsApp, Slack, Telegram, HipChat, Hangouts and many many more.";
    homepage = https://github.com/meetfranz/franz;
    license = licenses.asl20;
    platforms = platforms.darwin;
    maintainers = [ "maxim.schuwalow@gmail.com" ];
  };
}
