# Kong Terraform

This uses [Terraform](http://terraform.io) to create an AWS environment for [Kong](http://getkong.org).  As of this original posting it's definitely not done but getting close enough that it's hopefully something for others to start from, reference or work on as a community.  

## Instructions

```
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
terraform plan
terraform apply
```

## Naming Conventions

- All the names within this configuration should be lowercase and underscore delimited (eg `allow_access_from_bastion` or `proxy_elb`).
- The resources running the Kong software are referred to as **proxy** to (hopefully) alleviate confusion from what is **Kong** (the entire package of all of these resources) and what are the resources doing the actual proxying work.
- Security groups do not have a `name` tag but instead just use the Group Name attribute.
- The `name_prefix` variable will be prepended to the name of all resources created **without a space** so if you want `Kong: elb` for the load balancer then your `name_prefix` should be set to `Kong: ` with a trailing space.

## Tagging Conventions

### `Name` tag
From what I can tell having a `Name` tag (capital N) is pretty normal for AWS setups. Everything else I have in here has a lowercase tag name but this seems to be common enough I left it as capitalized.

### `environment` tag
All resources (at least the ones that support tagging at this time) will include an `environment` tag for things such as `qa`, `ci`, `stage`, `test` or `production`.

### `stack_name` tag
This is a tag intended to be used to group together multiple `environment` setups and to indicate they are all of the same stack definition.  Could be used as a versioning system as well if that's something you would need.

## Assumptions

#### Cassandra Security Group

The AWS CloudFormation configuration that I referenced to set this up had a security group setup for the Cassandra instances that opened up basically every port and several of them were actually indicated multiple times.  This configuration tries to be the bare minimum and only open these:
- 9042: Kong communication
- 9160: Cassandra internal communication

## Creator's Note

I'm quite new to Terraform, AWS and Kong so this is combining a lot of new things for me.  Please let me know if there is a best practice I should be following that I'm not but please also be nice about it.