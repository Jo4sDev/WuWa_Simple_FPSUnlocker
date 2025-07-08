import os
import platform
import sys

def find_ico_path(filename):
    try:
        base_path = sys._MEIPASS  # Required for PyInstaller
    except Exception:
        base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

    return os.path.join(base_path, filename)

def is_windows():
    return platform.system() == "Windows"