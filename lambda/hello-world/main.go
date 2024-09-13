package main

import (
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

func handler() {
	// Print "Hello, World" to the Lambda logs
	log.Println("Hello, World")

	
}

func main() {
	lambda.Start(handler)
}