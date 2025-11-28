# EmailHunter

A lightweight Ruby wrapper around [Hunter.io](https://hunter.io/) (formerly Email Hunter) API, providing direct access to email search, verification, and company insights.

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

**Core APIs:**

1. **Domain Search API** - Retrieve all email addresses associated with a domain
2. **Email Verification API** - Check the deliverability of an email address
3. **Email Finder API** - Find the most likely email using name and domain
4. **Count API** - Get the number of email addresses for a domain (FREE)
5. **Account Information API** - Retrieve details about your Hunter account
6. **Company Information API** - Get company details using a domain name
7. **People Search API** - Find key individuals associated with a company

---

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

### 7. Discover API (New in v2.0.0)

Search for companies using natural language queries.

```ruby
result = email_hunter.discover('US-based Software companies', limit: 10)
```

#### Response Fields:

```ruby
result.data  # Array of companies
result.meta.fetch(:results)
result.meta.fetch(:limit)
result.meta.fetch(:offset)
```

### 8. Leads Management API (New in v2.0.0)

Manage your leads stored in Hunter.

#### List Leads:

```ruby
result = email_hunter.leads(limit: 20, offset: 0)
```

#### Create Lead:

```ruby
lead_data = {
  email: 'john@example.com',
  first_name: 'John',
  last_name: 'Doe',
  company: 'Example Inc',
  position: 'CEO'
}
result = email_hunter.lead_create(lead_data)
```

#### Update Lead:

```ruby
update_data = { position: 'CTO' }
result = email_hunter.lead_update(lead_id, update_data)
```

#### Delete Lead:

```ruby
success = email_hunter.lead_delete(lead_id)
```

#### Response Fields:

```ruby
result.data.leads  # Array of lead objects
result.data.leads.first.email
result.data.leads.first.company
result.meta.fetch(:count)
```

### 9. Campaigns Management API (New in v2.0.0)

Manage your email campaigns and recipients.

#### List Campaigns:

```ruby
result = email_hunter.campaigns(limit: 20)
```

#### Get Campaign Recipients:

```ruby
result = email_hunter.campaign_recipients(campaign_id, limit: 20)
```

#### Add Recipient to Campaign:

```ruby
recipient_data = {
  email: 'john@example.com',
  first_name: 'John',
  last_name: 'Doe'
}
result = email_hunter.campaign_add_recipient(campaign_id, recipient_data)
```

#### Remove Recipient from Campaign:

```ruby
success = email_hunter.campaign_delete_recipient(campaign_id, 'john@example.com')
```

#### Response Fields:

```ruby
result.data.campaigns  # Array of campaign objects
result.data.recipients  # Array of recipient objects
result.meta.fetch(:limit)
```

### 10. Lead Enrichment API (New in v2.0.0)

Enrich person data with 100+ attributes using email or LinkedIn.

```ruby
# Using email
result = email_hunter.lead_enrichment(email: 'matt@hunter.io')

# Using LinkedIn
result = email_hunter.lead_enrichment(linkedin: 'matttharp')
```

#### Response Fields:

```ruby
result.data.name.fullName
result.data.email
result.data.location
result.data.timeZone
result.data.employment.domain
result.data.employment.title
result.data.employment.name
result.data.twitter.handle
result.data.linkedin.handle
result.meta.fetch(:email)
```

### 11. Company Enrichment API (New in v2.0.0)

Enrich company data with detailed firmographic information.

```ruby
result = email_hunter.company_enrichment('stripe.com')
```

#### Response Fields:

```ruby
result.data.name
result.data.description
result.data.foundedYear
result.data.location
result.data.category.industry
result.data.metrics.employees
result.data.tech  # Array of technologies used
result.data.site.emailAddresses
result.meta.fetch(:domain)
```

### 12. Combined Enrichment API (New in v2.0.0)

Get both lead and company data in a single call.

```ruby
result = email_hunter.combined_enrichment(email: 'patrick@stripe.com')
```

#### Response Fields:

```ruby
result.lead.data  # Lead enrichment data
result.company.data  # Company enrichment data
result.meta.email
result.meta.domain
```

### 13. Account Information API

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
