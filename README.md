Rake DNX
========

[![Build Status](https://travis-ci.org/beraboris/rake-dnx.svg?branch=master)](https://travis-ci.org/beraboris/rake-dnx)

Rake DNX is a set of helpers that allow you to discover and run all the DNX
(.NET Execution Envrionment) commands and tasks all from one place. Rake DNX
leverages the power of [Ruby](https://www.ruby-lang.org/en/) and
[Rake](http://rake.rubyforge.org/) (Ruby's task runner).

Why?
----

[DNX](http://docs.asp.net/en/latest/dnx/index.html) is Microsoft's solution to
the poor state of .NET build tooling. By all means it's great. It know about the
.NET languages and it know about NuGet. You just tell it what you want and it
builds it all for you.

It only has two issues:

1. When you're dealing with multiple projects it's hard to run a command on all
    projects. You have to pass the project name to the `dnx` command.
1. There is no mechanism for defining commands for the whole solution and not
    for a specific project.

Rake DNX aims to solve these issues.

Getting started
---------------

TODO: explain how to add Rake DNX to an existing DNX project

Contributing
------------

Bug reports and pull requests are welcome on GitHub at
https://github.com/beraboris/rake-dnx.

TODO: Write a `CONTRIBUTING.md` file with development details.

License
-------

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
