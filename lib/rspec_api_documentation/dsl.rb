require "rspec_api_documentation"
require "rspec_api_documentation/dsl/resource"
require "rspec_api_documentation/dsl/endpoint"
require "rspec_api_documentation/dsl/callback"


module RspecApiDocumentation
  module DSL

    # Custom describe block that sets metadata to enable the rest of RAD
    #
    #   resource "Orders", :meta => :data do
    #     # ...
    #   end
    #
    # Params:
    # +args+:: Glob of RSpec's `describe` arguments
    # +block+:: Block to pass into describe
    #
    def resource(*args, &block)
      options = if args.last.is_a?(Hash) then args.pop else {} end
      options[:api_doc_dsl] = :resource
      options[:resource_name] = args.first
      options[:document] ||= :all
      args.push(options)
      describe(*args, &block)
    end
  end
end

RSpec::Core::ExampleGroup.extend(RspecApiDocumentation::DSL)
RSpec::Core::DSL.expose_example_group_alias(:resource)

RSpec.configuration.include RspecApiDocumentation::DSL::Resource, :api_doc_dsl => :resource
RSpec.configuration.include RspecApiDocumentation::DSL::Endpoint, :api_doc_dsl => :endpoint
RSpec.configuration.include RspecApiDocumentation::DSL::Callback, :api_doc_dsl => :callback
RSpec.configuration.backtrace_exclusion_patterns << %r{lib/rspec_api_documentation/dsl/}
