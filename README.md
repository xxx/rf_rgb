# RfRgb

### What it is
Some code to allow for interacting with Topre Realforce RGB keyboards. The software provided by
the manufacturer only supports Windows.

### What it isn't
This isn't intended to be a full replacement for the Realforce software - just some basic classes that can
be used as building blocks.

## Requirements
1. Ruby 2.3+. Earlier versions of Ruby may work, but are not supported.
1. [libusb](http://libusb.info) 1.0.0 or greater. The old version 0.1 is not supported.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'rf_rgb'
```

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install rf_rgb

## Usage

```ruby
require 'rf_rgb'

keyboard = nil
begin
 # .new without an arg will automatically find and initialize the first Realforce RGB keyboard it finds.
 # Keyboard cannot be used at this point, as it's owned by this program until .release_to_os is called.
  keyboard = RfRgb::Keyboard.new
  
  keyboard.effect_rainbow_wave
  # keyboard.effect_shooting_star("ff00ff", RfRgb::Protocol::INTERVAL_6)
  # keyboard.effect_pressed_key("aaeeff")
  # keyboard.disable_effect
  keyboard.brightness = RfRgb::Protocol::BRIGHTNESS_LOW
  keyboard.actuation_height = RfRgb::Protocol::HEIGHT_22
  keyboard.swap_caps_ctrl
  keyboard.save
ensure
  keyboard&.release_to_os
end
```

OR

```ruby
require 'rf_rgb'

RfRgb::Keyboard.run_and_release do |keyboard|
  keyboard.effect_rainbow_wave
  keyboard.brightness = RfRgb::Protocol::BRIGHTNESS_LOW
  keyboard.actuation_height = RfRgb::Protocol::HEIGHT_22
  keyboard.swap_caps_ctrl
  keyboard.save
end
```

Additional examples can be found in the `examples` directory.

See `lib/rf_rgb/keyboard.rb` for effects and arguments, and
`lib/rf_rgb/protocol.rb` for any needed constants.

On Ubuntu Linux at least, some udev configuration was necessary to be able to run as a non-root user,
and prevent `usbhid` from taking the device over. If you're in that boat, try this:

1. create `/etc/udev/rules.d/99-topre.rules` with the following content:
    ```
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0853", ATTRS{idProduct}=="013a", MODE="0666", GROUP="plugdev"
    ATTRS{idVendor}=="0853", ATTRS{idProduct}=="013a", RUN="/bin/sh -c 'echo -n $kernel >/sys/bus/usb/drivers/usbhid/unbind'"
    ```
1. Add your user to the `plugdev` group: `sudo usermod -a -G plugdev $USER`
1. (Probably) log out and back in, so the new group is applied to your user
1. Unplug and re-plug the keyboard into a USB slot.

## Protocol Notes

Some effects have a User 1-3 setting in the Windows UI. It's not clear what these
are actually for, and are mostly ignored in this module for now.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xxx/rf_rgb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
