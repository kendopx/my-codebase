# Build your own EC2 AMIs with Hashicorp Packer

## **Step 1:** Create the configuration file for Packer

* Create a `json` file for configuring all the parameters

```
$ ls -la | grep ami.json 
```

## Step 2: Export AWS access & secret keys

* Run the below command in your terminal to export the AWS access & secret key

```
export AWS_ACCESS_KEY=<access_key>
expprt AWS_SECRET_ACCESS_KEY=<secret key>

export AWS_ACCESS_KEY=AKIAW6CRG7H4FK6VESVO
expprt AWS_SECRET_ACCESS_KEY=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

```

## Step 3: Add variables section

* Add the below code to `json` file

```
"variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "region": "us-east-2",
    "ssh_username": "ec2-user",
    "base_ami": "ami-0103f211a154d64a6",
    "instance_type": "t2.micro"
  },
```

> Note: You need to change the parameter as per your need & account

## Step 4: Add builder section

* Add the below code to `json` file

```
"builders": [
    {
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key` }}",
      "region": "{{user `region` }}",
      "source_ami": "{{user `base_ami`}}",
      "instance_type": "{{user `instance_type` }}",
      "ssh_username": "{{user `ssh_username`}}",
      "ami_name": "packer-base-{{timestamp}}",
      "associate_public_ip_address": true
    }
  ],
```

* We are going to generate EBS backed machine image, so need to define the type as `amazon-ebs`in the builder section. As we are going to create a single AMI so only one JSON section comes in this. Need to define other parameters needed for backing a new image like source AMI name, access key, secret key, region, etc.

## Step 5: Add the provisioner section

* Once the builder is ready, we need to add a provisioners section for defining what scripts or configuration management need to run.
* Add the below code to `josn` file

```
"provisioners": [
    {
      "type": "shell",
      "inline": [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo systemctl enable docker.service",
      "sudo systemctl start docker.service",
      "sudo yum install -y git",
      "sudo chmod 666 /var/run/docker.sock",
      "docker pull swilliamx/homesite:latest",
      "docker run -d -p 80:80 swilliamx/homesite:latest"
      ]
    }
  ]
```

* The above code will install docker to the AMI and pull the images from the docker hub and run the container from the image.
* The entire file will look like this.

```
{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "region": "us-east-2",
    "ssh_username": "ec2-user",
    "base_ami": "ami-0252149450b2d109d",
    "instance_type": "t2.micro"
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key` }}",
      "region": "{{user `region` }}",
      "source_ami": "{{user `base_ami`}}",
      "instance_type": "{{user `instance_type` }}",
      "ssh_username": "{{user `ssh_username`}}",
      "ami_name": "packer-base-{{timestamp}}",
      "associate_public_ip_address": true
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo systemctl enable docker.service",
      "sudo systemctl start docker.service",
      "sudo yum install -y git",
      "sudo chmod 666 /var/run/docker.sock",
      "docker pull swilliamx/homesite:latest",
      "docker run -d -p 80:80 swilliamx/homesite:latest"
      ]
    }
  ]
}
```

## Step 6: Validate the configuration file

* Run the below command in order to validate the configuration file

```
packer validate <filename>.json 
```

* If the configuration file is valid then you should see the below output

```
The configuration is valid.
```

## **Step 7: Execute the configuration file**

* Next let is build our ami. 

```
packer build <filename>.json
``` 

* We can save the build log to build-artifact.log so we can refer to it in future.

```
packer build -machine-readable <filename>.json | tee build-artifact.log
```

* If something goes wrong during the execution of the provisioner file we get an error message in the end.

```
Build 'amazon-ebs' errored: Script exited with non-zero exit status: 1
```

* If everything works fine then we get the below message.
![image](images/image.png)

## Step 8: Verify the AMI

* Go to AWS and under the AMI section you should see your AMI

## **Step 9: Launch the instance from this AMI (Optional)**

* You can launch the instance from this AMI to check whether what we have done in our AMI is working or not

* Now, if you paste the public IP of that instance into your browser then you should see the below output


### Summary 

### Packer Commands
Packer is similar to Terraform in that executed commands search the current working directory for configuration files and it uses the command plus subcommand format to run. Here are some of the basic commands to get going:

`packer init` - intitializes packer plugins. This is similar to how Terraform intializes the configured providers
`packer validate` - validates packer configuration files. This is similar to Terraform’s validate subcommand and checks for syntax/configuration issues.
`packer build` - kicks off the packer build process. The build command is like running Terraform apply with the -auto-approve flag to bypass the user provided input.

