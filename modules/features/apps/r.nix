{ ... }:
{
  flake.modules.homeManager.r =
    { pkgs, ... }:
    let
      packages = with pkgs.rPackages; [
        tidyverse
        plotly
        ggspatial
        prettymapr
      ];
      rEnvironment = pkgs.rWrapper.override { inherit packages; };
      positron = pkgs.symlinkJoin {
        name = "positron-with-r";
        paths = [ pkgs.positron-bin ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ pkgs.R ] ++ packages;
        postBuild = ''
          wrapProgram "$out/bin/positron" \
            --prefix PATH : "${pkgs.R}/bin" \
            --prefix R_LIBS_SITE : "$R_LIBS_SITE" \
            --prefix R_LIBS : "$R_LIBS_SITE"

          rm "$out/share/applications/positron.desktop"
          substitute "${pkgs.positron-bin}/share/applications/positron.desktop" \
            "$out/share/applications/positron.desktop" \
            --replace-fail "${pkgs.positron-bin}/share/positron/.positron-wrapped" "$out/bin/positron"
        '';
        meta = pkgs.positron-bin.meta;
      };
    in
    {
      home.packages = [
        rEnvironment
        positron
      ];
    };
}
