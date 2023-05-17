---
layout: post
title:  "The reasons behind the “why”"
date:   2023-05-17 08:00:00 -0300
categories: career software engineering product ruby
---

As a consultant and senior engineer in my current role, part of my everyday job is dealing with less experienced developers, mentoring and helping them grow their careers. One piece of advice I often repeat is the importance of the "why" behind every decision we make as engineers.

I realized the significance of this perspective a long time ago when I read the “Design Patterns: Elements of Reusable Object-Oriented Software” book. At that time, I attempted to apply many of the patterns described by the gang of four in the features I was working on. However, I was struggling a lot with the issue of applying wrong patterns or even correct ones, but prematurely. This experience sparked a realization that I was not exactly sure about what I was doing and, instead, I was trying to repeat patterns in my code where they were not a good fit.

# Just because something works doesn't mean it is a good solution

A common situation I’ve been facing in the last years is related to the solution of one-off problems that are not fit in the context you’re dealing with at that moment. For example, sometimes you may find yourself solving a specific issue in automatic mode: you perform a quick search, copy a piece of code you found and paste it into your code. It probably works, your test is now green, or your code checker is now happy, but do you know what you left behind?

Let me give you a clear example. Recently, I started a Rails project from scratch with one of my mentees, and we decided to set up Rubocop in our project (a spread-used code analyzer). The task was to set up the code analyzer and make it happy.

The task was successful. He added a code analyzer step to our CI, and it was happy but, reviewing the solution as a whole, I found this piece of code:

```
AllCops:
  Excludes:
    ...

Style/FrozenStringLiteralComment:
  Enabled: false
```

The reason for `Style/FrozenStringLiteralComment` being disabled is that Rubocop was claiming about the absence of `# frozen_string_literal: true` at the top of the Ruby files in the project, and this was the solution my mentee found to fix the CI pipeline. You will probably agree with me that the piece of code above made the code analyzer happy, right? But, when you start to make questions about the “why” this piece of code solves the problem, you’ll find yourself in front of a powerful set of knowledge you left behind. For instance, these two lines of code lead me to a mentoring session discussing points like:

1. Memory allocation
2. Mutability
3. What is a String literal?
4. What happens when we call #freeze in a Ruby object?

This mentoring session, along with some other scenarios I found myself in, is probably what motivated me to write this post. The point is that asking yourself the “why” behind something you’re doing is a valuable tool to push yourself and dive deeper into the core concepts of the language and/or tool you’re dealing with. It increases the potential to elevate your career to another level.

The example I illustrated above is just one of many situations you may find yourself in, with someone asking why you’re adding a piece of code or even changing something in a given way.

> Try to ask yourself why you're making a specific decision.

# The “why” beyond the career levels

There is a discussion that never ends related to what makes a person a mid or senior engineer and, no, I don’t want to get into this kind of bike-shedding conversation here. This section aims to clarify that, as you progress in your career, it doesn’t mean you will do fewer questions about things you’re doing. In fact, you may ask more.

I strongly believe that the role of a senior engineer goes beyond the code they’re doing. It requires much more commitment to other tasks like being involved in product decisions, being a mentor to other engineers in your team, and, in a nutshell, a clue person in the sector/company you’re working on.

Recently I was reading an excellent article from [Gergely Orosz](https://blog.pragmaticengineer.com/the-product-minded-engineer/) published in 2019 discussing what a product-minded engineer is, and a specific point that took my attention was a quote from [Jean-Michel Lemieux](https://twitter.com/jmwind):

> Once you have the product foundations, you need devs who engage with the 'why', actively.

What caught my attention is the part that says that being a clue person in the sector, company, and/or product you're working on involves understanding the underlying reasons why things work the way they do. As you progress in your career and address some of the technical debt typically accumulated from the beginning, you will begin to ask different questions. For example:

1. What are the company's goals for this specific product decision?
2. How does this specific change I'm working on affects the end user?
3. What are the trade-offs beyond the technical aspects?

Maybe you will ask yourself if you really need to dive deep into the business aspects of your everyday job, and my answer will always be “yes”. You have the potential to make a huge difference in the product by bringing to the table your technical knowledge along with a solid vision of the product itself.

> Be critical to brainstorm product decisions.

# Conclusions

In conclusion, as you go on in your career, you will encounter two major gaps to address. The first gap is the technical topics you should learn and become familiar with, especially in the beginning. The second gap is to become more than just a programmer. As a senior and/or specialist, you’ll engage with your manager, teammates, the product team, and even the customers. It's important to criticize decisions you disagree with and bring your opinions to debate, with the confidence of knowing the "Why" behind those decisions.
