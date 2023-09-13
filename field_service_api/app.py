from flask import Flask, make_response, request, session, jsonify
from flask_cors import CORS


from flask_session import Session


from os import environ
import xmlrpc.client


app = Flask(__name__)


app.config["SESSION_PERMANENT"] = True
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
    else:
        return "Unauthorized!", 401

    isAuth()

    return jsonify({"message": "Already log in!"}), 200


@app.route("/name", methods=["GET"])
def get_name():
    isAuth()

    name = query(
        session["uid"],
        session["password"],
        "res.users",
        "search_read",
        [[["id", "=", session["uid"]]]],
        ["name"],
    )

    response = {"name": name[0]["name"]}

    return jsonify(response), 200


@app.route("/all-tasks", methods=["GET"])
def get_all_tasks():
    isAuth()

    response = {
        "services": query(
            session["uid"],
            session["password"],
            "project.task",
            "search_read",
            [],
            [
                "name",
                "partner_id",
                "project_id",
                "user_ids",
                "stage_id",
                "date_assign",
                "date_deadline",
            ],
        )
    }

    ids = {}

    for task in response["services"]:
        for id in task["user_ids"]:
            if id not in ids:
                ids[id] = ""

    for value, id in enumerate(ids):
        picture = query(
            session["uid"],
            session["password"],
            "res.partner",
            "search_read",
            [[["user_ids", "=", id]]],
            [
                "avatar_128",
            ],
        )
        ids[id] = picture

    for task in response["services"]:
        for value, id in enumerate(task["user_ids"]):
            print(ids[id])
            task["user_ids"][value] = ids[id]

    return jsonify(response), 200


@app.route("/my-tasks", methods=["GET"])
def get_my_tasks():
    isAuth()

    response = {
        "services": query(
            session["uid"],
            session["password"],
            "project.task",
            "search_read",
            [[["user_ids", "=", session["uid"]]]],
            [
                "name",
                "partner_id",
                "project_id",
                "user_ids",
                "stage_id",
                "date_assign",
                "date_deadline",
            ],
        )
    }

    return jsonify(response), 200


@app.route("/task", methods=["GET"])
def get_task():
    isAuth()

    id = int(request.args["id"])

    response = {
        "task": query(
            session["uid"],
            session["password"],
            "project.task",
            "search_read",
            [[["id", "=", id]]],
            [
                "project_id",
                "user_ids",
                "display_name",
                "partner_id",
                "partner_phone",
                "sale_line_id",
                "planned_date_begin",
                "tag_ids",
            ],
        ),
    }

    return jsonify(response), 200


@app.route("/worksheet", methods=["GET"])
def get_worksheet():
    isAuth()

    id = int(request.args["id"])

    response = {
        "worksheet": query(
            session["uid"],
            session["password"],
            "x_project_task_worksheet_template_2",
            "search_read",
            [[["x_project_task_id", "=", id]]],
            [
                "x_name",
                "x_project_task_id",
                "x_manufacturer",
                "x_model",
                "x_serial_number",
                "x_intervention_type",
                "x_description",
                "x_checkbox",
                "x_date",
                "x_worker_signature",
                "x_studio_pictures",
            ],
        ),
    }

    if response["worksheet"]:
        for value, i in enumerate(response["worksheet"][0]["x_studio_pictures"]):
            datas = query(
                session["uid"],
                session["password"],
                "ir.attachment",
                "search_read",
                [[["id", "=", i]]],
                ["datas"],
            )

            response["worksheet"][0]["x_studio_pictures"][value] = datas[0]["datas"]

    return jsonify(response), 200


@app.route("/update-worksheet", methods=["POST"])
def set_worksheet():
    isAuth()

    id = int(request.args["id"])
    print(id)

    pictures = request.json.get("pictures")
    updatedPictures = []
    num = 0

    for i in pictures:
        num += 1
        imageId = create(
            session["uid"],
            session["password"],
            "ir.attachment",
            [
                {
                    "name": f"{request.json.get('name')}-{num}",
                    "type": "binary",
                    "res_name": request.json.get("name"),
                    "datas": i,
                    "res_model": "x_project_task_worksheet_template_2",
                    "res_id": id,
                },
            ],
        )

        updatedPictures.append(imageId)

    response = update(
        session["uid"],
        session["password"],
        "x_project_task_worksheet_template_2",
        [
            [id],
            {
                "x_name": request.json.get("name"),
                "x_manufacturer": request.json.get("manufacturer")[0],
                "x_model": request.json.get("model")[0],
                "x_serial_number": request.json.get("serial_no"),
                "x_intervention_type": request.json.get("intervention_type"),
                "x_description": request.json.get("description"),
                "x_checkbox": request.json.get("is_checked"),
                "x_date": request.json.get("date"),
                "x_worker_signature": request.json.get("signature"),
                "x_studio_pictures": updatedPictures,
            },
        ],
    )

    return jsonify(response), 200


@app.route("/create-worksheet", methods=["POST"])
def create_worksheet():
    isAuth()

    id = int(request.args["id"])

    worksheetId = create(
        session["uid"],
        session["password"],
        "x_project_task_worksheet_template_2",
        [
            {
                "x_name": request.json.get("name"),
                "x_project_task_id": id,
                "x_manufacturer": request.json.get("manufacturer")[0],
                "x_model": request.json.get("model")[0],
                "x_serial_number": request.json.get("serial_no"),
                "x_intervention_type": request.json.get("intervention_type"),
                "x_description": request.json.get("description"),
                "x_checkbox": request.json.get("is_checked"),
                "x_date": request.json.get("date"),
                "x_worker_signature": request.json.get("signature"),
                "x_studio_pictures": [],
            }
        ],
    )

    pictures = request.json.get("pictures")
    updatedPictures = []
    num = 0

    for i in pictures:
        num += 1
        imageId = create(
            session["uid"],
            session["password"],
            "ir.attachment",
            [
                {
                    "name": f"{request.json.get('name')}-{num}",
                    "type": "binary",
                    "res_name": request.json.get("name"),
                    "datas": i,
                    "res_model": "x_project_task_worksheet_template_2",
                    "res_id": worksheetId,
                },
            ],
        )

        updatedPictures.append(imageId)

    response = update(
        session["uid"],
        session["password"],
        "x_project_task_worksheet_template_2",
        [
            [worksheetId],
            {
                "x_studio_pictures": updatedPictures,
            },
        ],
    )

    return jsonify(response), 200


@app.route("/models", methods=["GET"])
def get_models():
    isAuth()

    partners = query(
        session["uid"],
        session["password"],
        "res.partner",
        "search_read",
        [],
        ["commercial_partner_id"],
    )

    products = query(
        session["uid"],
        session["password"],
        "product.product",
        "search_read",
        [],
        ["product_variant_id"],
    )

    response = {
        "models": [{
            "partners": partners,
            "products": products,
        }]
    }

    return jsonify(response), 200


def query(uid, password, model, method, condition, fields):
    models = xmlrpc.client.ServerProxy(
        "{}/xmlrpc/2/object".format(
            environ.get("URL"),
        ),
    )
    return models.execute_kw(
        environ.get("DB"),
        uid,
        password,
        model,
        method,
        condition,
        {"fields": fields},
    )


def create(uid, password, model, fields):
    models = xmlrpc.client.ServerProxy(
        "{}/xmlrpc/2/object".format(
            environ.get("URL"),
        ),
    )

    return models.execute_kw(
        environ.get("DB"),
        uid,
        password,
        model,
        "create",
        fields,
    )


def update(uid, password, model, fields):
    models = xmlrpc.client.ServerProxy(
        "{}/xmlrpc/2/object".format(
            environ.get("URL"),
        ),
    )

    return models.execute_kw(
        environ.get("DB"),
        uid,
        password,
        model,
        "write",
        fields,
    )


def isAuth():
    if "uid" and "email" and "password" in session:
        return
    return "Not Authenticated!", 400


if __name__ == "__main__":
    app.run(debug=True)
