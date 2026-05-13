from flask import Flask, Response
from prometheus_client import Counter, generate_latest

app = Flask(__name__)

REQUEST_COUNT = Counter("cloud_lab_requests_total", "Total requests to Cloud Lab app")

@app.route("/")
def hello():
    REQUEST_COUNT.inc()
    return "Cloud Lab CI/CD is working!"

@app.route("/health")
def health():
    REQUEST_COUNT.inc()
    return {"status": "healthy"}

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
