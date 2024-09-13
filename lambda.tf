# // build the binary for the lambda function in a specified path
resource "null_resource" "function_binary" {
  provisioner "local-exec" {
    working_dir = "./lambda/hello-world"
    command = "GOOS=linux GOARCH=amd64 go build -o bootstrap"
  }
}

// zip the binary, as we can upload only zip files to AWS lambda
data "archive_file" "function_archive" {
  depends_on = [null_resource.function_binary]

  type        = "zip"
  source_file = "./lambda/hello-world/bootstrap"
  output_path = "./lambda/hello-world/bootstrap.zip"
}

// create the lambda function from zip file
resource "aws_lambda_function" "function" {
  function_name = "hello-world"
  description   = "My first hello world function"
  role          = aws_iam_role.lambda.arn
  handler       = "bootstrap"
  memory_size   = 128

  filename         = "./lambda/hello-world/bootstrap.zip"
  source_code_hash = data.archive_file.function_archive.output_base64sha256

  // skip timeout
  runtime = "provided.al2"
  // skip tags

  // skip environment variables

}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 7
}
