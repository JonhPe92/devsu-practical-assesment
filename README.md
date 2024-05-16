## Terraform Deployment

Several modules are used to deploy the entire infrastructure in Azure. Every mayor resource is modular so we can scale or deploy additional resources in case they are need it. 

### Modules

- **SERVICE PRINCIPAL - Authenticate Terraform with RABC**
- **AZURE AKS CLUSTER**
- **TRAEFIK INGRESS CONTROLLER - External Ingress Load Balancer Type this resource will be the entry point for the app (a public DNS is used to redirect the traffic to the desired hostname (Endpoint) - CloudFare**
- **CERTMANAGER -** Resource to issue TLS certificates, this resource has been proved in a bare metal Kubernetes cluster environment, with Azure there is a problem validating the proper certificate issuer.

To deploy the infrastructure ensure terraform and azure cli are installed in your cmd o pwsh

Run [az login](https://learn.microsoft.com/en-us/cli/azure/account#az-login) without any parameters and follow the instructions to sign in to Azure.

```bash
az login
az account show
az account list --query "[?user.name=='<microsoft_account_email>'].{Name:name, ID:id, Default:isDefault}" --output Table
```

Run the following command to initialize terraform

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

If the deployment is correct the following should be obtained with terraform out

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/91151976-0fb7-4f37-96da-c12be8452312/513a1605-ee23-4df7-9ca1-540eff625288/Untitled.png)

An AKS cluster resource should be provisioned with the necessary configuration to integrate the automatic deployment with the Azure Pipeline.

## Containerization

A docker file is created following best practices, avoiding copying files  that only increase the image size and could cause vulnerabilities , dotenv was removed for production instead env variables  can be passed to the app via ConfigMaps and Secrets. 

 

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/91151976-0fb7-4f37-96da-c12be8452312/8fe7a062-5f04-4953-a9fb-cde170d2bc58/Untitled.png)

For this scenario a Azure Container Register was created to allocate the manifest for every time a build is trigger in the pipeline. 

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/91151976-0fb7-4f37-96da-c12be8452312/17b7f477-cba0-4f17-80ed-7ed061b31875/Untitled.png)

## PIPELINE

The pipeline jobs are executed in Azure Devops tool, this one is trigger by changes in the master branch emulating a production environment.

The pipeline jobs can be viewed in the following url.

[Pipelines - Run 20240516.23 (azure.com)](https://dev.azure.com/jperalta0176/Devsu-Jperalta/_build/results?buildId=23&view=results)

## API TEST CONTAINERIZED APP

The endpoint is using a private DNS CloudFare to redirect the traffic to the Traefik Ingress Controller, this controller has a LoadBalancer Public IP Address assigned. Due to the lack of time the  TLS certificate was not issued using the CERTMANAGER controller installed in the AKS cluster.

### APP ENDPOINT URL : https://devsu-app.ingenial-solutions.com/api/users

### TESTING

Postman was used to verify the endpoint HTTP METHODS

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/91151976-0fb7-4f37-96da-c12be8452312/c34471f1-aa0e-4f5c-af05-6ff3d10dc4ae/Untitled.png)