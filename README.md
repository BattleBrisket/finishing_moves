# Finishing Moves

##### By the guys at [Forge Software](http://www.forgecrafted.com/)

A collection of ultra-small, ultra-focused methods added to standard Ruby classes.

Ruby has a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself in a situation where an uncommon/awkward/elaborate coding maneuver wins the day. Finishing Moves is a collection of methods designed to assist those atypical scenarios.

In gamer terms, if standard Ruby methods are your default moves, Finishing Moves would be your limited-use actions or spells. In the right situation, they kick a serious amount of ass!

## Development approach

- **Never** override default Ruby behavior, only add functionality. No hacks.
- Follow the Unix philosophy of *"Do one job really well."*
- Minimize assumptions within the method (e.g. output format, mutating values, long conditional logic flows).

## Installation

Command line

```
gem install finishing_moves
```

Gemfile

```
gem 'finishing_moves'
```

## Current Moves

### Extensions to `Object`

#### `Object#nil_chain`
Arguably the sharpest knife in the block, `#nil_chain` allows you to write elaborate method chains without fear of tripping over `NoMethodError` and `NameError` exceptions when something in the chain throws out a nil value.

```ruby
# my_hash may have key :foo set...or it may not! Doooooom!

# without nil_chain = check to make sure the key exists

if my_hash.has_key? :foo
  my_hash[:foo].do_stuff
end

# with nil_chain = just do it, kick those nil ghosts in the teeth

nil_chain{ my_hash[:foo].do_stuff }
# => result of do_stuff, or nil
```

That situation was useful, but still pretty simple. Let's try it on a series of connected objects.

```ruby
class A
  attr_accessor :b
  def initialize(b)
    @b = b
  end
end

class B
  attr_accessor :c
  def initialize(c)
    @c = c
  end
end

class C
  def hello
    "Hello, world!"
  end
end

c = C.new
b = B.new c
a = A.new b

a.b.c.hello
# => "Hello, world!"
```

If the presence of attribute `c` is conditional, we must check for a proper association between objects `b` and `c` before calling `hello`...

```ruby
b.c = nil
a.b.c.hello
# => NoMethodError: undefined method `hello' for nil:NilClass

a.b.c.hello unless b.c.nil? || b.c.empty?
# => nil

a.b = nil

# Now it's really getting ugly. Imagine if we had a fourth association!
if !a.b.nil? && !a.b.empty?
  a.b.c.hello unless b.c.nil? || b.c.empty?
end
```

Or we can just skip all that conditional nonsense!
```
nil_chain{ a.b.c.hello }
# => output "Hello, world!" or nil
```

We use this all the time in our Rails projects. The A-B-C class example above was derived from a frequent use case in our models...

```ruby
# Model User has ZERO or more addresses, one of which is the primary.
# Model Address has a zip_code attribute.

user = User.find(9876)
nil_chain{ user.addresses.primary.zip_code }
# => returns nil if no addresses, or primary not set, otherwise returns zip_code
```

It also helps when dealing with optional parameters coming in from forms...

```ruby
# Somewhere in a random rails controller...

def search
  case nil_chain { params[:case_state].downcase }
    when 'open'      then filter_only_open
    when 'closed'    then filter_only_closed
    when 'invalid'   then filter_only_invalid
    when 'withdrawn' then filter_only_withdrawn
    when 'canceled'  then filter_only_canceled
  end
  # => apply proper case state filter, or nothing
end
```

Setting default values on form inputs in views...

```ruby
select_tag :date_field,
  options_for_select(@dropdown_date_field, nil_chain{params[:date_field]} )
# => Sets the selected option in the dropdown if the :date_field parameter exists
```

`nil_chain` is aliased to `chain` for a little more brevity, and `method_chain` for alternative clarity.

#### `Object#bool_chain`

This is the same logic under the hood as `nil_chain`, however we return a boolean `false` instead of nil if the chain breaks.

Following our A-B-C example above...

```ruby
bool_chain{ a.b.c.hello }
# => false
```

#### `Object#same_as`

Comparison operator that normalizes both sides into strings, then runs them over `==`

We love working with symbols in our code, but symbol values become strings when they hit the database. This meant typecasting wherever new and existing data might collide. No more!

This comparison will work on any class that has a `to_s` method defined on it.

```ruby
# All these comparisons will return true

:foobar.same_as 'foobar'
'foobar'.same_as :foobar
'1'.same_as 1
2.same_as '2'
3.same_as 3
```

Normal case-sensitivity rules apply.

```ruby
:symbol.same_as :SYMBOL
# => false
```

Since this method is defined in Object, your own custom classes inherit it automatically, allowing you to compare literally anything at any time, without worrying about typecasting! Just make sure you define sane output for `to_s` and you're all set.

```ruby
class User
  attr_writer :handle

  def handle
    @handle || "faceless_one"
  end

  def to_s
    handle.to_s
  end
end

user = User.new
:faceless_one.same_as user
# => true
user.same_as :faceless_one
# => true
user.same_as 'faceless_one'
# => true
user.same_as 'FACELESS_ONE'
# => false
```

#### `Object#class_exists?`

> *I just want to know if [insert class name] has been defined!*
>
> -- Every dev at some point

```ruby
class_exists? :Symbol
# => true
class_exists? :Symbology
# => false, unless your Dan Brown
class_exists? :Rails
# => true in a Rails app
```

Because the class **might** exist, we cannot pass in the constant version of the name. You must use a symbol or string value.

```ruby
class_exists? DefinitelyFakeClass
# => NameError: uninitialized constant DefinitelyFakeClass
class_exists? :DefinitelyFakeClass
# => false
```

#### `Object#not_nil?`

Because that dangling `!` on the front of a call to `nil?` is just so not Ruby-chic.

Now pass me another PBR.

```ruby
nil.not_nil?
# => false
'foobar'.not_nil?
# => true
```

### Extensions to `Hash`

#### `Hash#delete!`

The normal [`Hash#delete`](http://www.ruby-doc.org/core-2.1.5/Hash.html#method-i-delete) method returns the value that's been removed from the hash, but it can be equally useful if we return the newly modified hash.

This approach effectively throws away the value being deleted, so don't use this when the deleted hash entry is valuable.

```ruby
my_hash = { :foo => :bar, :baz => :bin, :flo => :bie }

my_hash.delete! :baz
# => { :foo => :bar, :flo => :bie }
```

If the key is not found, the hash is returned unaltered.

```ruby
my_hash.delete! :bogus
# => { :foo => :bar, :baz => :bin, :flo => :bie }
```

#### `Hash#delete_each`
Deletes all records in a hash matching the keys passed in as an array. Returns a hash of deleted entries. Silently ignores any keys which are not found.

```ruby
my_hash = { :foo => :bar, :baz => :bin, :flo => :bie }

my_hash.delete_each :bogus, :bar
# => nil
my_hash
# => { :foo => :bar, :baz => :bin, :flo => :bie }

my_hash.delete_each :flo
# => { :flo => :bie }
my_hash
# => { :foo => :bar, :baz => :bin }

my_hash.delete_each :foo, :baz, :bogus
# => { :foo => :bar, :baz => :bin }
my_hash
# => { }
```

#### `Hash#delete_each!`

Same logic as `delete_each`, but return the modified hash, and discard the deleted values. Maintains parity with the contrast of `delete` vs `delete!`

```ruby
my_hash.delete_each! :bogus, :bar
# => { :foo => :bar, :baz => :bin, :flo => :bie }

my_hash.delete_each! :flo
# => { :foo => :bar, :baz => :bin }

my_hash.delete_each! :bogus, :flo, :foo
# => { :baz => :bin }

my_hash.delete_each! :baz
# => { }
```

### Numerical length

Coming soon!

### Expanded boolean typecasting

Coming soon!

## Share your finishing moves!

### Got an idea for another finisher?

1. Fork this repo
2. Write your tests
3. Add your finisher
4. Repeat steps 2 and 3 until badass
5. Submit a pull request
6. Everyone kicks even more ass!
