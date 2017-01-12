# Emailhunter

A tiny ruby wrapper around Hunter (former Email Hunter) API. Direct access to all the web's email addresses.

UPDATE (2016-12-02): gem updated with V2 API.

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
result.fetch(:meta)
result.fetch(:webmail)
result.fetch(:emails)
result.fetch(:pattern)
result.fetch(:domain)
```
## Email Verify API
Allows you to verify the deliverability of an email address.
```ruby
email_hunter.verify('bonjour@firmapi.com')
```

## Accessing email verify response
```ruby
result.fetch(:result)
result.fetch(:score)
result.fetch(:regexp)
result.fetch(:gibberish)
result.fetch(:disposable)
result.fetch(:mx_records)
result.fetch(:smtp_server)
result.fetch(:smtp_check)
result.fetch(:accept_all)
result.fetch(:sources)
result.fetch(:meta)

```

## Email Exist API (only for V1)
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

## Finder API (legacy generate)
Guesses the most likely email of a person from his first name, his last name and a domain name.
```ruby
email_hunter.finder('gmail.com', 'Davide', 'Santangelo')
```
## Accessing finder response
```ruby
result.fetch(:email)
result.fetch(:score)
result.fetch(:sources)
result.fetch(:domain)
result.fetch(:meta)
```

## Count API
Returns the number of email addresses found for a domain. This is a FREE API call.
```ruby
email_hunter.count('gmail.com')
```

## Accessing count response
```ruby
result.fetch(:data)
result.fetch(:meta)
```

## License
The emailhunter GEM is released under the MIT License.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/emailhunter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
