# ArgonCallNumberSearch

This adds a Blacklight SearchBuilder method to TrlnArgon to support searching of LC Call Numbers and acccession numbers (e.g. CD 1234).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'argon_call_number_search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install argon_call_number_search

## Usage

Once installed in your Argon app some setup is required to enable call number searching.

In `app/models/search_builder.rb` add `include ArgonCallNumberSearch::SearchBuilderBehavior` and add the `add_call_number_query_to_solr` method to the default processor chain.

For example:

```
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include ArgonCallNumberSearch::SearchBuilderBehavior

  self.default_processor_chain += %i[add_call_number_query_to_solr]
end
```

Then, in `app/controllers/catalog_controller.rb` add `call_number` to the configured search fields.

For example:

```
class CatalogController < ApplicationController
  include Blacklight::Catalog
  include TrlnArgon::ControllerOverride

  configure_blacklight do |config|
    # OTHER CODE

    config.add_search_field('call_number') do |field|
      field.label = I18n.t('trln_argon.search_fields.call_number')
      field.advanced_parse = false
      field.include_in_advanced_search = false
    end

    # OTHER CODE
  end
end
```

If you want to modify the regular expressions used to forgive accession number searches with and without spaces you can set these as strings in an initializer in a configuration block.

For example:

```
# Default regex values shown
ArgonCallNumberSearch.configure do |config|
  config.acc_num_without_space = '^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)([A-Z\d]+)'
  config.acc_num_with_space = '^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)(\s+)([A-Z\d]+)'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trln/argon_call_number_search.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
