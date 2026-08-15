{
  description = "PPT Master — Python devShell for the presentation generation workflow";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs:
        let
          # Full python dependency set from skills/ppt-master/requirements.txt
          # plus cairosvg/svglib/reportlab used by the SVG→PPTX exporter.
          pythonEnv = pkgs.python312.withPackages (ps: with ps; [
            # PPTX export / SVG pipeline
            python-pptx
            pillow
            numpy
            skia-pathops
            uharfbuzz
            cairosvg
            svglib
            reportlab
            openpyxl
            xlsxwriter
            # source content conversion
            pymupdf
            mammoth
            markdownify
            ebooklib
            nbconvert
            # networking / scraping / AI image generation
            requests
            beautifulsoup4
            curl-cffi
            google-genai
            # audio narration
            edge-tts
            # confirm UI / live preview server
            flask
          ]);
        in
        {
          default = pkgs.mkShell {
            packages = [ pythonEnv pkgs.direnv ];
            shellHook = ''
              echo "ppt-master devShell ready — $(python3 --version 2>&1)"
            '';
          };
        });
    };
}