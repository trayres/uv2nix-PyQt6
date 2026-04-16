def hello():
    from PyQt6.QtWidgets import QApplication, QWidget
    import subprocess

    # Only needed for access to command line arguments
    import sys

    # You need one (and only one) QApplication instance per application.
    # Pass in sys.argv to allow command line arguments for your app.
    # If you know you won't use command line arguments QApplication([]) works too.
    app = QApplication(sys.argv)

    # Create a Qt widget, which will be our window.
    window = QWidget()
    window.show()  # IMPORTANT!!!!! Windows are hidden by default.
    result = subprocess.run(["hello"], capture_output=True, text=True)
    print(result.stdout)
    # Start the event loop.
    app.exec()


if __name__=="__main__":
    hello()
