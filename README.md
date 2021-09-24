# YubicoClient

Ruby client library for YubiKey.

## OTP

Verify Yubico OTPs with YubiCloud. This works as a library for https://developers.yubico.com/OTP/Libraries/Using_a_library.html

The most simple way is to use `.valid?` shortcut - it just verify OTP
```ruby
YubicoClient::OTP.valid?("vvvvvvcurikvhjcvnlnbecbkubjvuittbifhndhn", client_id: "12345", secret: "c2VjcmV0Cg=") # => true / false
```

`client_id` and `secret` is required and should be obtained from https://upgrade.yubico.com/getapikey/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yubico_client'
```

And then execute:

    $ bundle install

Or:

    $ bundle add yubico_client

Or install it yourself as:

    $ gem install yubico_client


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/luk4s/yubico_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/luk4s/yubico_client/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YubicoClient project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/luk4s/yubico_client/blob/master/CODE_OF_CONDUCT.md).
