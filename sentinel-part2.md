# Getting Started with Sentinel: Part 2 - Sentinel Syntax

In part 1 of this series, we covered the "why" of Sentinel. In this post, we'll cover the "how" of Sentinel. We'll cover the basics of Sentinel syntax and how to write a simple policy. If you haven't read part 1, I recommend you do so before continuing. You can find it here:

- [Part 1]()

## The Basics

Let's look at a simple example of a Sentinel policy from HashiCorp's [Policy Language Documentation](https://docs.hashicorp.com/sentinel/concepts/language):

```go
import "time"

# Validate time is between 8 AM and 4 PM
valid_time = rule { time.now.hour >= 8 and time.now.hour < 16 }

# Validate day is M - Th
valid_day = rule {
	time.now.weekday_name in ["Monday", "Tuesday", "Wednesday", "Thursday"]
}

main = rule { valid_time and valid_day }
```

This policy is checking that the current time is between 8 AM and 4 PM on a Monday through Thursday. If the time is valid, the policy will return `true`. If the time is invalid, the policy will return `false`. Let's break down the code line by line:

- `import "time"` - This line is importing the [time module](https://docs.hashicorp.com/sentinel/imports/time/). This module allows us to use the `time` library in our policy. The `time` namespace contains a variety of functions that can be used to interact with time in our policies. Sentinel has a variety of [imports](https://docs.hashicorp.com/sentinel/imports/) that can be used to construct policies.
- `valid_time = rule { time.now.hour >= 8 and time.now.hour < 16 }` - This line is creating a new rule named `valid_time`. The `rule` keyword is used to define a new rule. The rule's name is `valid_time`. The rule's body is a set of expressions that are used to determine whether the rule should return `true` or `false`. In this case, the rule is returning `true` if the current hour is greater than or equal to 8 and less than 16. If the current hour is not greater than or equal to 8 or less than 16, the rule will return `false`.
- `valid_day = rule { time.now.weekday_name in ["Monday", "Tuesday", "Wednesday", "Thursday"] }` - This line is creating a new rule named `valid_day`. The rule's body is a set of expressions that are used to determine whether the rule should return `true` or `false`. In this case, the rule is returning `true` if the current day is Monday, Tuesday, Wednesday, or Thursday. If the current day is not Monday, Tuesday, Wednesday, or Thursday, the rule will return `false`.
- `main = rule { valid_time and valid_day }` - This line is creating a new rule named `main`. The rule's body is a set of expressions that are used to determine whether the rule should return `true` or `false`. In this case, the rule is returning `true` if both `valid_time` and `valid_day` are `true`. If either `valid_time` or `valid_day` is `false`, the rule will return `false`.
- The comments in the policy are denoted by `#` or `//`. Comments are used to provide additional information about the policy. Comments are displayed in the Sentinel output as descriptions when the policy is run and can provide additional context about the policy.

HashiCorp has a cool utility that can assist with building and testing Sentinel policies called the [Sentinel Playground](https://play.sentinelproject.io), we'll make extensive use of it during this series. Let's test this policy yourself in the [Sentinel Playground](https://play.sentinelproject.io/p/2zL3-KF16zh) (this link has the code already entered), and change the time and or date to see how the policy responds. Depending on the time and date, the policy should return `true` or `false`. In a real-world scenario if the policy returns `false`, depending on your [Enforcement Levels](https://docs.hashicorp.com/sentinel/concepts/enforcement-levels) the user may be prevented from deploying the resource(s).

## Sentinel Mocks

Sentinel mocks are used to test policies as `imports` without having to connect to a live environment. Let's use [another example](https://play.sentinelproject.io/p/c-DVNzeORVG) from HashiCorp's documentation on [Imports](https://docs.hashicorp.com/sentinel/concepts/imports).

```go
import "calendar"
// Get the calendar for Bob for today
bob_calendar = calendar.of("bob").today

// Allow this policy to pass if Bob is not on vacation.
main = rule { not bob_calendar.has_event("vacation") }
```

In the [Sentinel Playground link](https://play.sentinelproject.io/p/c-DVNzeORVG) you can see that the `import "calendar"` line references the `mock-calendar.sentinel` file that contains the following:

```go
has_event = func(event) {
	return true
}
of = func(name) {
	return { "today": { "has_event": has_event } }
}
```

Again, let's break down the code line by line:

- `import "calendar"` - This line is importing the `calendar` mock data. In this case, the `calendar` namespace is mocked by the `mock-calendar.sentinel` file.
- `bob_calendar = calendar.of("bob").today` - This line is creating a new variable named `bob_calendar` which is set to the `today` property of the `of` function, which in turn calls the `has_event` function, which returns `true`.
- `main = rule { not bob_calendar.has_event("vacation") }` - This line is creating a new rule named `main`. In this case, the rule is returning `true` if `bob_calendar.has_event("vacation")` is `false` (note the `not` in the rule).
- As with the previous example, note the comments which provide additional context for the user executing the policy.

If you run the policy in the Sentinel Playground you can see that indeed the policy fails because `has_event` returns `true`. If you want to deny Bob his PTO, you can change the `has_event` function to return `false` and the policy will pass. Bob won't mind.

## Wrap Up

In this section, we've gone over the basics of Sentinel's syntax and how to write a basic policy. We've also gone over how to use Sentinel mocks to test policies without having to connect to a live environment. In the next section, we'll go over how to write a policy that checks for a specific tag on a resource. We'll also be going over how to use `import "tfplan"` to use some real-world data in our policy.
