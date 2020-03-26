package main

import (
  "os"
  "fmt"
  "log"
  "strings"
  "context"
  "encoding/json"
  runtime "github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/events"
  "github.com/aws/aws-lambda-go/lambdacontext"
  "github.com/aws/aws-sdk-go/aws/session"
  "github.com/aws/aws-sdk-go/service/lambda"
)

var client = lambda.New(session.New())

func callLambda(){
  // Example sending a request using the GetAccountSettingsRequest method.
  input := &lambda.GetAccountSettingsInput{}
  req, resp := client.GetAccountSettingsRequest(input)

  err := req.Send()
  if err == nil {
      log.Println(resp)
  }
}
func handleRequest(ctx context.Context, event events.SQSEvent) (string, error) {
	// event
	eventJson, _ := json.MarshalIndent(event, "", "  ")
	log.Printf("EVENT: %s", eventJson)
	// environment variables
  log.Printf("REGION: %s", os.Getenv("AWS_REGION"))
  log.Println("ALL ENV VARS:")
  for _, e := range os.Environ() {
    pair := strings.SplitN(e, "=", 2)
    fmt.Println(pair[0])
  }
  
  // request context
  lc, _ := lambdacontext.FromContext(ctx)
  log.Printf("REQUEST ID: %s", lc.AwsRequestID)
  // global variable
  log.Printf("FUNCTION NAME: %s", lambdacontext.FunctionName)
  // context method
  deadline, _ := ctx.Deadline()
  log.Printf("DEADLINE: %s", deadline)
  // AWS SDK call
  callLambda()
  return fmt.Sprint("200 OK"), nil
}

func main() {
  runtime.Start(handleRequest)
}