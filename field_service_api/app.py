from flask import Flask, request, session, jsonify
from flask_cors import CORS


from flask_session import Session


from os import environ
import xmlrpc.client


app = Flask(__name__)


app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
app.config["SECRET_KEY"] = environ.get("SESSION_SECRET")


ses = Session(app)
CORS(app, supports_credentials=True)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/login", methods=["POST"])
def log_in():
    common = xmlrpc.client.ServerProxy("{}/xmlrpc/2/common".format(environ.get("URL")))

    common.version()

    uid = common.authenticate(
        environ.get("DB"),
        request.json.get("email"),
        request.json.get("password"),
        {},
    )

    if uid:
        session["uid"] = uid
        session["email"] = request.json.get("email")
        session["password"] = request.json.get("password")

        models = xmlrpc.client.ServerProxy(
            "{}/xmlrpc/2/object".format(environ.get("URL"))
        )

        name = models.execute_kw(
            environ.get("DB"),
            session["uid"],
            request.json.get("password"),
            "res.users",
            "search_read",
            [[["id", "=", session["uid"]]]],
            {
                "fields": [
                    "name",
                ]
            },
        )

        services = models.execute_kw(
            environ.get("DB"),
            session["uid"],
            request.json.get("password"),
            "project.task",
            "search_read",
            [],
            {
                "fields": [
                    "name",
                    "project_id",
                    "user_ids",
                ]
            },
        )

        response = {"name": name[0]["name"], "services": services}

        return jsonify(response)
    else:
        return "<p>not</p>"


@app.route("/all-tasks", methods=["GET"])
def get_all_tasks():
    if "uid" in session:
        models = xmlrpc.client.ServerProxy(
            "{}/xmlrpc/2/object".format(environ.get("URL"))
        )

        services = models.execute_kw(
            environ.get("DB"),
            session["uid"],
            session["password"],
            "project.task",
            "search_read",
            [],
            {
                "fields": [
                    "name",
                    "project_id",
                    "user_ids",
                ]
            },
        )

        response = {"services": services}

        return jsonify(response)
    else:
        return "asd"


@app.route("/my-tasks", methods=["GET"])
def get_my_tasks():
    if "uid" in session:
        models = xmlrpc.client.ServerProxy(
            "{}/xmlrpc/2/object".format(environ.get("URL"))
        )

        services = models.execute_kw(
            environ.get("DB"),
            session["uid"],
            session["password"],
            "project.task",
            "search_read",
            [[["user_ids", "=", session["uid"]]]],
            {
                "fields": [
                    "name",
                    "project_id",
                    "user_ids",
                ]
            },
        )

        response = {"services": services}
        return jsonify(response)
    else:
        return "asd"


if __name__ == "__main__":
    app.run(debug=True)
