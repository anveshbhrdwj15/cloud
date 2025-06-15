The provided documents have the code to deploy
  1)custom policy <policy.json> that stops resource creation if the tags are not present 
  2)packer template <server.json> using a <packersvars.json> vars file
  3)terraform plan <solution.plan>. This uses <main.tf> and <variables.tf>

  variables are used in Packer and Terraform templates

  variables in Packer
    This has four variables that user has to update before running
      1)Client_id
      2)client_secret
      3)subscription_id
      4)resource_group

  Variables in Terraform
    this has three user variables that users able to define while building
      1) location
      2) custom prefix
      3) vm count - default is 2
      4) subscription_id
      5) Source Image ID from packer
  
Steps to deploy Infrastructure 
1)cd <location where code is>
2) Deploy security policy using below code that uses policy.json
      az policy definition create --name 'Tagging-custom-policy' --display-name 'Tagging Custom Policy for udacity project' --description 'This policy ensures resources meet a custom requirement.' --rules 'policy.json' --mode All
3) Populate packervar.json with appropriate details and Build a packer template using below command.
    packer build -var-file=packervar.json server.json  

    * after command is completed, make note of ManagedImageId from output. It is used and image reference for building vms
    
5) Initialize terraform using below command
  terraform init
6) Export terraform plan
  terraform plan -out solution.plan
7) Apply the plan
  terraform apply
8) as part of project, delete the resources created. This is only to delete resources that was created by plan
  terraform destroy
