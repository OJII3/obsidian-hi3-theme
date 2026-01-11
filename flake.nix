{
  description = "Obsidian theme inspired by Honkai Impact 3rd";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "obsidian-hi3-theme";
            version = "1.1.0";

            src = ./.;

            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp manifest.json theme.css $out/
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Obsidian theme inspired by Honkai Impact 3rd 'Starfall'";
              homepage = "https://github.com/OJII3/obsidian-hi3-theme";
              license = licenses.mit;
              maintainers = [ ];
              platforms = platforms.all;
            };
          };
        }
      );

      overlays.default = final: prev: {
        obsidian-hi3-theme = self.packages.${final.system}.default;
      };
    };
}
