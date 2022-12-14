# Getting Started with Sentinel: Part 3 - Sentinel in the Real-World

In parts 1 and 2 of this series, we covered the basics of Sentinel and how to write a simple policy. In this post, we'll cover how to write a more complex policy and how to use Sentinel to enforce compliance standards in the real world.

If you haven't read parts 1 and 2, I recommend you do so before continuing. You can find them here:

- [Part 1]()
- [Part 2]()

In this post, we'll cover the following:

- Writing a more complex policy
- Using Sentinel to enforce compliance standards

## Scenario: Tagging Enforcement in AWS

Now that we've covered the basics of Sentinel, let's look at a more complex policy. In this example, we'll cover how to enforce tagging policies in AWS. This is a common use case for Sentinel and is a great way to enforce compliance standards. Let's pretend we have a policy that requires all AWS resources to have a `CostCenter` tag. We'll create a policy that will check for this tag and return an error if it's not found.

Using the AWS provider in Terraform, we can create a simple S3 Bucket:

```hcl
# Generate a random string for the bucket name
resource "random_uuid" "uuid" {}

# Create an S3 bucket
resource "aws_s3_bucket" "sentinel-part3" {
  bucket = "${random_uuid.uuid.result}-sentinel-part3"

  tags = {
    "Project"     = "Demo"
    "Environment" = "Development"
    "Department"  = "Engineering"
  }
}

resource "aws_s3_bucket_acl" "sentinel-part3" {
  bucket = aws_s3_bucket.sentinel-part3.id
  acl    = "private"
}
```

In this example, we're creating a random bucket name and adding a few tags, purposefully leaving out the `CostCenter` tag. We're also setting the ACL to `private` to ensure that the bucket is not publicly accessible. We can run `terraform plan` to see what Terraform will do. In the Terraform Cloud (or Enterprise) UI we can see the plan output and for our use case today we can also "Download Sentinel mocks" to get the mock data that we'll use to test our policy.

![Download Sentinel mocks][mocks]

If you Extract the `run-__________-sentinel-mocks.tar.gz` file you'll see a directory structure like this:

```text
├── mock-tfconfig.sentinel
├── mock-tfconfig-v2.sentinel
├── mock-tfplan.sentinel
├── mock-tfplan-v2.sentinel
├── mock-tfrun.sentinel
├── mock-tfstate.sentinel
├── mock-tfstate-v2.sentinel
└── sentinel.hcl
```

Each of these files contains mock data for the different types of data that Sentinel can access. We'll be using the contents of `mock-tfplan-v2.sentinel` for our example today. Much like most things in programming and scripting, there are multiple ways to write a policy. In this example, we'll be using the [`for` loop](https://docs.hashicorp.com/sentinel/language/loops) to iterate over the resources in the plan and check for the `CostCenter` tag. Don't be overwhelmed by the code below, we'll break it down and explain what's going on, and in further posts we'll identify easier ways to achieve the same goal. You can follow along in the [Sentinel Playground](https://play.sentinelproject.io/p/bb4encDTnN_E) or in your own editor.

```go
import "tfplan/v2" as tfplan

aws_s3_buckets = filter tfplan.resource_changes as _, resource_changes {
    resource_changes.type is "aws_s3_bucket" and
        resource_changes.mode is "managed" and
        (resource_changes.change.actions contains "create" or
            resource_changes.change.actions is ["update"])
}

required_tags = ["Project", "Environment", "Department", "CostCenter"]

tags = []
for aws_s3_buckets as _, output {
	for output.change.after.tags as key, _ {
  	append(tags, key)
	}
}

valid = true
for required_tags as required_tag {
	valid = tags contains required_tag
  if !valid { break }
}

# S3 Bucket should have the required tags
main = rule {
	valid
}
```

As we've done previously, let's break this down into its individual components:

- First, we import the `tfplan/v2` module and alias it to `tfplan`. Aliasing modules are optional, but it's a good practice to do so to avoid confusion.
- Next, we create a variable called `aws_s3_buckets` and use the [`filter` Expression](https://docs.hashicorp.com/sentinel/language/collection-operations) to iterate over the resources in the plan and filter out any resources that are of type `aws_s3_bucket` and are in `managed` mode. We also filter to catch resources that are `created` or `updated`.
- Next, we create a variable called `required_tags` and set it to an array of the tags that we require.
- Next, we create a variable called `tags` and set it to an empty array. We then use a [`for` loop](https://docs.hashicorp.com/sentinel/language/loops) to iterate over the `aws_s3_buckets` variable and append the tags to the `tags` variable.
- Next, we create a variable called `valid` and set it to `true`. We then use a `for` loop to iterate over the `required_tags` variable and check if the `tags` variable contains the required tag. If it does not, we set `valid` to `false` and break out of the loop.
- Finally, we create a rule called `main` and if `valid` is `true`, the rule will pass, otherwise, it will fail.

If this is a bit confusing, don't worry. Try to read through it a few times and see if you can understand what's going on. Another idea would be to introduce `print` statements so you can see what's going on in each step. For example, you could add `print(aws_s3_buckets)` after the `aws_s3_buckets` variable and see what's in the variable. You can also add `print(tags)` after the `tags` `for` loop and see what's in the variable. Also if you're not familiar with the `_` or Blank Identifier, you can read more about it [here](https://www.geeksforgeeks.org/what-is-blank-identifierunderscore-in-golang/). Essentially, it's a way to ignore a variable.

Now let's take a look at the mock data and see how it factors into this. If you look at the mock-tfplan-v2.sentinel in the [Sentinel Playground](https://play.sentinelproject.io/p/bb4encDTnN_E) link above you'll see a lot of data generated by Terraform. If you scroll down to the `resource_changes` section you'll see the following:

```json
resource_changes = {
	"aws_s3_bucket.sentinel-part3": {
		"address": "aws_s3_bucket.sentinel-part3",
		"change": {       # <-- output.change
			"actions": [
				"create",
			],
			"after": {      # <-- output.change.after
				"bucket_prefix": null,
				"force_destroy": false,
				"tags": {     # <-- output.change.after.tags
					"Department":  "Engineering",
					"Environment": "Development",
					"Project":     "Demo",
				},
  ...
```

This is the data that we're using to check for the required tags. If you look at the `tags` section you'll see that we're missing the `CostCenter` tag. Looking back at our code you can see how we dig into the tags and append them to the `tags` variable.

```go
tags = []
for aws_s3_buckets as _, output {
	for output.change.after.tags as key, _ {
  	append(tags, key)
	}
}
```

If you run the policy in the [Sentinel Playground](https://play.sentinelproject.io/p/bb4encDTnN_E) you'll see that the policy fails as expected. If you add the `CostCenter` tag to the mock data and run the policy again, you'll see that the policy passes.

## Wrap Up

In this post, we've looked at a more complex example of a Sentinel policy. We've also looked at how to use the Sentinel Playground to test policies. In the next post, we'll look at how to implement a cost management policy using Terraform Cloud and integrate it with a VCS provider (GitHub in our case). Again, if you find yourself overwhelmed, don't worry, in future posts we'll look at some helper functions that will make things easier to implement.

[mocks]: ./assets/part3-mocks.png
