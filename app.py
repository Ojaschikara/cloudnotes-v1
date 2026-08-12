from flask import Flask, render_template, request, redirect, url_for, send_from_directory
from api.routes import api_bp
from utils.helpers import init_db
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, "uploads")
DATABASE_URL = os.environ.get("DATABASE_URL")

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["DATABASE_URL"] = DATABASE_URL
app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY", "dev-key")
app.config["MAX_CONTENT_LENGTH"] = 5 * 1024 * 1024
app.register_blueprint(api_bp, url_prefix="/api")

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
with app.app_context():
    init_db(DATABASE_URL)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/notes")
def notes_page():
    return render_template("notes.html")

@app.route("/uploads/<path:filename>")
def uploaded_file(filename):
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename)

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=5000)
