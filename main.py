from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root_route():
    return { "message": "The API is online!" }

@app.get("/tags")
def get_tags():
    return { "result": "Here are the EC2 instance tags." }

@app.put("/shutdown")
def shutdown_server():
    return { "result": "The server is shutting down..." }