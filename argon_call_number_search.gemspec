lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argon_call_number_search/version'

Gem::Specification.new do |spec|
  spec.name          = 'argon_call_number_search'
  spec.version       = ArgonCallNumberSearch::VERSION
  spec.authors       = ['Cory Lown']
  spec.email         = ['cory.lown@duke.edu']

  spec.summary       = 'A Blacklight SearchBuilder method that adds support to TRLN Argon for call number and accession number searching.'
  spec.description   = 'A Blacklight SearchBuilder method that adds support to TRLN Argon for call number and accession number searching.'
  spec.homepage      = 'https://github.com/trln/argon_call_number_search/'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/trln/argon_call_number_search/releases'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split('\x0').reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'trln_argon', '~> 1.0'
  spec.add_dependency 'lcsort'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
