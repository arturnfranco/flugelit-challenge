class EC2Helper:

    def __init__(self, ec2):
        self.ec2 = ec2
    
    def get_instance_tags(self, instance_id):
        tags = self.ec2.Instance(instance_id).tags
        
        tags_dict = {}
        for tag in tags:
            tags_dict[tag["Key"]] = tag["Value"]
        
        return tags_dict
    
    def shutdown_server(self, instance_id):
        self.ec2.Instance(instance_id).stop()