# Finishing Moves
[![Gem Version](https://badge.fury.io/rb/finishing_moves.svg)](https://rubygems.org/gems/finishing_moves)
[![Build Status](https://travis-ci.org/forgecrafted/finishing_moves.svg?branch=master)](https://travis-ci.org/forgecrafted/finishing_moves)
[![Mentioned in Awesome Ruby](https://awesome.re/mentioned-badge.svg)](https://github.com/markets/awesome-ruby)

Ruby includes a huge amount of default awesomeness that tackles most common development challenges. But every now and then, you find yourself performing contortions to achieve results that, honestly, **should feel more natural** given the language's design elegance. Finishing Moves is a collection of methods designed to assist in those "why is this awkward?" scenarios.

In the right situation, they kick serious [cyclomatic butt](https://en.wikipedia.org/wiki/Cyclomatic_complexity).

## Installation

Gemfile
```
gem 'finishing_moves'
```

Command line
```
gem install 'finishing_moves'
```

## Documentation

**Not sure if this gem is for you?** Check out the methods marked with a :boom: first.

  - [`Array#to_hash_values`](https://github.com/BattleBrisket/finishing_moves/wiki/Array#arrayto_hash_values) :boom:
  - [`Array#to_indexed_hash`](https://github.com/BattleBrisket/finishing_moves/wiki/Array#arrayto_indexed_hash)
  - [`Array#to_hash_keys`](https://github.com/BattleBrisket/finishing_moves/wiki/Array#arrayto_hash_keys)
  - [`Array#to_sym_strict`](https://github.com/BattleBrisket/finishing_moves/wiki/Array#arrayto_sym_strict)
  - [`Array#to_sym_loose`](https://github.com/BattleBrisket/finishing_moves/wiki/Array#arrayto_sym_loose)
  - [`Enumerable#key_map`](https://github.com/BattleBrisket/finishing_moves/wiki/Enumerable#enumerablekey_map) :boom:
  - [`Enumerable#key_map_reduce`](https://github.com/BattleBrisket/finishing_moves/wiki/Enumerable#enumerablekey_map_reduce)
  - [`Hash#delete!`](https://github.com/BattleBrisket/finishing_moves/wiki/Hash#hashdelete)
  - [`Hash#delete_each`](https://github.com/BattleBrisket/finishing_moves/wiki/Hash#hashdelete_each)
  - [`Hash#delete_each!`](https://github.com/BattleBrisket/finishing_moves/wiki/Hash#hashdelete_each-1)
  - [`Integer#length`](https://github.com/BattleBrisket/finishing_moves/wiki/Numeric#integerlength)
  - [`Kernel#nil_chain`](https://github.com/BattleBrisket/finishing_moves/wiki/Kernel#kernelnil_chain) :boom::boom:
  - [`Kernel#bool_chain`](https://github.com/BattleBrisket/finishing_moves/wiki/Kernel#kernelbool_chain)
  - [`Kernel#silently`](https://github.com/BattleBrisket/finishing_moves/wiki/Kernel#kernelsilently)
  - [`Kernel#cascade`](https://github.com/BattleBrisket/finishing_moves/wiki/Kernel#kernelcascade)
  - [`Kernel#class_exists?`](https://github.com/BattleBrisket/finishing_moves/wiki/Kernel#kernelclass_exists)
  - [`Numeric#add_percent`](https://github.com/BattleBrisket/finishing_moves/wiki/Numeric#numericadd_percent)
  - [`Numeric#subtract_percent`](https://github.com/BattleBrisket/finishing_moves/wiki/Numeric#numericsubtract_percent)
  - [`Object#same_as`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objectsame_as)
  - [`Object#not_nil?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objectnot_nil)
  - [`Object#numeric?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objectnumeric) :boom:
  - [`Object#is_an?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objectis_an)
  - [`Object#is_not_a?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objectis_not_a)
  - [`Object#is_one_of?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objectis_one_of) :boom:
  - [`Object#true?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objecttruefalsebool)
  - [`Object#false?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objecttruefalsebool)
  - [`Object#bool?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objecttruefalsebool)
  - [`Object#true_?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objecttrue_-objectfalse_)
  - [`Object#false_?`](https://github.com/BattleBrisket/finishing_moves/wiki/Object#objecttrue_-objectfalse_)
  - [`String#dedupe`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringdedupe)
  - [`String#keyify`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringkeyify)
  - [`String#slugify`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringslugify)
  - [`String#nl2br`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringnl2br)
  - [`String#newline_to`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringnewline_to)
  - [`String#remove_whitespace`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringremove_whitespace)
  - [`String#replace_whitespace`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringreplace_whitespace)
  - [`String#strip_all`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringstrip_all) :boom:
  - [`String#to_uuid`](https://github.com/BattleBrisket/finishing_moves/wiki/String#stringto_uuid)
  - [Boolean Typecasting](https://github.com/BattleBrisket/finishing_moves/wiki/Boolean-Typecasting) (*multi-class enhancement*)

### Ruby Version

Tested against all supported versions of official RVM, currently **`3.1` and above**.

## Development approach

- **Never** override default Ruby behavior, only add functionality.
- Follow the Unix philosophy of *"Do one job really well."*
- Minimize assumptions, e.g. avoid formatting output, mutating values, and conditional logic flows.
- Play nice with major Ruby players like Rake, Rails, and Sinatra.
- Test all the things.

## Bug Reports

[Drop us a line in the issues section](https://github.com/BattleBrisket/finishing_moves/issues).

**Be sure to include sample code that reproduces the problem.**

## Add your own finisher!

1. Fork this repo
2. Write your tests
3. Add your finisher
4. Repeat steps 2 and 3 until you see a brilliant luster
5. Submit a pull request
