resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "API-Gateway-Example"
  description = "API Gateway para servir contenido estático desde S3"
  tags        = var.tags
}

