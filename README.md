# Finishing Moves
[![Gem Version](https://badge.fury.io/rb/finishing_moves.svg)](https://rubygems.org/gems/finishing_moves)
[![Build Status](https://travis-ci.org/forgecrafted/finishing_moves.svg?branch=master)](https://travis-ci.org/forgecrafted/finishing_moves)
[![Coverage Status](https://coveralls.io/repos/forgecrafted/finishing_moves/badge.svg?branch=master)](https://coveralls.io/r/forgecrafted/finishing_moves?branch=master)
[![Hire Us!](https://img.shields.io/badge/pros-for%20hire-F7931E.svg)](http://www.forgecrafted.com)

Ruby includes a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself in a situation where an **elaborate-yet-precise** coding maneuver wins the day. Finishing Moves is a collection of methods designed to assist in those just-typical-enough-to-be-annoying scenarios.

In gamer terms, if standard Ruby methods are your default moves, Finishing Moves would be mana-consuming techniques. Your cooldown spells. Your grenades (there's never enough grenades!). In the right situation, they kick serious [cyclomatic butt](https://en.wikipedia.org/wiki/Cyclomatic_complexity).

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

### Ruby Version

Tested against **`2.0.0` and above**. Probably works in `1.9.3`.

## List of Methods
###### Complete documentation in the [GitHub wiki](https://github.com/forgecrafted/finishing_moves/wiki)

**Not sure if this gem is for you?** Check out the methods marked with a :boom: first.

  - [`Array#to_hash_values`](https://github.com/forgecrafted/finishing_moves/wiki/Array#arrayto_hash_values) :boom:
  - [`Array#to_indexed_hash`](https://github.com/forgecrafted/finishing_moves/wiki/Array#arrayto_indexed_hash)
  - [`Array#to_hash_keys`](https://github.com/forgecrafted/finishing_moves/wiki/Array#arrayto_hash_keys)
  - [`Enumerable#key_map`](https://github.com/forgecrafted/finishing_moves/wiki/Enumerable#enumerablekey_map) :boom:
  - [`Enumerable#key_map_reduce`](https://github.com/forgecrafted/finishing_moves/wiki/Enumerable#enumerablekey_map_reduce)
  - [`Hash#delete!`](https://github.com/forgecrafted/finishing_moves/wiki/Hash#hashdelete)
  - [`Hash#delete_each`](https://github.com/forgecrafted/finishing_moves/wiki/Hash#hashdelete_each)
  - [`Hash#delete_each!`](https://github.com/forgecrafted/finishing_moves/wiki/Hash#hashdelete_each-1)
  - [`Integer#length`](https://github.com/forgecrafted/finishing_moves/wiki/Numeric#integerlength)
  - [`Kernel#nil_chain`](https://github.com/forgecrafted/finishing_moves/wiki/Kernel#kernelnil_chain) :boom::boom:
  - [`Kernel#cascade`](https://github.com/forgecrafted/finishing_moves/wiki/Kernel#kernelcascade)
  - [`Kernel#class_exists?`](https://github.com/forgecrafted/finishing_moves/wiki/Kernel#kernelclass_exists)
  - [`Numeric#add_percent`](https://github.com/forgecrafted/finishing_moves/wiki/Numeric#numericadd_percent)
  - [`Numeric#subtract_percent`](https://github.com/forgecrafted/finishing_moves/wiki/Numeric#numericsubtract_percent)
  - [`Object#same_as`](https://github.com/forgecrafted/finishing_moves/wiki/Object#objectsame_as)
  - [`Object#not_nil?`](https://github.com/forgecrafted/finishing_moves/wiki/Object#objectnot_nil)
  - [`Object#is_an?`](https://github.com/forgecrafted/finishing_moves/wiki/Object#objectis_an)
  - [`String#dedupe`](https://github.com/forgecrafted/finishing_moves/wiki/String#stringdedupe)
  - [`String#keyify`](https://github.com/forgecrafted/finishing_moves/wiki/String#stringkeyify)
  - [`String#match?`](https://github.com/forgecrafted/finishing_moves/wiki/String#stringmatch)
  - [`String#nl2br`](https://github.com/forgecrafted/finishing_moves/wiki/String#stringnl2br)
  - [`String#remove_whitespace`](https://github.com/forgecrafted/finishing_moves/wiki/String#stringremove_whitespace)
  - [`String#strip_all`](https://github.com/forgecrafted/finishing_moves/wiki/String#stringstrip_all) :boom:


  - [Fiscal Calendar Calculations](https://github.com/forgecrafted/finishing_moves/wiki/Fiscal-Calendar-Calculations) :boom:
  - [Boolean Typecasting](https://github.com/forgecrafted/finishing_moves/wiki/Boolean-Typecasting)

## Development approach

- **Never** override default Ruby behavior, only add functionality.
- Follow the Unix philosophy of *"Do one job really well."*
- Minimize assumptions, e.g. avoid formatting output, mutating values, and conditional logic flows.
- Play nice with major Ruby players like Rake, Rails, and Sinatra.
- Never duplicate existing methods from Rails and the like.
- Test all the things.

## Bug Reports

[Drop us a line in the issues section](https://github.com/forgecrafted/finishing_moves/issues).

**Be sure to include sample code that reproduces the problem.**

## Add your own finisher!

1. Fork this repo
2. Write your tests
3. Add your finisher
4. Repeat steps 2 and 3 until you see a brilliant luster
5. Submit a pull request

## Credits

[![forge software](http://www.forgecrafted.com/logo.png)](http://www.forgecrafted.com)

Finishing Moves is maintained and funded by [Forge Software (forgecrafted.com)](http://www.forgecrafted.com)

If you like our code, please give us a hollar if your company needs outside pro's who can write good code AND run servers at the same time!

## License

Finishing Moves is Copyright Forge Software, LLC. It is free software, and may be redistributed under the terms specified in the LICENSE file.
