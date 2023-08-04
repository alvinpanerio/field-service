from flask import Flask, request
from flask_cors import CORS, cross_origin


from os import environ
import xmlrpc.client


app = Flask(__name__)
cors = CORS(app)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/login", methods=["POST"])
def log_in():
    common = xmlrpc.client.ServerProxy("{}/xmlrpc/2/common".format(environ.get("URL")))

    common.version()

    uid = common.authenticate(
        environ.get("DB"),
        request.json.get("username"),
        request.json.get("password"),
        {},
    )
    print(uid)
    if uid:
        return "<p>Successful</p>"
    else:
        return "<p>not</p>"
