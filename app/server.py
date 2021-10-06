""" Server module - HTTP service """

import boto3

from fastapi import FastAPI

from app.services.aws_ec2_helper import AwsEc2Helper

app = FastAPI()


@app.get("/")
def root_route():
    """
    Method to get the welcome message of the application
    """
    return { "message": "Welcome! The API is online!" }

@app.get("/tags")
def get_tags():
    """
    Method to get the EC2 instance tags
    """
    
    session = boto3.Session(region_name='us-east-1', profile_name='anf-freetier')
    tags = AwsEc2Helper(session.resource('ec2')).get_instance_tags()

    return { "result": tags }

@app.put("/shutdown")
def shutdown_server():
    """
    Method to shutdown the server (Stop EC2 instance)
    """

    session = boto3.Session(region_name='us-east-1', profile_name='anf-freetier')
    AwsEc2Helper(session.resource('ec2')).shutdown_server()

    return { "result": "The server was shut down..." }
