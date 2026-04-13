# uv2nix-PyQt6
This repo provides an example of PyQt6 with uv, leveraging uv2nix inside a nix flake.

To create a bundle, execute `bash run-bundle-appimage.sh`. This should create an appimage for your uv application.
This bundle executes our `uv` script target `hello`, which can be found in the `pyproject.toml` file.
All Python dependencies are handled by `uv`, and bundled into our flake with `uv2nix`. Also note that we can include other dependencies (such as other programs available on `Nixpkgs`!) in our package, making them available to our Python code. 

We get the flexibility of Python, the reproducibility of Nix, and access to the entire Nixpkgs catalog. Happy hacking!
