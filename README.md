
GENERAL INSTRUCTIONS:

- Ensure that CLI access to the AWS account where the infrastructure is going to be built is set up and is in the default location of ~/.aws.  

- For the Web instances create a public/private key pair named "test-infra-web" in AWS console:

- For the Bastion instance create a public/private key pair named "test-infra-bastion" in AWS console:

- Once the infrastructure is created scp the "test-infra-web" key onto ~/.ssh of the bastion instance so that web instances can be accessed via the bastion

- Ensure that the correct breakout IP is input in the parameters.tf file within the "BastionIngressIp" variable

- Once infrastructure is complete the following parameters are output on terminal so they can be used to access resources:
      ALB - use on browser to see Apache test page
      BASTION_Public_ip - use to ssh onto the instances  
