# ArgonCallNumberSearch

This adds a Blacklight SearchBuilder method to TrlnArgon to support searching of LC Call Numbers and acccession numbers (e.g. CD 1234).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'argon_call_number_search', git: 'https://github.com/trln/argon_call_number_search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install argon_call_number_search

## Usage

Once installed in your Argon app some setup is required to enable call number searching.

In `app/models/search_builder.rb` add `include ArgonCallNumberSearch::SearchBuilderBehavior` and add the `add_call_number_query_to_solr` method to the default processor chain, 
after `add_advanced_search_to_solr` if using Blacklight's `AdvancedSearchBuilder`.

For example:

```
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include ArgonCallNumberSearch::SearchBuilderBehavior

  self.default_processor_chain += %i[add_advanced_search_to_solr
                                     add_call_number_query_to_solr]
end
```

Then, in `app/controllers/catalog_controller.rb` add `call_number` to the configured search fields.

For example:

```
class CatalogController < ApplicationController
  include Blacklight::Catalog
  include TrlnArgon::ControllerOverride

  configure_blacklight do |config|
    # SNIP

    config.add_search_field('call_number') do |field|
      field.label = I18n.t('trln_argon.search_fields.call_number')
      field.advanced_parse = false
    end

    # SNIP
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

**IMPORTANT: Solr fields required to support call number search.**

Your records in the trlnbib Solr index must have certain fields stored and/or indexed to support call number and accession number searching. This will require modifications to item processing in marc-to-argot.

Fields that support call number searching:

* `lc_call_nos_normed` -- supports multi-valued LC call number searching ("bound with")
* `shelf_numbers` -- supports accession number searching ("CD 12345")
* `shelfkey` -- supports basic, single valued LC Call Number searching (field is intended to support call number *browse* but will generally work for call number *search* with the exception of "bound with" call numbers).

Your records will likely already be populated with the single valued field `shelfkey` that contains normalized LC Call Numbers. This is a single valued field intended for call number *browse*. It will provide basic LC call number searching functionality but will not support things like "bound with" call number searching. You can safely have both the `shelfkey` and the multi-valued `lc_call_nos_normed` in your records and this gem will search both fields.

Basic example of marc-to-argot item processing to add fields needed for call number searching:

```

def extract_items

  # SNIP #

  lambda do |rec, acc, ctx|
    # SNIP #
    shelf_numbers = []
    lc_call_nos_normed = []

    Traject::MarcExtractor.cached('940', alternate_script: false)
                          .each_matching_line(rec) do |field, spec, extractor|

      # SNIP #

      # Add all normalized LC Call Nos to lc_call_nos_normed field
      # for searching.
      # And add all shelving control numbers
      # to shelf_numbers for searching.
      case item.fetch('cn_scheme', '')
      when '0'
        lc_call_nos_normed << Lcsort.normalize(item.fetch('call_no', '').strip)
      when '4'
        shelf_numbers << item.fetch('call_no', '').strip
      end
    end

    # SNIP #

    ctx.output_hash['shelf_numbers'] = shelf_numbers.uniq.compact if shelf_numbers.any?
    ctx.output_hash['lc_call_nos_normed'] = lc_call_nos_normed.uniq.compact if lc_call_nos_normed.any?

    # SNIP #

  end
end

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trln/argon_call_number_search.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
