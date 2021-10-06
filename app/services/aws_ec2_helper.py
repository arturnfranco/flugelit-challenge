import boto3

class AwsEc2Helper:

    def __init__(self, ec2):
        self.ec2 = ec2 if ec2 else self.ec2
    
    def get_instance_tags(self):
        tags = []
        for instance in self.ec2.instances.all():
            tags.append(instance.tags)
        return tags
    
    def shutdown_server(self):
        instance_id = 'i-0641272ef9bf14a4d'
        instance = self.ec2.Instance(instance_id)
        instance.stop()
        instance.wait_until_stopped()