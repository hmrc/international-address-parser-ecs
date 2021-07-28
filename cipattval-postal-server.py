from postal.expand import expand_address
from postal.parser import parse_address
from flask import Flask
from flask import request

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/expand', methods=["POST"])
def expand():
    address = request.get_json()["address"]
    expanded = expand_address(address)
    return {
        "expanded": expanded
    }, 200


@app.route('/parse', methods=["POST"])
def parse():
    address = request.get_json()["address"]
    parsed = parse_address(address)
    return {
        "parsed": parsed
    }, 200

# Requires a document of the following form:
# {
#   "address": "..."
# }
#
@app.route('/normalize', methods=["POST"])
def normalize():
    address = request.get_json()["address"]
    expanded = expand_address(address)
    parsed = [parse_address(e) for e in expanded][0]
    return {
        "normalized": dict([[e[1], e[0]] for e in parsed])
    }, 200


if __name__ == '__main__':
    app.run
