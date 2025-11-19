from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "flask works; updated index;labels;vers check;v check 2;v ch3;v ch4;hi;070"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=7245)
