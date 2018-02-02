# README

This repo holds the source of the
[Ferro website](https://easydatawarehousing.github.io/ferro/).
Ferro is demonstration of the abilities and use of the
[opal-ferro ruby gem](https://github.com/easydatawarehousing/opal-ferro).
This website is based on Rails 5.1 with some added scripts to create
a static website that can be hosted on github pages.

## Preparing

Clone this repo, and use bundler to get dependencies:

    bundle install

Run development website

    export RAILS_ENV=development
    rails s

Then visit http://localhost:3000

## Publishing

    export RAILS_ENV=production
    rails content:build_and_gh_publish

And follow the instruction given by this rake task.

## Licenses
Copyright (C) 2017-2018 Ivo Herweijer

All textual content and images (/content, /public and /docs folders) 
are copyrighted material. No permission is given to publish these in any way.

On all other files (code and setup) the MIT License applies.

_The MIT License_

_Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:_

_The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software._

_THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE._
