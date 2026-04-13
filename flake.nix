{
  description = "hello world application using uv2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };

      editableOverlay = workspace.mkEditablePyprojectOverlay {
        root = "$REPO_ROOT";
      };
      pyqt6Overrides = pkgs: final: prev: {
        # https://pypi.org/project/PyQt6-Qt6/
        # https://github.com/nix-community/poetry2nix/blob/1fb01e90771f762655be7e0e805516cd7fa4d58e/overrides/default.nix#L2871
        pyqt6-qt6 = prev.pyqt6-qt6.overrideAttrs (old: {
          autoPatchelfIgnoreMissingDeps = [
            "libmysqlclient.so.21"
            "libmimerapi.so"
            "libfbclient.so.2"
            "libclntsh.so.23.1"
            "libtiff.so.5"
          ];
          propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [
            (pkgs.qt6.env "$qt6-pyqt6-${pkgs.qt6.qtbase.version}" [
              pkgs.qt6.qtbase
              pkgs.qt6.qt3d
              pkgs.qt6.qt5compat
              pkgs.qt6.qtcharts
              pkgs.qt6.qtconnectivity
              pkgs.qt6.qtdatavis3d
              pkgs.qt6.qtdeclarative
              pkgs.qt6.qtdoc
              pkgs.qt6.qtgraphs
              pkgs.qt6.qtgrpc
              pkgs.qt6.qthttpserver
              pkgs.qt6.qtimageformats
              pkgs.qt6.qtlanguageserver
              pkgs.qt6.qtlocation
              pkgs.qt6.qtlottie
              pkgs.qt6.qtmultimedia
              pkgs.qt6.qtmqtt
              pkgs.qt6.qtnetworkauth
              pkgs.qt6.qtpositioning
              pkgs.qt6.qtsensors
              pkgs.qt6.qtserialbus
              pkgs.qt6.qtserialport
              pkgs.qt6.qtshadertools
              pkgs.qt6.qtspeech
              pkgs.qt6.qtquick3d
              pkgs.qt6.qtquick3dphysics
              pkgs.qt6.qtquickeffectmaker
              pkgs.qt6.qtquicktimeline
              pkgs.qt6.qtremoteobjects
              pkgs.qt6.qtsvg
              pkgs.qt6.qtscxml
              pkgs.qt6.qttools
              pkgs.qt6.qttranslations
              pkgs.qt6.qtvirtualkeyboard
              pkgs.qt6.qtwebchannel
              pkgs.qt6.qtwebengine
              pkgs.qt6.qtwebsockets
              pkgs.qt6.qtwebview
              pkgs.libGL
            ])
            pkgs.mesa
            pkgs.libglvnd
            pkgs.libxkbcommon
            pkgs.gtk3
            pkgs.speechd
            pkgs.gst
            pkgs.gst_all_1.gst-plugins-base
            pkgs.gst_all_1.gstreamer
            pkgs.postgresql.lib
            pkgs.unixodbc
            pkgs.pcsclite
            pkgs.libxcb
            pkgs.libxcb-util
            pkgs.libxcb-cursor
            pkgs.libxcb-errors
            pkgs.libxcb-image
            pkgs.libxcb-keysyms
            pkgs.libxcb-render-util
            pkgs.libxcb-wm
            pkgs.libdrm
            pkgs.pulseaudio
          ];
        });

        # https://pypi.org/project/PyQt6/
        pyqt6 = prev.pyqt6.overrideAttrs (old: {
          buildInputs = old.buildInputs or [ ] ++ [
            final.pyqt6-qt6
          ];
        });
      };

      pythonSets = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          python = pkgs.python313;
        in
        (pkgs.callPackage pyproject-nix.build.packages {
          inherit python;
        }).overrideScope
          (
            lib.composeManyExtensions [
              pyproject-build-systems.overlays.wheel
              overlay
              (pyqt6Overrides pkgs)
            ]
          )
      );

    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pythonSet = pythonSets.${system}.overrideScope (
            lib.composeManyExtensions [
              editableOverlay
              pyproject-build-systems.overlays.wheel
              overlay
              (pyqt6Overrides pkgs)
            ]
          );
          virtualenv = pythonSet.mkVirtualEnv "hello-world-dev-env" workspace.deps.all;
        in
        {
          default = pkgs.mkShell {
            packages = [
              virtualenv
              pkgs.uv
            ];
            env = {
              UV_NO_SYNC = "1";
              UV_PYTHON = pythonSet.python.interpreter;
              UV_PYTHON_DOWNLOADS = "never";
            };
            shellHook = ''
              unset PYTHONPATH
              export REPO_ROOT=$(git rev-parse --show-toplevel)
            '';
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pythonSet = pythonSets.${system}.overrideScope (
            lib.composeManyExtensions [
              pyproject-build-systems.overlays.wheel
              overlay
              (pyqt6Overrides pkgs)
            ]
          );
          virtualenv = pythonSet.mkVirtualEnv "hello-world-dev-env" workspace.deps.all;
        in
        {
          default = pkgs.writeShellApplication {
            name = "pyqt-hw-shellapp";
            runtimeInputs = [
              virtualenv
              pkgs.uv
            ];
            # Note: "$@" should pass command-line arguments to your application.
            # It is unused in this demo, but included for completeness.
            text = ''
              exec uv run hello "$@"
            '';
          };
        }
      );

    }; # End: In
} # End: Flake
