# My Freezed Storage

<!-- put some badge here -->
![Terraform](https://img.shields.io/badge/Terraform-v1.5.0-%237B42BC?logo=terraform)
![Amazon S3](https://img.shields.io/badge/Amazon-S3-%23569A31?logo=amazons3)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/blackcats/my_freezed_storage/terraform.yml?logo=GitHub)
![GitHub issues](https://img.shields.io/github/issues/blackcats/my_freezed_storage?logo=GitHub)
<!-- Put open pullrequest -->

This is my terraform code to create and manage AWS S3 Glacier for [my backup
strategy](https://github.com/blackcats/my-backup-strategy).

<!-- Optional: put a table of content -->

## About the project
This project is a part of [my backup strategy](https://github.com/blackcats/my-backup-strategy).

It manage my external storage for my backup on AWS S3 Bucket with:
- a lifecycle transition from S3 Standard to S3 Glacier to S3 Glacier Deep Archive;
- a server-side encryption with Amazon S3 managed keys

It will also manages the user who has read, write and delete rights on the S3, 
as well as the policies associated with this user.

## Project status
This project is still under development, but is usable as it stands. For more 
information on what fonctionality are coming, take a look to the [Roadmap 
section](#Roadmap).

## Get Started
To use this project you need the following requirement:
- an AWS account with basic knowledge on how to use AWS Cloud;
- associated IAM credentials for the account;
- Terraform version 1.5.0 or higher
- an Terraform Cloud account with basic knowledge on how to use it. 

> [!NOTE]
> It is possible to use the project without a Terraform Cloud account. See 
> below how to use it in this case.

### Setup
First, install Terraform if it is not. The easy way is to use your package
manager (apt for Debian, yum for RedHat like distro...).

Clone this repository:
```
git clone git@github.com:blackcats/my_freezed_storage.git
```

## Usage
As mentioned above, you can use the project with Terraform Cloud or with 
Terraform CLI only.

### Usage with Terraform Cloud
**TODO**
<!-- screenshots ?? -->
This part assumes you already have a Terraform Cloud account, and know how to 
use it. If no, you can quickly learn on it 
[here](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up).

Connect you to your Terraform Cloud account with:
```
$ terraform login
```
and follow the instruction.

Connect to your account to the Terraform Cloud web interface if this is not 
already the case.

Create a credentials variable set for your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
Add the two variables as environement variable and mark then as **Sensitive**.

Now in the _terraform.tf_ file, replace by yours the organization and workspace
names:
```
  ...
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
  }

  cloud {
    organization = "my-organization"

    workspaces {
      name = "My_Freezed_Storage"
    }
  }
  ...
```
Save the changes and run:
```
$ terraform init
```
This command create a new workspace named "My_Freezed_Storage" in the 
organization "my-organization", in the example below.

If you are not using a global variable set with your AWS credentials in your 
Terraform Cloud organization, assign the variable set to your new workspace.
Navigate to your new workspace and select **Variables** in the workspace's 
menu. Under **Variable set**, click **Apply variable set**.
Select your _AWS Credentials_ variable set, and click to **Apply variable set**.

We now need to create two variables the set the AWS region where we going to 
create the AWS S3 bucket and its name.

Return to the Terraform Cloud UI and navigate to the **Variables** page of your 
workspace. Go to the **Workspace variables** part and set the two following 
variables as **Terraform variable**. 
For the first variable, set _Key_ as **region**, and _Value_ with the AWS 
Region of your choice. For the second variable, set _Key_ as **bucket_name**,
and _Value_ with the name you choice for the bucket.


Once this is done, you can now create the infrastructure by running the 
following command:
```
$ terraform apply
```
The command show you the changes that terraform is going to make. If your 
agree, enter **yes** on the command line or click the **Confirm and Apply**
button in the Terraform Cloud UI to launch the deployment..

When done, connect you to your AWS account, and go to the 
AWS S3 section. You will see your new bucket.

### Usage with Terraform CLI
For this usage, you need to set your IAM credentials to authenticate the 
Terraform provider:
```
export AWS_ACCESS_KEY_ID=my_secret_key_id
export AWS_SECRET_ACCESS_KEY=my_secret_access_key
```

In the _terraform.tf_, remove or comment the cloud section in the terraform 
declaration. The following code
```
  ...
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
  }

  cloud {
    organization = "my-organization"

    workspaces {
      name = "My_Freezed_Storage"
    }
  }
  ...
```
becomes
```
  ...
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
  }

#  cloud {
#    organization = "my-organization"
#
#    workspaces {
#      name = "My_Freezed_Storage"
#    }
  }
  ...
```
Now you can run the following command:
```
terraform init
terraform plan -var region="eu-west-1" -var bucket_name="my-big-backup"
terraform apply -var region="eu-west-1" -var bucket_name="my-big-backup"
```
Answer "yes", and wait for the deployment.

When the deployment is complete, you can see in the AWS S3 console a new 
bucket called in this exemple: _my-big-backup_.

## Support
<!-- Tell people where they can go to for help. It can be any combination -->
<!-- of an issue tracker, a chat room, an email address, etc... -->
For help, please open an issue with informations about your problem.

## Roadmap (or Todo)
<!-- Ideas for futur evolution or missing features -->
The following actions are needed:
- [X] Finish the README file, by completed the **TODO** part
- [ ] Create an user to access to the bucket
- [ ] Create the policy for the user
- [ ] Add more test with GitHubActions (tfsec and tflint)

<!-- ## Contributing -->
<!-- How to contribute to the project, Issue, pullrequest... -->
<!-- Necessaire -->
<!-- **TODO**  -->

## Acknowledgment
I would like to thank @geerlingguy for the presentation of [his backup strategy]
(https://github.com/geerlingguy/my-backup-plan). What he says and explains has 
enabled me to review my own backup strategy, and at the same time, to do what
I had been putting off for months: _create terraform and ansible projects for
my needs_, and not just for my work.

## Author
This project was created in 2023 by [Olivier LE GALL](lgo@black-cats.org).

## License
This project is under the GNU GPLv3 license ![License](https://img.shields.io/badge/Licence-GNU_GPLv3-%23A42E2B).
