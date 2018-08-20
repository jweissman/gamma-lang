# gamma-lang

* [Homepage](https://rubygems.org/gems/gamma-lang)
* [Documentation](http://rubydoc.info/gems/gamma-lang/frames)
* [Email](mailto:jweissman1986 at gmail.com)

[![Code Climate GPA](https://codeclimate.com/github/jweissman/gamma-lang/badges/gpa.svg)](https://codeclimate.com/github/jweissman/gamma-lang)
[![Coverage Status](https://coveralls.io/repos/github/jweissman/gamma-lang/badge.svg)](https://coveralls.io/github/jweissman/gamma-lang)

## Description

A tiny language I'm learning to build!

## Features

  - [x] Arithmetic (`*/+-`)
  - [x] Variables (Assignment with `=`)
  - [x] Builtin and (Simple) User-defined Functions
  - [ ] Multi-line UDFs
  - [ ] Collections (Lists, Hashes)
  - [ ] Modules

## Command-line Usage

The `gamma` command-line helper has a few tools already
built-in:

  - `exec`: Run a `.gamma` file
  - `iggy`: Interact with Gamma
  - `server`: Run the Gamma app server

## Examples

You can invoke the Gamma evaluator in Ruby code directly:

    require 'gamma/lang'

    str = 'a=3; b=4; a*b'
    Gamma::Lang.evaluate(str) # => Result[GInt[7], '_ is now 7']

## Development

A `gamma-dev` tool is in `bin/` that spins up the Gamma app server
and keeps it in sync with the latest code changes.

## Requirements

  - Ruby 2.5.x

## Install

    $ gem install gamma-lang

## Synopsis

    $ cat "puts(1,2,3)" > hello.gamma
    $ gamma exec hello.gamma

    1
    2
    3

## Copyright

Copyright (c) 2018 Joseph Weissman

See LICENSE.txt for details.
