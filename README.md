# Emailhunter

A tiny ruby wrapper around Email Hunter API 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emailhunter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emailhunter

## Usage

```ruby
require 'emailhunter'
email = EmailHunter.new('your api key')

```

## Domain search API
```ruby
result = email.search('stripe.com')
```

## Accessing domain search response
```ruby
result.status
result.results
result.emails
```


## Email check API
```ruby
email.exist('bonjour@firmapi.com')
```

## Accessing email check response
```ruby
result.status
result.email
result.exist
result.sources
```



## Contributing

1. Fork it ( https://github.com/[my-github-username]/emailhunter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
