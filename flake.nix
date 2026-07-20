{
  description = "teigi_app development toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
      flutterVersion = "3.41.8";
      flutterReleases = {
        aarch64-darwin = {
          url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${flutterVersion}-stable.zip";
          sha256 = "1ypha2f1xcv5hhbf8zmnazbaazmf8gcn0w07k6wp7wcnb8dcc7x9";
        };
        x86_64-linux = {
          url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${flutterVersion}-stable.tar.xz";
          sha256 = "1izic61kldcw8drg526dia3m0fsbib5qibixdkih9x3q8vxi2nz5";
        };
      };
      # Flutter 3.41.8 regenerates the aggregate iOS plugin package with an
      # iOS 13 minimum even when the Runner target and Firebase require iOS 15.
      # Rebuild the Flutter tool snapshot with repository-owned patches, including
      # SDK-specific iOS native asset output directories.
      flutterToolchainRevision = "${flutterVersion}-teigiii-ios15-native-assets-v6";
      mkTools =
        pkgs:
        let
          release =
            flutterReleases.${pkgs.stdenv.hostPlatform.system}
              or (throw "Unsupported system for Flutter ${flutterVersion}: ${pkgs.stdenv.hostPlatform.system}");
          flutterSrc = pkgs.fetchzip release;
          mkFlutterWrapper = name: executable: pkgs.writeShellApplication {
            inherit name;
            # rsync を runtimeInputs に入れると exec 先の flutter → xcodebuild にも
            # PATH が継承され、exportArchive が起動する rsync server が GNU 版に
            # 化けて `--extended-attributes` 非対応で "Copy failed" になる。
            # rsync は PATH 注入せず絶対パスで呼ぶ。
            runtimeInputs = [
              pkgs.coreutils
              pkgs.git
              pkgs.patch
            ];
            text = ''
              repo_root="$PWD"
              maybe_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
              if [ -n "$maybe_root" ]; then
                repo_root="$maybe_root"
              fi

              flutter_root="''${FLUTTER_ROOT:-$repo_root/.nix/flutter/${flutterVersion}}"
              stamp="$flutter_root/.nix-flutter-version"
              if [ ! -x "$flutter_root/bin/${executable}" ] || [ ! -f "$stamp" ] || [ "$(cat "$stamp")" != "${flutterToolchainRevision}" ]; then
                tmp="$flutter_root.tmp"
                rm -rf "$tmp"
                mkdir -p "$(dirname "$tmp")"
                ${pkgs.rsync}/bin/rsync -a --delete "${flutterSrc}/" "$tmp/"
                chmod -R u+w "$tmp"
                patch -d "$tmp" -p1 < ${./nix/patches/flutter-ios-15.patch}
                patch -d "$tmp" -p1 < ${./nix/patches/flutter-ios-native-assets.patch}
                rm -f "$tmp/bin/cache/flutter_tools.snapshot" "$tmp/bin/cache/flutter_tools.stamp"
                printf '%s\n' "${flutterToolchainRevision}" > "$tmp/.nix-flutter-version"
                rm -rf "$flutter_root"
                mv "$tmp" "$flutter_root"
              fi

              export FLUTTER_ROOT="$flutter_root"
              export PUB_CACHE="''${PUB_CACHE:-$repo_root/.nix/pub-cache}"
              mkdir -p "$PUB_CACHE"
              exec "$flutter_root/bin/${executable}" "$@"
            '';
          };
          flutterTool = mkFlutterWrapper "flutter" "flutter";
          dartTool = mkFlutterWrapper "dart" "dart";
          toolPackages = [
            flutterTool
            dartTool
            pkgs.just
            pkgs.lcov
            pkgs.git
            pkgs.bun
            pkgs.curl
            pkgs.jq
            pkgs.ripgrep
            pkgs.openapi-generator-cli
          ] ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.cocoapods ];
        in
        {
          inherit flutterTool dartTool toolPackages;
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          tools = mkTools pkgs;
        in
        {
          flutter = tools.flutterTool;
          dart = tools.dartTool;
          default = tools.flutterTool;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          tools = mkTools pkgs;
        in
        {
          default = pkgs.mkShellNoCC {
            packages = tools.toolPackages;
            shellHook = ''
              export PUB_CACHE="''${PUB_CACHE:-$PWD/.nix/pub-cache}"
              ${lib.optionalString pkgs.stdenv.isDarwin ''
                unset SDKROOT
                unset NIX_CFLAGS_COMPILE
                unset NIX_LDFLAGS
                if command -v xcrun >/dev/null 2>&1; then
                  export CC="$(xcrun --find clang)"
                  export CXX="$(xcrun --find clang++)"
                fi
              ''}
              echo "[nix] teigi_app dev shell ready (Flutter ${flutterVersion}, just, lcov${lib.optionalString pkgs.stdenv.isDarwin ", CocoaPods"})"
              echo "[nix] Run tasks with: just <task>"
            '';
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.flutter}/bin/flutter";
        };
        flutter = {
          type = "app";
          program = "${self.packages.${system}.flutter}/bin/flutter";
        };
        dart = {
          type = "app";
          program = "${self.packages.${system}.dart}/bin/dart";
        };
      });
    };
}
