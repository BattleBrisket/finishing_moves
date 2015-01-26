# Finishing Moves
[![Gem Version](https://badge.fury.io/rb/finishing_moves.svg)](http://badge.fury.io/rb/finishing_moves)

##### By the guys at [Forge Software](http://www.forgecrafted.com/)

Ruby includes a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself in a situation where an *elaborate-yet-precise* coding maneuver wins the day. Finishing Moves is a collection of methods designed to assist in those just-typical-enough-to-be-annoying scenarios.

In gamer terms, if standard Ruby methods are your default moves, `finishing_moves` would be mana-consuming techniques. Your cooldown spells. Your grenades (there's never enough grenades). In the right situation, they kick serious [cyclomatic butt](https://en.wikipedia.org/wiki/Cyclomatic_complexity).

## Development approach

- **Never** override default Ruby behavior, only add functionality.
- Follow the Unix philosophy of *"Do one job really well."*
- Minimize assumptions within the method, e.g. avoid formatting output, mutating values, and long conditional logic flows.
- Play nice with major Ruby players like Rake, Rails, and Sinatra.
- Test all the things.

## Installation

Gemfile
```
gem 'finishing_moves'
```

Command line
```
gem install 'finishing_moves'
```

[Here's the gem link](https://rubygems.org/gems/finishing_moves), if you like looking at that stuff.

## List of Methods

- [`Kernel#nil_chain`](#kernelnil_chain)
- [`Kernel#bool_chain`](#kernelbool_chain)
- [`Kernel#class_exists?`](#kernelclass_exists)
- [`Kernel#cascade`](#kernelcascade)
- [`Object#same_as`](#objectsame_as)
- [`Object#not_nil?`](#objectnot_nil)
- [`Object#is_an?`](#objectis_an)
- [`Hash#delete!`](#hashdelete)
- [`Hash#delete_each`](#hashdelete_each)
- [`Hash#delete_each!`](#hashdelete_each-1)
- [`Integer#length`](#integerlength)
- [Typecasting *to* `Boolean`](#typecasting-to-boolean)
- [Typecasting *from* `Boolean` and `Nil`](#typecasting-from-boolean-and-nil)
- [`Enumerable#key_map`](#enumerable-key_map)
- [`Enumerable#key_map_reduce`](#enumerable-key_map_reduce)

### Extensions to `Kernel`

#### `Kernel#nil_chain`
Arguably the sharpest knife in the block, `#nil_chain` allows you to write elaborate method chains without fear of tripping over `NoMethodError` and `NameError` exceptions when something in the chain throws out a nil value.

##### Examples

```ruby
# foobar may have a transmogrify method...or it may not! Doooooom!

# without nil_chain, we check to make sure the method exists

foobar.transmogrify if foobar.respond_to? :transmogrify

# with nil_chain, we just do it, and kick those nil ghosts in the teeth

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

Still pretty simple. Let's try it on a series of connected objects.

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

Let's suppose the presence of attribute `c` is conditional. We must then check for a proper association between objects `b` and `c` before calling `hello`.

```ruby
b.c = nil
a.b.c.hello
# => NoMethodError: undefined method `hello' for nil:NilClass

a.b.c.hello unless b.c.nil? || b.c.empty?
# => nil

a.b = nil

# Now it's really getting ugly.
if !a.b.nil? && !a.b.empty?
  a.b.c.hello unless b.c.nil? || b.c.empty?
end

# Imagine if we had a fourth association, or a fifth! The patterns, man!
```

Or we can just skip all that conditional nonsense.

```ruby
nil_chain{ a.b.c.hello }
# => output "Hello, world!" or nil

a = nil
nil_chain{ a.b.c.hello }
# => still just nil
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
  # => apply a case state filter, or do nothing
end
```

Setting default values on form inputs in views...

```ruby
select_tag :date_field,
  options_for_select(@dropdown_date_field, nil_chain{params[:date_field]} )
# => Sets the selected option in the dropdown if the :date_field parameter exists
```

##### Custom return value

You can change the value that `nil_chain` returns when it catches a `NoMethodError` or `NameError` exception. `nil_chain` accepts a single optional argument before the block to represent the return value. The default is `nil`, but you can set it to whatever you want.

We recently used this functionality in generating a CSV report. The client's use case required us to spit out an `'N/A'` string anytime a proper field value was missing. `nil_chain` made the adjustment easy.

```ruby
CSV.generate do |csv|
  @records.each do |record|  # each record represents a single line in the CSV
    values = []
    csv_fields_in_order.each do |field|
      values << nil_chain('N/A') { record.send(field) }
                # respond with a pretty value when the field is empty or invalid
    end
    csv << values
  end
end
```

We also find this handy when doing conditional stuff based on presence/absence of a key in a hash.

```ruby
# without nil_chain
if my_hash[:foo]
  # (by default, ruby returns nil when you request an unset key)
  var = my_hash[:foo]
else
  var = :default_value
end

# with nil_chain, we get a nice one liner
var = nil_chain(:default_value) { my_hash[:foo] }

# What if the default value is coming from somewhere else?
# What if we want to call a method directly on the hash?
# What if the ley lines are out of alignment!?
# No problem.

var = nil_chain(Geomancer.reset_ley_lines) { summon_fel_beast[:step_3].scry }
# => value of summon_fel_beast[:step_3].scry if it's set, or
#    Geomancer.reset_ley_lines if it's not
```

#### Alias

`nil_chain` is aliased to `method_chain` for alternative clarity.

#### `Kernel#bool_chain`

This is the same logic under the hood as `nil_chain`, however we forcibly return a boolean `false` instead of `nil` if the chain breaks.

Following our A-B-C example above...

```ruby
bool_chain{ a.b.c.hello }
# => false
```

If you read about `nil_chain`'s custom return value, you know that you can do this explicitly too. This shortcut just saves some typing.

```ruby
nil_chain(false) { a.b.c.hello }
# => false
```

#### `Kernel#class_exists?`

> *I just want to know if [insert class name] has been defined!*
>
> -- Every dev at some point

Sure, Ruby has the `defined?` method, but the output is less than helpful when you're doing conditional flows.

```ruby
defined?(SuperSaiyan)
# => nil

require 'super_saiyan'

defined?(SuperSaiyan)
# => 'constant'

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
# => false, unless you're Dan Brown
class_exists? :Rails
# => true in a Rails app
```

Because the class **might** exist, we cannot pass in the constant version of the name. You **must** use a symbol or string value.

```ruby
class_exists? DefinitelyFakeClass
# => NameError: uninitialized constant DefinitelyFakeClass

class_exists? :DefinitelyFakeClass
# => false (at least it better be; if you *actually* use this name, I will find you...)
```

#### `Kernel#cascade`

This method is designed to facilitate a set of **consecutive, mutating actions** which may be interrupted at multiple arbitrary points. In pseudo-code, the logic we're trying to write looks like this:

1. Begin stepwise process.
2. Set `[values]` to a default starting state.
3. If `[first requirement]` is not met, bail out.
4. Perform steps that require `[first requirement]`, possibly mutating `[values]`.
5. If `[next requirement]` is not met, bail out.
6. Perform steps that require `[next requirement]`, possibly mutating `[values]` again.
7. (Repeat for as many steps as necessary.)
8. End stepwise process.
9. Perform follow-up action(s) based on resulting `[values]`.

Here's a contrived Rails-y sample of a login approval process:

```ruby
cascade do
  logged_in = false
  # not doing anything if they didn't provide creds
  break if params['username'].nil? || params['password'].nil?
  # ok, got creds, do they exist?
  user = User.find_by username: params['username']
  # does the user exist?
  break if user.nil?
  # does the password match?
  break if user.validate_password(params['password'])
  # maybe the user account is banned?
  break if user.banned?
  # everything looks good, let's do it
  login user
  logged_in = true
end

if logged_in
  # additional follow-up steps for authenticated users
else
  # display error message, log the failed attempt, whatever
end
```

We're using the [`loop`](http://www.ruby-doc.org/core-2.1.5/Kernel.html#method-i-loop) construct under the hood, which is what allows us to use the `break` statement as outlined in the example.

###### *"Why not just shove the logic into a method and use `return` instead of `break`?"*

You should absolutely use methods if it makes sense!

`cascade` is ideal for small sets of logic, when you've *already* broken out your logic into a method and further breakout is just silly.

To illustrate, here's a small real-world sample from one of our projects:

```ruby
class ReportsController < ApplicationController

  before_action :define_search_params, only: :run_report

  # ...

  def define_search_params
    @report = params[:report].to_sym

    # Set the report category, :medical or :drug
    #   1. An :ongoing report is always in the :drug category
    #   2. Otherwise default to :medical
    #   3. :dismissal reports are always :medical (so we use the default)
    #   4. Finally just use the params value, if it matches an allowable value
    cascade do
      if @report == :ongoing
        @category = :drug
        break
      end
      @category = :medical
      break if @report == :dismissals
      @category = params[:category] if params[:category].in? allowable_categories
    end
  end

end
```

It's overkill to break that bit of logic for the value of `@category` out into another method.

Plus, we find the vertically aligned codes reads better, especially as the list of conditionals goes beyond two. This pattern also has the added benefit of making top-to-bottom "readable" sense.

### Extensions to `Object`

#### `Object#same_as`

Comparison operator that normalizes both sides into strings, then runs them over `==`.

The comparison will work on any class that has a `to_s` method defined on it.

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
# => still false
```

Since this method is defined in Object, your own custom classes inherit it automatically, allowing you to compare literally anything at any time, without worrying about typecasting!

**Make sure you define sane output for `to_s`** and you're all set.

We love working with symbols in our code, but symbol values become strings when they hit the database. This meant typecasting wherever new and existing data might collide. No more!

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

#### `Object#not_nil?`

Because that dangling `!` on the front of a call to `nil?` is just oh so not-ruby-chic.

```ruby
nil.not_nil?
# => false
'foobar'.not_nil?
# => true
```

Pass me one of those PBR's.

#### `Object#is_an?`

Alias for the [`is_a?` method](http://ruby-doc.org/core-2.2.0/Object.html#method-i-is_a-3F), for even more Ruby chic!

```ruby
1.is_a? Integer
# => true, and a thorn in the side of grammar teachers everywhere!
1.is_an? Integer
# => still true, but now I don't mentally pause every time I read it.
```

Now pass me another PBR and my fedora.

### Extensions to `Hash`

#### `Hash#delete!`

The normal [`Hash#delete`](http://www.ruby-doc.org/core-2.1.5/Hash.html#method-i-delete) method returns the value that's been removed from the hash, but it can be equally useful if we return the newly modified hash instead.

This approach effectively throws away the value being deleted, so don't use this when the deleted hash entry is valuable.

```ruby
power_rangers = {
  :red => 'Jason Scott',
  :blue => 'Billy Cranston',
  :green => 'Tommy Oliver'
}

power_rangers.delete! :green
# => { :red => 'Jason Lee Scott', :blue => 'Billy Cranston' }
```

If the key is not found, the hash is returned unaltered.

```ruby
power_rangers.delete! :radiant_orchid
# => { :red => 'Jason Lee Scott', :blue => 'Billy Cranston' }
#    It probably would've triggered if I included Kimberly
```

#### `Hash#delete_each`
Deletes all records in a hash matching the keys passed in as an array. Returns a hash of deleted entries. Silently ignores any keys which are not found.

```ruby
mega_man_bosses = { :metal_man => 1, :bubble_man => 2, :heat_man => 3, :wood_man => 4 }

mega_man_bosses.delete_each :chill_penguin, :spark_mandrill
# => nil, and get your series straight
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

### `Integer#length`

Ruby doesn't provide a native way to see how many digits are in an integer, but that's exactly what we worry about anytime database `INT` lengths collide with Ruby `Fixnum` or `Bignum` values.

```ruby
1.length
# => 1
9.length
# => 1
90.length
# => 2
900.length
# => 3
9000.length
# => 4
9001.length
# => OVER NINE THOUSAAAAAAND (also 4)

12356469787881584554556.class.name
# => "Bignum"
12356469787881584554556.length
# => 23
```

For consistency, we added matching methods to `Float` and `BigDecimal` that simply raise an `ArgumentError`.

```ruby
12356469.987.class.name
# => "Float"
12356469.987.length
# => ArgumentError: Cannot get length: "12356469.987" is not an integer

1265437718438866624512.123.class.name
# => "Float" (it's really BigDecimal, trust me)
1265437718438866624512.123.length
# => ArgumentError: Cannot get length: "1.2654377184388666e+21" is not an integer
```

#### Alias

`length` is aliased to `digits` for alternative clarity.

### Typecasting *to* `Boolean`

Boolean values are frequently represented as strings and integers in databases and file storage. So we always thought it was a little odd that Ruby lacked a boolean typecasting method, given the proliferation of `to_*` methods for `String`, `Symbol`, `Integer`, `Float`, `Hash`, etc.

So we made some for `String`, `Integer`, and `Nil`.

#### `String#to_bool`

Strings get analyzed and return `true` or `false` for a small set of potential values.

These comparisons are not case-sensitive.

```ruby
['1', 't', 'true', 'on', 'y', 'yes'].each do |true_string|
  true_string.to_bool
  # => true

  true_string.upcase.to_bool
  # => true
end

['0', 'f', 'false', 'off', 'n', 'no'].each do |false_string|
  false_string.to_bool
  # => false

  false_string.upcase.to_bool
  # => false
end

# empty strings and strings with only spaces evaluate to false
["", " ", "  ", "                "].each do |empty_string|
  empty_string.to_bool
  # => false
end
```

A string with anything other than these matching values will throw an error.

```ruby
["foo", "tru", "trueish", "druish", "00", "000"].each do |bad_string|
  bad_string.to_bool
  # => ArgumentError: invalid value for Boolean
end
```

#### `Fixnum#to_bool`

A zero is false, a one is true. That's it. Everything else throws `ArgumentError`.

```ruby
0.to_bool
# => false

1.to_bool
# => true

2.to_bool
# => ArgumentError: invalid value for Boolean: "2"

-1.to_bool
# => ArgumentError: invalid value for Boolean: "-1"

8675309.to_bool
# => ArgumentError: invalid value for Boolean: "8675309"
```

#### `NilClass#to_bool`

A nil value typecasted to a boolean is false.

```ruby
nil == false
# => false

nil.to_bool
# => false

nil.to_bool == false
# => true
```

#### `TrueClass#to_bool` and `FalseClass#to_bool`

In case your code calls `to_bool` on a variable of indeterminate type, they return what you expect.

```ruby
true.to_bool
# => true

false.to_bool
# => false
```

### Typecasting *from* `Boolean` and `Nil`

Complementing the methods to typecast boolean values coming out of data storage, we have methods to convert booleans and `nil` into integer and symbol representations.

```ruby
true.to_i
# => 1
true.to_sym
# => :true

false.to_i
# => 0
false.to_sym
# => :false

nil.to_i
# => 0 (following same logic as `NilClass#to_bool`)
nil.to_sym
# => :nil
```

### Extensions to `Enumerable`

#### `Enumerable#key_map`

Standard `Enumerable#map` has a great shortcut when you want to create an `Array` by calling a method on each element in the collection. For example:

```ruby
class Pokemon
  attr_accessor :name
  def initialize(n)
    @name = n
  end
end

your_pokedex = [
  Pokemon.new("Bulbasaur"),
  Pokemon.new("Charmander"),
  Pokemon.new("Squirtle"),
]
```

If you want an `Array` of Pokemon names, you use `Enumerable#map`:

    your_pokedex.map { |p| p.name }
    # => ["Bulbasaur", "Charmander", "Squirtle"]

The shortcut makes it easy for trivial repeatable method calls (such as to `:name`):

    your_pokedex.map(&:name)
    # => ["Bulbasaur", "Charmander", "Squirtle"]

But what happens when my Pokedex isn't as well-structured as yours?

```ruby
my_pokedex = [
  {name: "Bulbasaur"},
  {name: "Charmander"},
  {name: "Squirtle"},
]
```

I can still map the `:name` keys out to an `Array` with full block notation...

    my_pokedex.map { |p| p[:name] }
    # => ["Bulbasaur", "Charmander", "Squirtle"]

But such sad! I can haz no shortcut.

    my_pokedex.map(??????)
    # => ["Bulbasaur", "Charmander", "Squirtle"]

Enter `Enumerable#key_map`:

    my_pokedex.key_map(:name)
    # => ["Bulbasaur", "Charmander", "Squirtle"]

#### `Enumerable#key_map_reduce`

Building off of `Enumerable#key_map`, finishing_moves provides a convenience method when you need to perform a one-step map/reduce operation on a collection.

```ruby
my_pokedex = [
  {name: "Bulbasaur",   level: 2},
  {name: "Charmander",  level: 2},
  {name: "Squirtle",    level: 2},
]
```

In other words, this map/reduce operation

    my_pokedex.key_map(:level).reduce(0) { |memo,lvl| memo + lvl }
    # => 6

can be simplified to

    my_pokedex.key_map_reduce(:level, :+)
    # => 6

where `:+` can be any named method of `memo`, and is applied to each value (just as in `Enumerable#reduce`). For additional flexibility, you can pass an intial value for `memo` and a custom `block` (and again, this works just like `Enumerable#reduce`):

    my_pokedex.key_map_reduce(:level, 0) { |memo,lvl| memo + lvl }
    # => 6

### Extensions to `String`

#### `String#strip_all`

The built-in `strip` method removes leading and trailing whitespace, but there's no complementary function to strip other characters, like newlines, dashes, and/or underscores. `strip_all` allows you to perform these kinds of cleanups without having to deal directly with regex.

The lone argument is a string of the characters you want to remove. By default, `strip_all` will remove dashes `-` and underscores `_`.

```ruby
'___foo___'.strip_all
# => 'foo'

'---foo---'.strip_all
# => 'foo'
```

Note that the argument is processed as a **regex group** (your argument ends up inside of a regex `[]`). This means we evaluate the individual characters of the argument, not an explicit character sequence. You do not need spaces between the characters.

```ruby
'__-_--foo--_-__'.strip_all
# => 'foo'

'123foo123'.strip_all('321')
# => 'foo'

'xXxXfooXxXx'.strip_all('XYZx')
# => 'foo'
```

This also means that case-sensitivity still applies.

```ruby
'ABCfooABC'.strip_all('abc')
# => 'ABCfooABC'
```

Because this method is intended to be a drop-in enhancement of `strip`, `strip_all` will always remove whitespace, even when providing your own set of characters.

```ruby
'////   foo   ////'.strip_all('/')
# => 'foo'
```

Everything passed in is escaped by default, so you don't have to worry about symbols.

```ruby
'/[a|valid|regex]+/'.strip_all('/[]+|')
# => 'a|valid|regex'

# Remember, we're enhancing the strip method; the pipes are still because
# they are not lead or trailing in this string.
```

The one exception is when you pass in the regex character ranges `0-9`, `a-z`, and `A-Z`. Those will be read as expressions to capture all numbers, all lowercase or all uppercase letters, respectively.

```ruby
'0123456789   foo   9876543210'.strip_all('0-9')
# => 'foo'

'FOO  314   BARBAZ'.strip_all('A-Z')
# => '314'

'hello--314--world'.strip_all('a-z')
# => '--314--'

'hello--314--world'.strip_all('a-z-') # note the extra dash at the end
# => '314'

# you can really shoot yourself in the foot if you're not careful
'hello world'.strip_all('a-z')
# => ''

'abcdefghijklm   foo123   nopqrstuvwxyz'.strip_all('a-z0-9')
# => ''
```

##### Variants to `strip_all`

We provide the same set of associated methods as `strip`.

- **`lstrip_all`** removes only leading characters
- **`rstrip_all`** removes only trailing characters
- All three have bang variants -- **`strip_all!`**, **`lstrip_all!`**, and **`rstrip_all!`** -- that perform the replacement in place, rather than returning a copy.

#### `String#remove_whitespace`
#### `String#nl2br`
#### `String#match?`
#### `String#dedupe`
#### `String#keyify`


## Bug Reports

**[Drop us a line in the issues section.](https://github.com/forgecrafted/finishing_moves/issues)**

Be sure to include some sample code that reproduces the problem.

## Add your own finisher!

1. Fork this repo
2. Write your tests
3. Add your finisher
4. Repeat steps 2 and 3 until you see a brilliant luster
5. Submit a pull request

###### Got a good nerdy reference for our code samples?
We'll take pull requests on those too. Bonus karma points if you apply the reference to the specs too.

## Credits

![forge software](http://www.forgecrafted.com/logo.png)

Finishing Moves is maintained and funded by [Forge Software (forgecrafted.com)](http://www.forgecrafted.com)

If you like our code, please give us a hollar if your company needs outside pro's who write damn-good code AND run servers at the same time!

## License

Finishing Moves is Copyright 20XX (that means "forever") Forge Software, LLC. It is free software, and may be
redistributed under the terms specified in the LICENSE file.
