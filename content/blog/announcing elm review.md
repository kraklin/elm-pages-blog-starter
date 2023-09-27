---
title: Announcing elm-review
image: /images/announcing-elm-review/order-chaos.jpeg
authors: [jeroen, default]
published: "2019-09-29"
slug: jfmengels-announcing-elm-review
tags: 
  - elm-review
  - elm
---

> Borrowed from [Jeroen's blog](https://jfmengels.net/announcing-elm-review/)

I am happy to announce the release of [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) and its [CLI](https://www.npmjs.com/package/elm-review).

## What is elm-review?

`elm-review` is a tool that analyzes your project's Elm code, and reports patterns that do not comply with a set of "rules".

Let's say that in your Elm project, there is a `Ui.Button` module, so that the project has a consistent UI for your buttons, and a better API for your use case to avoid pitfalls the team has too often fallen into. Also, in order to have a consistent color palette, there is a module named `Ui.Color` which contains all the definitions for the colors in your application.

The problem is that, sometimes these conventions are forgotten or were not well communicated, and problems appear. The native `Html.button` function gets used instead of the `Ui.Button` module, and colors often get redefined where they are used and not imported from `Ui.Color`. Sometimes, these get noticed during code review, but sometimes they don't.

`elm-review` provides you the ability to write rules that make this code review automatic. The result could look something like this:

![](/images/announcing-elm-review/review-cli-output-example.png)

## Get it

The recommended way to get `elm-review` is to install the [CLI](https://www.npmjs.com/package/elm-review), available on `npm`.

```bash
npm install elm-review
```

You can then use it in your terminal as `elm-review`. I suggest starting with running `elm-review --help` and `elm-review init`, which will guide you into using and configuring `elm-review`. I suggest reading at least the section on [when to write or enable a rule](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/#when-to-write-or-enable-a-rule) before you start adding plenty of rules to your project.

You can also try it in an online version [here](https://elm-review.now.sh/), or you can checkout [this repository](https://github.com/jfmengels/elm-review-example) that shows how `elm-review` is configured and used. The screenshot above was taken from this example.

## Custom rules

A lot of static code analysis tools out there (for any language) provide a set of "rules" that you can enable and/or configure, but only some provide the ability to write your own custom rules. Custom rules can be a great tool to forbid things in your project, that are not possible with language constructs, in order to **create more guarantees**.

The button and color examples I have talked about before are not something that makes sense to be forbidden by the compiler, since the problem is too dependent on the project and the way the team works. Also, it is not possible to forbid this using APIs, even by using techniques like opaque or phantom types, because your API can not restrict the use of a data type from a different module.

Review rules are written in Elm. This means that you don't need to learn a different language to be able to write one, and this also means that rules can be published and shared on the Elm package registry. You can go to the package documentation to [learn how to write rules](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule), where you can find a lot of rule examples that might inspire you to write your own to solve problems you have.

Even though `elm-review` can help you with enforcing a given code style, I recommend not using `elm-review` for this purpose. For most of the styling issues, we have [`elm-format`](https://github.com/avh4/elm-format). Also, though a review rule can be a powerful tool, it may not be the best solution to solving your problem, nor the first one to reach for. Other solutions, like API changes, should be considered first. I suggest reading [when to write or enable a rule](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/#when-to-write-or-enable-a-rule) for more on that.

## Helpful compiler-like messages

The errors reported by `elm-review` are meant to be [as helpful as possible](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#what-makes-a-good-rule). They try to explain what the reported problem is, why the pattern is forbidden and how to improve the code so as not to have the problem, like what we are used to with Elm's compiler errors. I don't have full control over the details of the review errors other people will write, but this is what the API and the documentation guide towards.

In the previous example about forbidding the creation of colors outside the `Ui.Color` module, I would detail in the error message why we don't allow colors to be defined elsewhere, and explain the steps on how to fix the problem.

## Automatic fixing

`elm-review` supports [automatic fixes](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Fix). This means that you can write a rule that suggests a solution to the reported problem. When running `elm-review`, it will tell you when an automatic fix is available for the problem. If you run `elm-review --fix`, you will be presented with automatic fixes one by one and you will be able to apply or ignore them.

![](/images/announcing-elm-review/review-fix-output-example.png)

Even though the functionality exists, I think automatic fixes should only be provided in [restricted cases](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Fix#when-not-to-provide-an-automatic-fix-).

## Great testing tools for rules

To help you write great rules, `elm-review` provides a [testing module](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Test) that works with [`elm-test`](https://package.elm-lang.org/packages/elm-explorations/test/latest/) that helps you test them in depth. If you're interested, you can read the [design goals for this module](https://github.com/jfmengels/elm-review/blob/master/documentation/design/test-module.md).

## No built-in rules

Unlike most static code analysis tools, `elm-review` comes with [no rules included](https://github.com/jfmengels/elm-review/blob/master/documentation/design/no-built-in-rules.md). That is because I do not want to suggest that some rules are best practices, and I wish for users to decide what is best for them.

Coming with 0 rules doesn't mean that you need to write them all yourself. Instead, you can find some in the Elm packages, and a good way to find them is by [using `elm-search` and searching for `Review.Rule.Rule`](https://klaftertief.github.io/elm-search/?q=Review.Rule.Rule). I have published a few ones already: [jfmengels/review-unused](https://package.elm-lang.org/packages/jfmengels/review-unused/latest/) to find dead code and remove it, and [jfmengels/review-debug](https://package.elm-lang.org/packages/jfmengels/review-debug/latest/) to find occurrences of `Debug` code.

## What are the differences with elm-analyse?

In the Elm community, we already have a similar tool: [elm-analyse](https://stil4m.github.io/elm-analyse/). The main difference between the two, in my opinion, is the ability to write your own rules. For the rest, there are plenty of differences but in the end they are quite similar.

`elm-analyse` currently has some great features that `elm-review` doesn't (but maybe one day), like a watch mode, better performance (probably), better operating systems support (probably) and is integrated in some editors. `elm-analyse` also has useful features that `elm-review` doesn't aim to have, such as indicating that a new version of a dependency is available or generating a module graph.

On the other hand, `elm-review` has I think a more correct configuration method: the configuration is written in Elm, meaning misconfiguring `elm-review` means it won't compile. In `elm-analyse` the default configuration would be used if the configuration has syntax errors, and the settings are ignored if you make typos or pass unknown fields. The rules are opt-in in `elm-review`, meaning you specify those you wish to enforce, whereas in `elm-analyse` they are opt-out, meaning you specify those you wish to ignore. `elm-review` also has the ability to review other files than those in `source-directories` or `src/`, meaning you can review your test files or even your review configuration.

If you like `elm-analyse`'s rules and don't need any custom rules, I suggest using it. If you need other rules than that, custom rules or ones available on the Elm package registry, maybe try `elm-review`. And nothing prevents you from using both!

## Towards awesome rules

I think that `elm-review` lowers the barrier to entry to the realm of static code analysis, thanks to a great API, and by allowing anyone to use a rule without the maintainer of the tool's consent and effort. I believe that this will, in turn, make people create new useful and awesome rules for everyone to use. Here is a [list of rule ideas](https://github.com/jfmengels/elm-lint/projects/4) that I have. Maybe these will inspire you with great rule ideas.

## Future steps

First of all, I would like to make sure that `elm-review` is working well and as expected, and that people are finding uses for it. I want to make sure that writing rules and testing them all have a great experience.

I also think that `elm-review`'s configuration API will need to change to accommodate exceptions, different rules for different folders (src/ vs tests/ for instance), but this will depend on the pain points that users will give as feedback.

Some of the things I then want to work on include:

- Performance: It has not been too much in my radar. I have done some small performance optimizations, but the biggest improvements, like caching file contents have not been made yet. The goal is mostly to have `elm-review` working on very big projects, in a reasonable time.
- Give more information to rules: I want to be able to load the Elm interface files and pass them to the rules. This way, a rule could be able to tell which package an imported module comes from, tell the type of any function and therefore of any expression.
- Add project-wide rules. At the moment, like a lot of tools, rules only look at a single file at a time, and forget what they have seen when they start analyzing a different file. The idea would be to add the ability for some rules to analyze all the files, and report problems depending on that. One of the goals is for instance to be able to report functions exposed by a module that are used nowhere, like [`elm-xref`](https://github.com/zwilias/elm-xref) does. I am very concerned about the performance implications of this, and have mostly therefore left it for later, but doing this would allow for much more advanced and helpful rules: much better dead code elimination detection, detecting dead internal links in documentation, detecting unused dependencies...

## Feedback appreciated

I hope you will try `elm-review` and enjoy it. I spent a lot of time polishing these projects, but ultimately there are some edges where I need feedback from other users.

If you wish to talk about `elm-review` or send me feedback, hit me up on the Elm Slack (@jfmengels), or open a GitHub issue in the appropriate repository.

Thank you for reading!
