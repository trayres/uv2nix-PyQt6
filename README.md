# uv2nix-PyQt6
This repo provides an example of PyQt6 with uv, leveraging uv2nix inside a nix flake.

# TODO
There are two main things to do:
1) Get an AppImage packaging of our script. Provide a basic example of wrapping your Python application, with PyQt6 (later do PySide too), with mkShellApplication, such that everything works and it can be bundled into a AppImage.
2) Provide more complex examples of code to include. For example, what if the user doesn't want their code in 
`__init__.py`? Also the relative path imports can be tricky when packaging for an AppImage, so I want an example of that.
3) Make sure there's an example of using the toAppImage attribute.


