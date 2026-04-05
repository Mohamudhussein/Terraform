package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWebserverClusterIntegration(t *testing.T) {
	uniqueID := random.UniqueId()
	clusterName := fmt.Sprintf("web-platform-%s", uniqueID)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"cluster_name": clusterName,
			"environment":  "dev",
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	albDnsName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	http_helper.HttpGetWithRetry(
		t,
		url,
		nil,
		200,
		"Hello from the web platform",
		60,
		10*time.Second,
	)

	assert.NotEmpty(t, albDnsName, "ALB DNS name should not be empty")
}