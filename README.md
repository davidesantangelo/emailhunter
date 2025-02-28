# EmailHunter

A lightweight Ruby wrapper around Hunter (formerly Email Hunter) API, providing direct access to email search, verification, and company insights.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emailhunter'
```

Then execute:

```sh
$ bundle install
```

Or install it yourself with:

```sh
$ gem install emailhunter
```

## Usage

```ruby
require 'emailhunter'
email_hunter = EmailHunter.new('Your API Key')
```

Your API key can be generated in your [Hunter dashboard](https://hunter.io).

## Features

### 1. Domain Search API
Retrieve all email addresses associated with a given domain.

```ruby
result = email_hunter.search('stripe.com')
```

#### Response Fields:
```ruby
result.fetch(:meta)
result.fetch(:webmail)
result.fetch(:emails)
result.fetch(:pattern)
result.fetch(:domain)
```

### 2. Email Verification API
Check the deliverability of an email address.

```ruby
result = email_hunter.verify('bonjour@firmapi.com')
```

#### Response Fields:
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

### 3. Email Finder API
Guess the most likely email of a person using their first name, last name, and domain.

```ruby
result = email_hunter.finder('gmail.com', 'Davide', 'Santangelo')
```

#### Response Fields:
```ruby
result.fetch(:email)
result.fetch(:score)
result.fetch(:sources)
result.fetch(:domain)
result.fetch(:meta)
```

### 4. Count API
Retrieve the number of email addresses associated with a domain (FREE API call).

```ruby
result = email_hunter.count('gmail.com')
```

#### Response Fields:
```ruby
result.fetch(:data)
result.fetch(:meta)
```

### 5. Company Information API (New Feature)
Retrieve company details using a domain name.

```ruby
result = email_hunter.company('stripe.com')
```

#### Response Fields:
```ruby
result.fetch(:name)
result.fetch(:industry)
result.fetch(:employees)
result.fetch(:country)
result.fetch(:meta)
```

### 6. People Search API (New Feature)
Retrieve key individuals associated with a company based on a domain name.

```ruby
result = email_hunter.people('stripe.com')
```

#### Response Fields:
```ruby
result.fetch(:employees)
result.fetch(:position)
result.fetch(:email)
result.fetch(:meta)
```

### 7. Account Information API
Retrieve details about your Hunter account.

```ruby
result = email_hunter.account
```

#### Response Example:
```json
{
   "data": {
      "first_name": "Davide",
      "last_name": "Santangelo",
      "email": "davide.santangelo@gmail.com",
      "plan_name": "Free",
      "plan_level": 0,
      "reset_date": "2025-06-29",
      "team_id": 349,
      "calls": {
         "used": 4,
         "available": 50
      }
   }
}
```

## License

The EmailHunter gem is released under the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

1. Fork it ( https://github.com/[your-github-username]/emailhunter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

