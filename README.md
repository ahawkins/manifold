# Manifold

Mainfold: A generous CORS implementation designed for public APIs.

Use this if you don't care about CORS problems and never want to see
them again.

Don't use this if you have more complex CORS policies.

## Background

CORS is a bitch. It's annoying when you just want to develop your
application. You need to GET/POST/PUT/DELETE to some api in a browser
but it's stopping you. Drop this rack middleware into your stack and
make that it work.

## How It Works

* Handles simple CORS and preflight CORS requests.
* `Access-Control-Accept-Origin: *`.
* Echo's back `Access-Control-Request-Method` for
  `Access-Control-Allow-Method` for preflight requests.
* Echo's back `Access-Control-Request-Headers` for
  `Access-Control-Allow-Headers` for preflight requests.
* Makes preflight requests cachcable.
* Configurable options for `Access-Control-Expose-Headers`.
* Configurable options for `Access-Control-Accept-Headers`.
* Add `Access-Control-Accept-Origin: *` to simple requests.

## Preflight Requests

CORS preflight requests are sent as OPTIONS requests to whatever URL the
request will made to. Browsers add `Access-Control-Request-Method` and
`Access-Control-Request-Headers`to these requests. The middleware short
circuit these reqeusts to return the CORS response. So be warned: **If
your application accepts `OPTIONS` for routing then you should not use
this code.**

## Installation

Add this line to your application's Gemfile:

    gem 'manifold'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install manifold

## Usage

```ruby
# config.ru
require 'manifold'

Manifold.expose =+ %w(X-Custom-Header)

use Manifold::Middleware
run MyApp
```

## Rails

Manifold integrates cleanly with Rails. It inserts it's middleware at
the top of the stack and exposes it's configuration through
`Rails.config`. Manifold also add exposes headers added by Rails for
CORS.

```ruby
# application.rb
config.manifold.accept =+ %w(X-Custom-Input-Header) # add custom headers you need
config.manifold.expose =+ %(X-Custom-Output-Header)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
