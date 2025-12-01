#####################################
### Attention!!!
#####################################
# Datadog integration. Datadog is no longer maintaining the CloudFormation stack for Terraform. 
# As a workaround, you can set it up manually on the Datadog console.
# Refer to this doc https://docs.datadoghq.com/getting_started/integrations/aws/

resource "aws_cloudformation_stack" "datadog_integration" {
  name          = "DatadogIntegration"
  # Using a patched main template that references a patched role template (to avoid DatadogPolicy macro requirement).
  template_url  = "https://cf-templates-1tjawajexo35b-us-east-1.s3.amazonaws.com/main_v2-patched.yaml"

  parameters = {
    APIKey                       = var.datadog_api_key
    APPKey                       = var.datadog_application_key
    DatadogSite                  = var.datadog_region
    IAMRoleName                  = var.datadog_iam_role_name
    InstallLambdaLogForwarder    = var.install_lambda_log_forwarder
    DisableMetricCollection      = var.disable_metric_collection
    CloudSecurityPostureManagement = var.cloud_security_posture_management
  }

  # Allow CloudFormation to create IAM resources and run template macros/transforms
  capabilities = [
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_IAM",
    "CAPABILITY_AUTO_EXPAND",
  ]

  lifecycle {
    ignore_changes = [
      parameters["APIKey"],
      parameters["APPKey"]
    ]
  }
}
