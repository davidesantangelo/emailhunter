# Emailhunter

A tiny ruby wrapper around Email Hunter API. Direct access to all the web's email addresses.


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
email_hunter = EmailHunter.new('Your secret API key')

```
Your secret API key. You can generate it in your dashboard from https://emailhunter.co

## Domain search API
Returns all the email addresses found using one given domain name, with our sources.
```ruby
result = email_hunter.search('stripe.com')
```

## Accessing domain search response
```ruby
result.status
result.results
result.webmail
result.emails
result.offset
```
## Email Verify API
Allows you to verify the deliverability of an email address.
```ruby
email_hunter.verify('bonjour@firmapi.com')
```

## Accessing email verify response
```ruby
result.status
result.email
result.score
result.regexp
result.gibberish
result.disposable
result.webmail
result.mx_records
result.smtp_server
result.smtp_check
result.accept_all
result.sources
```

## Email Exist API
This API call is deprecated, please use the email verification call instead.


This API endpoint allows you to check if a given email address has been found on the web. If it has been found, it returns all the sources with the dates of the last crawls.

```ruby
email_hunter.exist('bonjour@firmapi.com')
```

## Accessing email verify response
```ruby
result.status
result.email
result.exist
result.sources
```

## Generate API
Guesses the most likely email of a person from his first name, his last name and a domain name.
```ruby
email_hunter.generate('gmail.com', 'Davide', 'Santangelo')
```

## Accessing generate response
```ruby
result.status
result.email
result.score

## Count API
Returns the number of email addresses found for a domain. 
_*This is a free API call*_
```ruby
email_hunter.count('gmail.com')
```

## Accessing count response
```ruby
result.status
result.count
```

## License
The emailhunter GEM is released under the MIT License.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/emailhunter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
