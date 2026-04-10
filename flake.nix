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
            "libQt6RemoteObjects.so.6"
            "libQt6MultimediaWidgets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SerialPort.so.6"
            "libQt6Positioning.so.6"
            "libQt6StateMachine.so.6"
            "libQt6Nfc.so.6"
            "libQt6Bluetooth.so.6"
            "libQt6Pdf.so.6"
            "libQt6PdfWidgets.so.6"
            "libQt6Pdf.so.6"
            "libQt6WebChannel.so.6"
            "libQt6Help.so.6"
            "libQt6TextToSpeech.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SpatialAudio.so.6"
            "libQt6Multimedia.so.6"
            "libQt6WebSockets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6Quick3D.so.6"
            "libQt6Quick3DRuntimeRender.so.6"
            "libQt6Quick3DUtils.so.6"
            "libQt6ShaderTools.so.6"
            "libQt6Quick3DParticleEffects.so.6"
            "libQt6Scxml.so.6"
            "libQt6WebEngineQuick.so.6"
            "libQt6WebEngineCore.so.6"
            "libQt6WebViewQuick.so.6"
            "libQt6WebView.so.6"
            "libQt6RemoteObjects.so.6"
            "libQt6MultimediaWidgets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SerialPort.so.6"
            "libQt6Positioning.so.6"
            "libQt6StateMachine.so.6"
            "libQt6Nfc.so.6"
            "libQt6Bluetooth.so.6"
            "libQt6Pdf.so.6"
            "libQt6PdfWidgets.so.6"
            "libQt6Pdf.so.6"
            "libQt6WebChannel.so.6"
            "libQt6Help.so.6"
            "libQt6TextToSpeech.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SpatialAudio.so.6"
            "libQt6Multimedia.so.6"
            "libQt6WebSockets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6Quick3D.so.6"
            "libQt6Quick3DRuntimeRender.so.6"
            "libQt6Quick3DUtils.so.6"
            "libQt6RemoteObjects.so.6"
            "libQt6MultimediaWidgets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SerialPort.so.6"
            "libQt6Positioning.so.6"
            "libQt6StateMachine.so.6"
            "libQt6Nfc.so.6"
            "libQt6Bluetooth.so.6"
            "libQt6Pdf.so.6"
            "libQt6PdfWidgets.so.6"
            "libQt6Pdf.so.6"
            "libQt6WebChannel.so.6"
            "libQt6Help.so.6"
            "libQt6TextToSpeech.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SpatialAudio.so.6"
            "libQt6Multimedia.so.6"
            "libQt6WebSockets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6Quick3D.so.6"
            "libQt6Quick3DRuntimeRender.so.6"
            "libQt6Quick3DUtils.so.6"
            "libQt6ShaderTools.so.6"
            "libQt6RemoteObjects.so.6"
            "libQt6MultimediaWidgets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SerialPort.so.6"
            "libQt6Positioning.so.6"
            "libQt6StateMachine.so.6"
            "libQt6Nfc.so.6"
            "libQt6Bluetooth.so.6"
            "libQt6Pdf.so.6"
            "libQt6PdfWidgets.so.6"
            "libQt6Pdf.so.6"
            "libQt6WebChannel.so.6"
            "libQt6Help.so.6"
            "libQt6TextToSpeech.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SpatialAudio.so.6"
            "libQt6Multimedia.so.6"
            "libQt6WebSockets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6Quick3D.so.6"
            "libQt6Quick3DRuntimeRender.so.6"
            "libQt6Quick3DUtils.so.6"
            "libQt6ShaderTools.so.6"
            "libQt6RemoteObjects.so.6"
            "libQt6MultimediaWidgets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SerialPort.so.6"
            "libQt6Positioning.so.6"
            "libQt6StateMachine.so.6"
            "libQt6Nfc.so.6"
            "libQt6Bluetooth.so.6"
            "libQt6Pdf.so.6"
            "libQt6PdfWidgets.so.6"
            "libQt6Pdf.so.6"
            "libQt6WebChannel.so.6"
            "libQt6Help.so.6"
            "libQt6TextToSpeech.so.6"
            "libQt6Multimedia.so.6"
            "libQt6SpatialAudio.so.6"
            "libQt6Multimedia.so.6"
            "libQt6WebSockets.so.6"
            "libQt6Multimedia.so.6"
            "libQt6Quick3D.so.6"
            "libQt6Quick3DRuntimeRender.so.6"
            "libQt6Quick3DUtils.so.6"
            "libQt6ShaderTools.so.6"
          ];
          propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [
            (pkgs.qt6.env "$qt6-pyqt6-${pkgs.qt6.qtbase.version}" [
              pkgs.qt6.qtbase
              pkgs.qt6.qt3d
              pkgs.qt6.qt5compat
            ])
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
          python = pkgs.python3;
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
          pythonSet = pythonSets.${system}.overrideScope editableOverlay;
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

      packages = forAllSystems (system: {
        default = pythonSets.${system}.mkVirtualEnv "hello-world-env" workspace.deps.default;
      });
    };
}
