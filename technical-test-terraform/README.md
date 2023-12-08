# technical-test-terraform

## Improvements
- Create a module to encapsulate all resources with an input variable of type
```
type = map(object({
    cost_centre  = string
    product_name = string
    queues       = list(string)
  }))
```
- Use separate root folder for each environment as follows. This would allow for clearer separation of variables and backends if required.
```
/ technical-test-terraform
├── environments
│   ├── test
│   │   ├── provider.tf
│   │   ├── main.tf
│   │   └── .tfvars
│   ├── staging
│   │   ├── provider.tf
│   │   ├── main.tf
│   │   └── .tfvars
│   └── prod
│       ├── provider.tf
│       ├── main.tf
│       └── .tfvars
└── modules
    └── service-bus
        ├── main.tf
        └── variables.tf
```

## Testing
As of version `1.6.0` Terraform provides a testing framework

## Deployment
- GitHub Actions option running the scripts with an AWS S3/Azure Blob Storage backend for maintaining state files.