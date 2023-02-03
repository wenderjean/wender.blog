---
layout: post
title:  "The Monotonic Clock and Why You Should Care About It"
date:   2021-02-15 14:27:02 -0300
categories: clock wall-clock monotonic unix so hanami ruby metrics
---
Recently, while getting into the GitHub woods to make some contributions to the Open Source community, I noticed myself staring at the hanami/hanami repository with my eyes entirely focused on an issue that immediatelly caught my attention. The title of the issue mentioned a new word that I didn't know about, but aroused vast curiosity for me.

I've been developing software for at least ten years now, and I wondered how come I've never heard about monotonic clocks so far? Should I? Does it matter? So, in my defense, I don't think I should know it just because I have a couple of years in the software business. However, I was convinced it should be something that would deserve my attention.

# The intention

The intention here is to briefly clarify the difference between wall-clock (real-time) vs. monotonic-time and how it may affect how we look for the seconds/minutes our routines usually take to start and finish themselves.

It is not exactly a fresh born concept but I am pretty sure it is not a thing we consciously deal with every day.

# The wall-clock and how it may vary

We can think of a **wall-clock** exactly how the name suggests: it's the time we see when we look at a big rounded clock hanging on the wall, or for nerdy guys like us, when we look at the top/bottom panel of our operating system. At first glance, there is no problem with the **wall-clock** time as long as it is adjusted/synchronized, right? So, you should be correct, but when we talk about performance measurement, there is only one thing we want to care about, and I'm not referring to how fast our routine may perform. No, we want to guarantee that the time won't jump back or forward unexpectedly.

The **wall-clock** time cannot give us any guarantee that the time we are getting from it is the right time we are in the universe or, in other words, we are unable to guarantee that the elapsed time we get, for example, from the routine below, won't be influenced by external events:

```ruby
start_time = Time.now
coolest_routine(...)
end_time = Time.now

elapsed = end_time - start_time
```

We know that the **clock-time** of our machine is usually synchronized with an NTP (_Network Time Protocol_) server, sending one or more (depends on the OS you're using) time request packets throughout the day in order to set the correct time on our local machine - which may directly affect our clock at any time, adjusting it back/forward as needed. Do you think such a thing could happen in the middle of my `coolest_routine` method above? It certainly could.

What's another external event that may affect our **clock-time**? One minute for you to think. You're right once again! Whatever other routine is executing a function like `clock_settime` provided by the Linux kernel. You may actually need proper rights to execute functions like that one, but in practice, yeah, it is possible, and it may also happen in the middle of our `coolest_routine`.

So, here's the most interesting one: the planet we're currently living in does not always take the same time to complete a lap around itself. It is actually pretty irregular and, for that reason, from time to time, the UTC clock is adjusted by a second. For example, on December 31th 2016 the UTC clock registered the following seconds:

```
December, 31th 2016, 23:59:59
December, 31th 2016, 23:59:60
January, 1th 2017, 00:00:00
```

You may think it was a long time ago, but trust me: since 1972, the same event happened 27 times, which means the UTC time as we know it has 27 additional seconds now.

# The monotonic-time and how It can save our calculations

I'll define a monotonic function as a subset of constant values. The values are strictly increasing or decreasing, not jumping back/forward. If you're a calculus expert, you may even yell at me and I'll take it, but for the purposes of this article, we can say that a monotonic time is a time where we want to ensure that the difference between the begin and end of a given routine is perfectly measured in a unity that is constantly moving forward tick by tick.

Using our Ruby example again, calculating the elapsed time using the monotonic function will guarantee that regardless of the **wall-clock** events that may happen in the middle of the process, our seconds are moving synchronously forward.

```ruby
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
coolest_routine(...)
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

elapsed_time = end_time - start_time
```

# Conclusions

Back to the `hanami/hanami` repository and the issue that made me spend a few hours to better understand the concept of monotonic time (and therefore also write this post,) it was actually related to the elapsed time calculation of an incoming HTTP request that was inconsistently using both **monotonic** and **wall-clock** times. The begin time was referenced from the monotonic clock and the end time from the wall-clock, so the final measurement was subject to inconsistency.

I could take a moment to link my experience with the importance of constantly contributing to the Open Source community, but it is not the intention here. It is just something that aroused my curiosity and the wish to share the bit of the knowledge I was able to glean from it. The next time you write a benchmark, be mindful of whether you're using monotonic or wallclock time. If you want to be the most precise possible, it'll make a big difference.

See you guys in another opportunity.