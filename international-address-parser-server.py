from postal.expand import expand_address
from postal.parser import parse_address
from flask import Flask
from flask import request
from waitress import serve


app = Flask(__name__)


@app.route('/')
def ping():
    return {"ping": "pong"}, 200


@app.route('/normalize', methods=["POST"])
def normalize():
    address = request.get_json()["address"]
    expanded = expand_address(address)
    return {
        "normalized": expanded
    }, 200


@app.route('/categorize', methods=["POST"])
def categorize():
    address = request.get_json()["address"]
    parsed = parse_address(address)
    return {
        "categorized": dict(swap_tuple_elements(e) for e in parsed)
    }, 200


@app.route('/normalize-and-categorize', methods=["POST"])
def normalize_and_categorize():
    address = request.get_json()["address"]
    expanded = expand_address(address)
    parsed_list = [parse_address(e) for e in expanded]
    parsed = [dict([swap_tuple_elements(e) for e in l]) for l in parsed_list]
    return {
        "normalized-and-categorized": parsed
    }, 200


def swap_tuple_elements(t):
    return [t[1], t[0]]


if __name__ == '__main__':
    # app.run()
    serve(app, host='0.0.0.0', port=5000)
