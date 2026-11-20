import os
import sys
from PyQt6.QtGui import QGuiApplication, QIcon
from PyQt6.QtQml import QQmlApplicationEngine

# Must be set BEFORE QGuiApplication is instantiated
os.environ["QTWEBENGINE_CHROMIUM_FLAGS"] = "--enable-smooth-scrolling --enable-gpu-rasterization"

app = QGuiApplication(sys.argv)
app.setWindowIcon(QIcon("./icons/gmail.png"))
engine = QQmlApplicationEngine()
engine.load("main.qml")
sys.exit(app.exec())
