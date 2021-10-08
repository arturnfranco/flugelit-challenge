""" Server module - HTTP service """

import os
import boto3
import uvicorn

from fastapi import FastAPI
from dotenv import load_dotenv

from services.aws_ec2_helper import EC2Helper

load_dotenv()

aws_session = boto3.Session(
    aws_access_key_id=os.environ["AWS_ACCESS_KEY"],
    aws_secret_access_key=os.environ["AWS_SECRET_KEY"],
    region_name=os.environ["AWS_REGION"]
)

app = FastAPI()


@app.get("/")
def root_route():
    """
    Method to get the welcome message of the application
    """
    return { "message": "Welcome! The API is online!" }

@app.get("/tags/{instance_id}")
def get_tags(instance_id: str):
    """
    Method to get the EC2 instance tags
    """

    ec2 = aws_session.resource("ec2")
    tags = EC2Helper(ec2).get_instance_tags(instance_id)

    return { "tags": tags }

@app.put("/shutdown/{instance_id}")
def shutdown_server(instance_id: str):
    """
    Method to shutdown the server (Stop EC2 instance)
    """

    ec2 = aws_session.resource("ec2")
    EC2Helper(ec2).shutdown_server(instance_id)

    return { "message": "The server is shutting down... You can check in AWS EC2 console." }

if __name__ == "__main__":
    uvicorn.run("server:app", host="0.0.0.0", port=8000, log_level="info")