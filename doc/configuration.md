# Configuration

Configuration is an important part of any system. We utilize configuration not
just to boot the application, but also to define source and destinations based
on a transfer request's parameters.

## Implementation

We utilize [configsl], which provides a simple DSL (Domain Specific Language)
to define configuration using classes. This allows us to define configuration
in a more declarative and human-readable way.

Configuration classes are defined in the `lib/config` directory. Each class
extends `DocumentTransfer::Config::Base` which provides some basic functionality
at instantiation.

To create a new configuration, create a new class that extends
`DocumentTransfer::Config::Base`, and use the configsl DSL to define your
options.

```ruby
class MyConfig < DocumentTransfer::Config::Base
  option :my_option, type: String, default: 'default value'
  option :required_option, type: Symbol, required: true, enum: [:a, :b, :c]

  # You can also define nested configuration.
  option :nested_config, type: MyNestedConfig, required: true
end
```

For more details on the syntax, see the [configsl] documentation.

To create a new instance of your configuration, you can instantiate it directly,
load it from environment variables, or read it from a file.

```ruby
config = MyConfig.new(my_option: 'value', required_option: :a, nested_config: { ... })
config = MyConfig.from_environment
config = MyConfig.from_file('path/to/file.yaml')
```

[configsl]: https://github.com/jamesiarmes/configsl
