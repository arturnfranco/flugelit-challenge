""" EC2Helper module """

class EC2Helper:
    """
    Class to handle/access EC2 info
    """

    def __init__(self, ec2):
        self.ec2 = ec2

    def get_instance_tags(self, instance_id):
        """
        Method to get the tags of the EC2 instance with id equals to instance_id
        """
        tags = self.ec2.Instance(instance_id).tags

        tags_dict = {}
        for tag in tags:
            tags_dict[tag["Key"]] = tag["Value"]

        return tags_dict

    def shutdown_server(self, instance_id):
        """
        Method to shutdown/stop the EC2 instance with id equals to instance_id
        """
        self.ec2.Instance(instance_id).stop()
