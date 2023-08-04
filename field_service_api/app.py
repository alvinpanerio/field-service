from flask import Flask
import xmlrpc.client


app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
