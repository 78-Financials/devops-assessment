# DevOps Practical Exercise - AWS

## Primary Task

Create a very simple REST API that when its endpoint is called, it returns one object from S3 that is a JSON file. For example GET `/api/foo` returns contents of JSON file with something like `{ "greeting": "I am the Foo" }`. But really do whatever you want there as long as it accesses S3 to get the content. You can create this in any development language with any framework, or you can use a sample app from somewhere online (note your source if you do so). If you need help with this, let us know. Keep this simple, its a 10-20 line app at most.

- Use infrastructure as code (i.e. Terraform)
- You may use containers or instances for the application backend, or make a case for other options
- Deploy the backend to a private network (VPC)
- Create your own S3 bucket
- Expose the service through a termination on publicly accessible network

Bonus task (optional)

- Make the service autoscale

Please commit all work to _THIS_ repository, using normal practices for working in a team. If you use pull requests, please merge them yourself and we will still be able to see the history.

## General Note

Beyond the functional requirements, your submission will be judged primarily based on adherence to best practices, so use the same professional-quality code and commitment to automation that you would deliver on a real client project. If you need to take any shortcuts to fit the work in the time allowed, please document these as future work items to demonstrate that you made an explicit tactical decision to deviate from your normal best practices.
# devops-assessment
