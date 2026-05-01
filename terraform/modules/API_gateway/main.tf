resource "aws_apigatewayv2_api" "api" {
  name          = var.api_name
  protocol_type = "HTTP"
  ip_address_type = "ipv4"
}

resource "aws_apigatewayv2_integration" "integration_form" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.integration_uri_form
  integration_method = "POST"
  description = "Integración para la página de formulario"
}

resource "aws_apigatewayv2_integration" "integration_support" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.integration_uri_support
  integration_method = "GET"
  description = "Integración para la página de soporte"
}

resource "aws_apigatewayv2_route" "route_form" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /submit-form"
  target    = "integrations/${aws_apigatewayv2_integration.integration_form.id}"
}

resource "aws_apigatewayv2_route" "route_support" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /support"
  target    = "integrations/${aws_apigatewayv2_integration.integration_support.id}"
}