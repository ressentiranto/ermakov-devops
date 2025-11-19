from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "flask works; updated index;labels;vers check"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=7245)
