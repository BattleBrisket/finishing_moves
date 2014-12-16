# Finishing Moves

##### By the guys at [Forge Software](http://www.forgecrafted.com/)

A collection of ultra-small, ultra-focused methods added to standard Ruby classes.

Ruby has a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself in a situation where an uncommon/awkward/elaborate coding maneuver wins the day. Finishing Moves is a collection of methods designed to assist those atypical scenarios.

In gamer terms, if standard Ruby methods are your default moves, `finishing_moves` would be your mana-powered moves, cooldown spells, or grenades (there's never enough grenades). In the right situation, they kick a serious amount of ass!

## Development approach

- **Never** override default Ruby behavior, only add functionality. No hacks.
- Follow the Unix philosophy of *"Do one job really well."*
- Minimize assumptions within the method, e.g. avoid formatting output, mutating values, and long conditional logic flows.

## Installation

(Gemification coming soon!)

## Current Finishers

### Extensions to `Object`

#### `Object#nil_chain`
Arguably the sharpest knife in the block, `#nil_chain` allows you to write elaborate method chains without fear of tripping over `NoMethodError` and `NameError` exceptions when something in the chain throws out a nil value.

##### Examples

```ruby
# foobar may have a transmogrify method...or it may not! Doooooom!

# without nil_chain, we check to make sure the method exists

foobar.transmogrify if foobar.respond_to? :transmogrify

# with nil_chain = just do it, kick those nil ghosts in the teeth

nil_chain{ foobar.transmogrify }
# => result of foobar.transmogrify, or nil
```

Not really saving much typing there, but how about an object assigned to a hash?

```ruby
# without nil_chain, we check to make sure the key exists

if my_hash.has_key? :foo
  my_hash[:foo].do_stuff
end

# with nil_chain, things look a lot cleaner

nil_chain{ my_hash[:foo].do_stuff }
# => result of my_hash[:foo].do_stuff, or nil
```

More useful, but still pretty simple. Let's try it on a series of connected objects.

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
# Or a fifth! The patterns, man!
if !a.b.nil? && !a.b.empty?
  a.b.c.hello unless b.c.nil? || b.c.empty?
end
```

Or we can just skip all that conditional nonsense!

```ruby
nil_chain{ a.b.c.hello }
# => output "Hello, world!" or nil
```

##### Examples in Rails

We use `nil_chain` all the time in Rails projects. The A-B-C class example above was derived from a frequent use case in our models...

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
  # => apply proper case state filter, or do nothing
end
```

Setting default values on form inputs in views...

```ruby
select_tag :date_field,
  options_for_select(@dropdown_date_field, nil_chain{params[:date_field]} )
# => Sets the selected option in the dropdown if the :date_field parameter exists
```

##### Default return

You can change the value that nil_chain returns when it hits a `NoMethodError` or `NameError` exception. `nil_chain` accepts a single optional argument before the block to represent the return value. The default is `nil`, but you can set it to whatever you want.

We recently used this functionality in generating a CSV. Anywhere the outputted value would have been blank, we adjusted the return value to spit out 'N/A', a requirement for the client's use case.

```ruby
CSV.generate do |csv|
  @records.each do |record|  # each record represents a single line in the CSV
    values = []
    csv_fields_in_order.each do |field|
      # nil_chain ensures we respond with a nice default value when the field is empty or invalid
      values << nil_chain('N/A') { record.send(field) }
    end
    csv << values
  end
end
```

We find this handy when doing conditional stuff based on presence/absence of a key in a hash.

```ruby
# without nil_chain
if my_hash[:foo].nil?    # (by default, ruby returns nil when you request an unset key)
  var = :default_value
else
  var = my_hash[:foo]
end

# with nil_chain, we get a nice one liner

var = nil_chain(:default_value) { my_hash[:foo] }

# What if the default value is coming from somewhere else?
# What if we want to call a method directly on the hash?
# What if the ley lines are out of alignment?
# No problem.

var = nil_chain(Geomancer.reset_ley_lines) { summon_fel_beast[:step_3].scry }
# => value of summon_fel_beast[:step_3].scry if it's set, or
#    Geomancer.reset_ley_lines if it's not
```

##### Aliases

`nil_chain` is aliased to `chain` for a little more brevity, and `method_chain` for alternative clarity.

#### `Object#bool_chain`

This is the same logic under the hood as `nil_chain`, however we forcibly return a boolean `false` instead of `nil` if the chain breaks.

Following our A-B-C example above...

```ruby
bool_chain{ a.b.c.hello }
# => false
```

If you read about the default return, you know that you can do this explicitly with `nil_chain` too. It's just a little less to type.

```ruby
nil_chain(false) { a.b.c.hello }
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

:symbol.same_as 'SYMBOL'
# => false
```

Since this method is defined in Object, your own custom classes inherit it automatically, allowing you to compare literally anything at any time, without worrying about typecasting!

**Make sure you define sane output for `to_s`** and you're all set.

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

If you're a Rails user, you'll find this incredibly helpful when comparing nice neat symbol values to all the string garbage coming out of the database, or the `params` hash.

It's not doing much for code logic, but we find it helpful when doing in-code searches, since we can look for a specific symbol, and don't have tio worry about missing a reference because it was a string instead.

```ruby
user.role = :admin
user.save!

# some time and code passes...

if user.role.same_as :admin
  # Do awesome godly admin stuff
  # Yes, I know an enum would've worked better. It's SAMPLE code, you dork.
end
```

#### `Object#class_exists?`

> *I just want to know if [insert class name] has been defined!*
>
> -- Every dev at some point

Sure, Ruby has the `defined?` method, but the output is less than helpful when you're doing conditional flows.

```ruby
defined?(SuperSaiyan) # => nil
require 'super_saiyan'
defined?(SuperSaiyan) # => constant

if defined?(SuperSaiyan) == 'constant'
  # Power up to level 4
  # But after that obtuse if-statement, I'm just too tired
end
```

`class_exists?` does exactly what you want, and provides an obvious, natural boolean response.

```ruby
class_exists? :Symbol
# => true
class_exists? :Symbology
# => false, unless your Dan Brown
class_exists? :Rails
# => true in a Rails app
```

Because the class **might** exist, we cannot pass in the constant version of the name. You **must** use a symbol or string value.

```ruby
class_exists? DefinitelyFakeClass
# => NameError: uninitialized constant DefinitelyFakeClass

class_exists? :DefinitelyFakeClass
# => false (at least it better be; if you actually use this name, I will find you...)
```

#### `Object#not_nil?`

Because that dangling `!` on the front of a call to `nil?` is just oh so not-ruby-chic.

```ruby
nil.not_nil?
# => false
'foobar'.not_nil?
# => true
```

There, much more legible. Now pass me my fedora and another PBR.


### Extensions to `Hash`

#### `Hash#delete!`

The normal [`Hash#delete`](http://www.ruby-doc.org/core-2.1.5/Hash.html#method-i-delete) method returns the value that's been removed from the hash, but it can be equally useful if we return the newly modified hash instead.

This approach effectively throws away the value being deleted, so don't use this when the deleted hash entry is valuable.

```ruby
power_rangers = { :red => 'Jason Scott', :blue => 'Billy Cranston', :green => 'Tommy Oliver' }

power_rangers.delete! :green
# => { :red => 'Jason Lee Scott', :blue => 'Billy Cranston' }
```

If the key is not found, the hash is returned unaltered.

```ruby
power_rangers.delete! :radiant_orchid
# => { :red => 'Jason Lee Scott', :blue => 'Billy Cranston' }
#    although it probably woulda triggered if I included Kimberly
```

#### `Hash#delete_each`
Deletes all records in a hash matching the keys passed in as an array. Returns a hash of deleted entries. Silently ignores any keys which are not found.

```ruby
mega_man_bosses = { :metal_man => 1, :bubble_man => 2, :heat_man => 3, :wood_man => 4 }

mega_man_bosses.delete_each :chill_penguin, :spark_mandrill
# => nil, and get your mega man series straight
mega_man_bosses
# => { :metal_man => 1, :bubble_man => 2, :heat_man => 3, :wood_man => 4 }

mega_man_bosses.delete_each :metal_man
# => { :metal_man => 1 }
mega_man_bosses
# => { :bubble_man => 2, :heat_man => 3, :wood_man => 4 }

mega_man_bosses.delete_each :bubble_man, :heat_man, :wheel_gator
# => { :bubble_man => 2, :heat_man => 3 }
mega_man_bosses
# => { :wood_man => 4 }
```

#### `Hash#delete_each!`

Same logic as `delete_each`, but return the modified hash, and discard the deleted values.

Maintains parity with the contrast of `delete` vs `delete!` described above.

```ruby
mega_man_bosses = { :air_man => 5, :crash_man => 6, :flash_man => 7, :quick_man => 8 }

mega_man_bosses.delete_each! :yellow_devil, :air_man
# => { :crash_man => 6, :flash_man => 7, :quick_man => 8 }

mega_man_bosses.delete_each! :flash_man
# => { :crash_man => 6, :quick_man => 8 }
#    Take out flash anytime after metal, I like to wait until I need a breather.

mega_man_bosses.delete_each! :crash_man, :quick_man
# => { }
```

### Numerical length

Coming soon!

### Expanded boolean typecasting

Coming soon!

## Share your finishing moves!

### Got an idea for another finisher? Got a good nerd reference for our code samples?

1. Fork this repo
2. Write your tests
3. Add your finisher
4. Repeat steps 2 and 3 until badass
5. Submit a pull request
6. Everyone kicks even more ass!
