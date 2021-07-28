from postal.expand import expand_address
from postal.parser import parse_address
from flask import Flask
from flask import request

app = Flask(__name__)


@app.route('/')
def ping():
    return {"ping": "pong"}, 200


@app.route('/normalize', methods=["POST"])
def expand():
    address = request.get_json()["address"]
    expanded = expand_address(address)
    return {
        "normalized": expanded
    }, 200


@app.route('/categorize', methods=["POST"])
def parse():
    address = request.get_json()["address"]
    parsed = parse_address(address)
    return {
        "categorized": dict(swap_tuple_elements(e) for e in parsed)
    }, 200


@app.route('/normalize-and-categorize', methods=["POST"])
def normalize():
    address = request.get_json()["address"]
    expanded = expand_address(address)
    parsed_list = [parse_address(e) for e in expanded]
    parsed = [dict([swap_tuple_elements(e) for e in l]) for l in parsed_list]
    return {
        "categorized-and-normalized": parsed
    }, 200


def swap_tuple_elements(t):
    return [t[1], t[0]]


if __name__ == '__main__':
    app.run()
