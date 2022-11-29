# Getting Started with Sentinel: Part 1 - Introduction to Sentinel

## What is Sentinel

> Sentinel is an embeddable policy as code framework to enable fine-grained,
> logic-based policy decisions that can be extended to source external
> information to make decisions.
> -- [HashiCorp Sentinel Marketing Page](https://www.hashicorp.com/sentinel)

That's marketing-speak for "Sentinel is a tool, like Terraform, that enables you to write policies as code to put guardrails on your environment." That's Sentinel in its simplest form.

Like you (hopefully) write Infrastructure as Code (IAC) to deploy your infrastructure today, Policy as Code ensures that the infrastructure you're deploying meets your organization's needs via, you guessed it, policies! With Policy as Code, you write policies to enforce compliance standards, cost management policies, and organizational best practices such as tagging and standardized naming conventions.

This blog post will familiarize you with how Sentinel operates, how to write simple policies, construct readable and reusable code, and construct a VCS repository that can support multiple teams and projects.

## About The Author

My name is Aaron Lake, and I'm a Terraform Architect Specialist at HashiCorp. Before joining HashiCorp, I spent the previous two and half years building a software startup that specializes in compliance and security in the cloud. Our product would perform a routine sweep of a customer's AWS & Azure environments for compliance misconfigurations, abandoned infrastructure, and general "scary things." During deployments and product evaluations at large and small companies, I've seen countless compliance violations, misconfigurations, and underutilized or abandoned infrastructure that mostly went unnoticed. HashiCorp, and Sentinel, in particular, were of great interest to me because it enables customers to "fix" these issues before they even occur.

## Why Policy as Code?

Let's focus on the last sentence from the previous section, "before they even occur." Some Policy as Code tools, Sentinel included, can be executed as a _preventative_ tool, and that's key! Infrastructure as Code lets you build resources, Policy as Code enables you to protect resources. That is the value proposition of Sentinel and tools like it. If you've heard of Cloud, you've heard of Cloud breaches. If you've managed Cloud or are responsible for Cloud budget, you're likely aware of the oft-unpredictable cost of Cloud. If you've worked in technology, you're likely aware that standards and best practices, if they exist in the first place, aren't always followed.

Policy as Code, and thereby Sentinel, address these common issues. Side note: the same applies to on-premise infrastructure and service in the [Terraform Registry](https://registry.terraform.io/browse/providers) and other HashiCorp services like Vault, Consul and Nomad.

How about an example?

Let's pretend you have a Terraform module that enables your developers to deploy an Amazon S3 Bucket to AWS. You've configured that module to deploy an S3 bucket that follows your organization's best practices: non-public, encrypted, and appropriate ACLs. What if that developer opts _not_ to use the module you've carefully constructed and deploys an S3 bucket on their own without encryption or with public access enabled? Well, precisely that, it gets deployed! We now have a small, potentially severe gap in our security. With a Sentinel policy attached to this user's Workspace that enforces the best practices, the user will get a notification that the S3 bucket does not meet best practices and will have to manually acknowledge the violation or fix the issue, depending on how you configured this policy.

Creating Terraform modules that meet governance standards are a great way to ensure that your consumers, whether that be other members of your team or another team, can do their job without contemplating the compliance or security ramifications. Sentinel is a catch-all standard that can be applied to a whole Terraform Cloud/Enterprise Organization or specific Workspaces.

> **_NOTE:_** Sentinel is available for Terraform Enterprise, Terraform Cloud as part of the Team & Governance package, Vault Enterprise Plus, Consul Enterprise and Nomad Enterprise customers only.

## Why Sentinel

We've covered why Policy as Code, but what about Sentinel specifically? Sentinel was designed to be an easy-to-learn language to be adopted by security and compliance teams and doesn't require a seasoned developer to write policies. Though easy it still maintains the benefits of a full-fledged programming language, including the ability to import external data sources, and the ability to write reusable modules.

As described by the [Sentinel Policy as Code Benefits](https://docs.hashicorp.com/sentinel/concepts/policy-as-code) Sentinel Policies are _just code_ and can easily be integrated with CI systems, version control systems, and other tools. This enables you to write policies that are reusable, reviewable, readable, and testable.

Much like the public HashiCorp Registry for Terraform modules, Sentinel has a public Registry that enables you to share your policies with the community. This is a great way to share best practices and policies that you've written for your organization. This is also a great way to learn from the community and see how others have solved similar problems.

## Wrap Up

That wraps up Part 1 of this series. In Part 2, we'll cover the basics of Sentinel syntax and how to write a simple policy.
