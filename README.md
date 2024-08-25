# trackstamps-reborn

[![Gem Version](https://badge.fury.io/rb/trackstamps-reborn.svg)](https://rubygems.org/gems/trackstamps-reborn)
[![Test](https://github.com/uvera/trackstamps-reborn/actions/workflows/test.yml/badge.svg)](https://github.com/uvera/trackstamps-reborn/actions/workflows/test.yml)

Track which user created or updated record in Rails.

Inspired and part of code used from original [Trackstamps](https://github.com/mshahzadtariq/trackstamps) gem

---

- [Quick start](#quick-start)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Quick start

```
$ bundler install trackstamps-reborn
```

### Hook current_user into CurrentAttributes

```ruby
class ApplicationController < ActionController::Base
  before_action :set_trackstamps_user  

  def set_trackstamps_user
    Trackstamps::Reborn::Current.user = current_user
    # or use your current attributes class with proc override in initializers
    YourCurrentAttributesClass.user = current_user
  end
end
```

### Override implementation for current user

```ruby
## filename: config/initializers/trackstamps-reborn.rb
Trackstamps::Reborn.config.get_current_user = -> { YourCurrentAttributesClass.user }
# or
Trackstamps::Reborn[:alternative].config.get_current_user = -> { YourAlternativeCurrentAttributesClass.user }
```

### Generate migrations
```
rails generate trackstamps:reborn:migration table_name
```

## Include trackstamps
```ruby
class Example < ActiveRecord::Base
  include Trackstamps::Reborn
  # or
  include Trackstamps::Reborn[:whatever]
end
```

## Multiple configuration

Multiple configuration is achieved with module builder pattern utilizing `self.[]` method.
Upon calling

```ruby
Trackstamps::Reborn[:whatever]
```

specific module is cached in `::Concurrent::Map` instance.

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/uvera/trackstamps-reborn/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
