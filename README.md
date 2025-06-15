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
      2)custom prefix
      3) vm count - default is 2
      4) subscription_id
      5) Source Image ID from packer
  
