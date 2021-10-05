package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsResourcesTagsExample(t *testing.T) {
	nameKey := "Name"
	ownerKey := "Owner"
	expectedNameTagValue := "Flugel"
	expectedOwnerTagValue := "InfraTeam"

	// retryable errors in terraform testing
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	s3BucketTags := terraform.OutputMap(t, terraformOptions, "s3_bucket_tags")

	assert.Equal(t, s3BucketTags[nameKey], expectedNameTagValue)
	assert.Equal(t, s3BucketTags[ownerKey], expectedOwnerTagValue)

	ec2InstanceTags := terraform.OutputMap(t, terraformOptions, "ec2_instance_tags")

	assert.Equal(t, ec2InstanceTags[nameKey], expectedNameTagValue)
	assert.Equal(t, ec2InstanceTags[ownerKey], expectedOwnerTagValue)
}
