package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestFullStackEndToEnd(t *testing.T) {
	uniqueID := random.UniqueId()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"project_name": fmt.Sprintf("platform-%s", uniqueID),
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
}