from flask import Flask, request
from flask_cors import CORS, cross_origin

import xmlrpc.client


app = Flask(__name__)
cors = CORS(app)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/login", methods=["POST"])
def log_in():
    url = "https://sample-awb.odoo.com"

    common = xmlrpc.client.ServerProxy("{}/xmlrpc/2/common".format(url))

    common.version()

    uid = common.authenticate(
        "sample-awb", request.json.get("username"), request.json.get("password"), {}
    )
    if uid:
        return "<p>Successful</p>"
    else:
        return "<p>not</p>"
