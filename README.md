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


![1](https://github.com/JonhPe92/devsu-practical-assesment/assets/106490610/b881d31f-9400-4881-b31b-228534e387ef)


An AKS cluster resource should be provisioned with the necessary configuration to integrate the automatic deployment with the Azure Pipeline.

## Containerization

A docker file is created following best practices, avoiding copying files  that only increase the image size and could cause vulnerabilities , dotenv was removed for production instead env variables  can be passed to the app via ConfigMaps and Secrets. 

 
![2](https://github.com/JonhPe92/devsu-practical-assesment/assets/106490610/c5fdecf4-21e5-401b-b413-a7757cab1cb1)


For this scenario a Azure Container Register was created to allocate the manifest for every time a build is trigger in the pipeline. 

![3](https://github.com/JonhPe92/devsu-practical-assesment/assets/106490610/9262f113-9b53-45e5-8831-b3b12d16799f)


## PIPELINE

The pipeline jobs are executed in Azure Devops tool, this one is trigger by changes in the master branch emulating a production environment.

The pipeline jobs can be viewed in the following url.

[Pipelines - Run 20240516.23 (azure.com)](https://dev.azure.com/jperalta0176/Devsu-Jperalta/_build/results?buildId=23&view=results)

## API TEST CONTAINERIZED APP

The endpoint is using a private DNS CloudFare to redirect the traffic to the Traefik Ingress Controller, this controller has a LoadBalancer Public IP Address assigned. Due to the lack of time the  TLS certificate was not issued using the CERTMANAGER controller installed in the AKS cluster.

### APP ENDPOINT URL : https://devsu-app.ingenial-solutions.com/api/users

### TESTING

Postman was used to verify the endpoint HTTP METHODS
![4](https://github.com/JonhPe92/devsu-practical-assesment/assets/106490610/ea100ada-908b-4568-af61-eaf16dab68fe)
