---
layout: post
title:  "Pattern Matching in Ruby - Don't be afraid"
date:   2023-04-07 12:30:00 -0300
categories: clock wall-clock monotonic unix so hanami ruby metrics
---
{% youtube X6sSrh3urrw %}

<sub>_This post is a transcript with some tweaks (to tailor content to a text version) from the talk I presented for Codeminer's brown bag session on April 7th, 2023._</sub>

# Pattern Matching

Pattern Matching is a feature introduced by Ruby 2.7 that allows deep matching structured values. It'll check the structure of a given value and bind the matched parts into local variables. It might be a String, Number or, even a Class.

Basically, we can do two different things with pattern matching in Ruby. We can test values against some pattern and extract local variables from it.

# How we can do that?

We’re gonna find two different ways of using pattern matching in Ruby.

We can use the keyword “in” to match some pattern “in” a given expression and receive a true/false value as the return of this action or, the second way, use the operator `=>`. If you are, like me, an ancient Rubyist you’re gonna probably recall we used to call this operator the “hash rocket” operator in the old times of Ruby 1.9. The difference between the “in” keyword and this operator is basically that in this version you’ll receive a success or, if the pattern doesn’t match, Ruby is gonna raise an Error.

For example:
```ruby
expression in pattern # true/false
expression => pattern # success or raises
```

<sub>_It is important to say that the "hash rocket" version does not exist in version 2.7 and instead, the "in" pattern, behaves exactly like the `=>` operator behaves in Ruby 3, raising an exception._</sub>

For the purpose of this article, you guys can assume that from here on, in all examples I present, you could use both the “in” or the “equals/greater than” operator.

# Example #1

Let’s take a look at the example below. In our first example, we are doing a standalone validation using the “in” keyword to match our entire hash against the “id:” pattern and it basically means: - “Hey, if my hash has a key called id this pattern matches and you can print true otherwise prints false”.

The second example is similar but we are using `=>` to match our hash against a pattern that includes id, name, and age. At this time we’re gonna receive an error due to the fact that our hash does not contain a key called “age”.
```ruby
h = { id: 1, name: 'John Doe' }

if(h in { id: })
  puts 'true'
else
  puts 'false'
end
# prints true

h => { id:, name:, age: }
# raises key not found: :age (NoMatchingPatternKeyError)

``` 

# Most common use case

Even though we can use pattern matching to make standalone validations or even raise some error if a value doesn’t correspond to a given pattern, very common use of pattern matching in Ruby is to take some complex decisions using **“case/in”** statement that’s very similar to **“case/when”** with the difference that using the “in” keyword we’re telling Ruby to use pattern matching and, by doing that we’re assuming the same behaviors we described in our previous examples, receiving a `true/false` or raising a `NoMatchingPatternError`.

A huge difference that is worth mentioning here is that, different than “case/when”, the “case/in” is exhaustive. What is that mean? So, in a “case/when”, if you don’t have an “else” clause you’re program won’t fail but using “case/in” if your program exhausts all statements without a match and, you equally don’t have an “else” clause, a **NoMatchingPatternError** is gonna be raised.

# The different patterns we can match against

So, to define the difference between every pattern we can match against when dealing with pattern-matching in Ruby the core team describes them in those six bullet points below:

1. Value Pattern
2. Array Pattern
3. Find Pattern
4. Hash Pattern
5. Alternative pattern
6. Variable Pattern

We already had contact with a couple of them in our previous examples but, let’s elaborate better on each one.

#### Value Pattern

The value pattern is what we have when we’re matching some value into a given pattern exactly like we get when we're using the triple-equals operator “===”. I won’t dig into the whole set of features behind the triple-equals operator here but have in mind that it performs equality for different types of objects behaving differently depending on that type. A short example could be using a range, in ruby, if you compare a range with a value using the triple-equals operator it will be using the “includes?” method to verify if the given value is within this range. Another short example is, if you're comparing with a class it will be using the “is_a?”.

The value pattern in pattern-matching is gonna use the same principle.

```ruby
irb(main):002:0> (1..9) === 4
=> true

irb(main):014:0> String === 'Wender Freese'
=> true

irb(main):008:0> 2 in (1..9)
=> true

irb(main):001:0> 'Wender Freese' in String
=> true
```

#### Array Pattern

The array pattern is a little bit different because we’re gonna use this pattern to match the items of a given array. By default, we can only match the entire array unless we’re using the rest operator as we’re gonna see in our examples.

```ruby
irb(main):008:0> [41, 42] in [41, 42]
true

irb(main):008:0> [41, 42] in [41]
false

irb(main):008:0> [41, 42, 43] in [41, *]
true

irb(main):008:0> [41, 'ruby'] in [Integer, String]
true
```

<sub>_The **rest** operator is a way to say you don't care about the rest of the items beyond the one you're matching against._</sub>

#### Find Pattern

The find pattern is still an experimental feature in Ruby 3.1 but in essence, it behaves very similarly to the array pattern, with the difference that, using the _find_ pattern you can check if the given object has any of the objects present in the pattern.
```ruby
irb(main):004:0> ["don't", 42, "panic", 42] in [*, Integer]
=> true

irb(main):008:0> ["don't", 4.0, "panic", 42] in [/don/, *, Integer]
true

irb(main):008:0> ["don't", 42, "panic", 42] in [/don/, Integer, *, Float]
false
```

#### Hash Pattern

The Hash pattern is one of the cases I mentioned before that we already had contact with in our first examples. It matches symbol keys against a given pattern, this pattern may be only the existing key or we can also match against `key: value` or even `key: type`. We have a main difference when comparing to the Array pattern because now we can perform partial matching, we can match a single key regardless of the other ones the Hash contains.
```ruby
irb(main):008:0> { id: 1, name: 'John' } in { id: }
true

irb(main):008:0> { id: 1, name: 'John' } in { id: 2 }
false

irb(main):008:0> { id: 1, name: 'John' } in { id: Integer }
true

irb(main):008:0> { id: 1, name: 'John' } in { id: Integer, **nil }
false
```

It is important to mention the `**nil` pattern present in our last example above because by using it, we make sure that the only accepted key is the one we are explicitly passing, and no partial matching is accepted. In our example, our hash must contain only a key called "id:" with an Integer value, that’s the reason our matching fails.

#### Alternative Pattern

The alternative pattern is also very interesting. It is pretty simple and tells us that we can mix different patterns, using pipe `|`, to compose a union of patterns against our values. In our example below, we’re explicitly saying that we accept either ‘john’ or ‘mary’ as acceptable values. The same for the other examples where we’re accepting either an Integer or String as acceptable values for the _created_at_ key.
```ruby
irb(main):008:0> ['john'] in ['john' | 'mary']
true

irb(main):008:0> { created_at: 20231027 } in { created_at: Integer | String }
true

irb(main):008:0> { created_at: 'Oct 27th, 2023'} in { created_at: Integer | String }
true
```

#### Variable Pattern

Last but not least. We can use pattern matching to bind matched values in local variables, basically, these values that match our pattern are gonna turn themselves into local variables in our scope.
In our examples below we can see that we’re extracting the first item of the array in a variable called head and the rest in another variable called, no surprise here, rest. The example using a Hash is equally very interesting, we can see that we are able to use pattern matching to extract local variables from complex and nested structures. We are getting the first item of the collection of friends and assigning it to a local variable called best_friend.
```ruby
irb(main):008:0> [1, 2, 3] in [head, Integer, Integer]
true

irb(main):008:0> head
=> 1

irb(main):008:0> [1, 2, 3] in [head, *rest]
true

irb(main):008:0> rest
=> [2, 3]

irb(main):008:0> f = { name: 'Ross', friends: [{ name: 'Chandler' }, { name: 'Joe' }] }
irb(main):008:0> f in { name:, friends: [{ name: best_friend }, *] }
irb(main):008:0> best_friend
=> Chandler

irb(main):008:0> { id: 1, name: 'John' } in id:, **rest
irb(main):008:0> id
=> 1

irb(main):008:0> rest
=> { name: 'John' }
```
<sub>_Note that we can also use **rest** operator with a Hash, the difference is now we're using double asteriks._</sub>

# Matching non-primitives objects

I think this is one of the most important things I’d like to share about pattern matching. We used different patterns so far and I haven’t mentioned that yet but, as you guys probably know, everything in Ruby is an object and, for things like the “in” keyword or even the “equals/greater than” operator work, it should invoke methods that are capable to deconstruct the structure of a giving object and allow its values to be compared. These methods in pattern-matching context are “deconstruct” and “deconstruct_keys”.

Array and Find patterns are going to trigger the #deconstruct method while the Hash pattern is gonna try to find the #deconstruct_keys.

```ruby
class Address
  def initialize(street)
    @street = street
  end

  def deconstruct_keys(keys)
    { street: @street }
  end

  def deconstruct
    [@street]
  end
end

irb(main):008:0> Address.new('29th Market St') in [String]
=> true

irb(main):008:0> Address.new('29th Market St') in [/Market/]
=> true

irb(main):008:0> Address.new('29th Market St') in { street: }
=> true
```

_In our previous examples we implementing both **deconstruct** and **deconstruct_keys** in our object Address which means we're able to use instances of this object to match against different patterns using Array or Hash pattern._

# Rails support

Unfortunately, even though there is a pull request opened to add support for this feature in Rails, the core team doesn’t have a consensus yet about supporting deconstruct and deconstruct_keys in its internal objects, and by the time I’m giving this talk Rails is in version 7.0.4.3 and it doesn’t support pattern matching yet.

Thank you guys.
