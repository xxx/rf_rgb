module RfRgb
  module Protocol
    BRIGHTNESS_HIGH   = "\x00".freeze
    BRIGHTNESS_MEDIUM = "\x01".freeze
    BRIGHTNESS_LOW    = "\x02".freeze

    # Actuation heights
    HEIGHT_15 = "\x00".freeze
    HEIGHT_22 = "\x01".freeze
    HEIGHT_30 = "\x02".freeze

    # Only the Shooting Star effect uses these.
    INTERVAL_0 = "\x00".freeze # slowest, ~12 seconds
    INTERVAL_1 = "\x01".freeze
    INTERVAL_2 = "\x02".freeze
    INTERVAL_3 = "\x03".freeze
    INTERVAL_4 = "\x04".freeze
    INTERVAL_5 = "\x05".freeze
    INTERVAL_6 = "\x06".freeze
    INTERVAL_7 = "\x07".freeze
    INTERVAL_8 = "\x08".freeze
    INTERVAL_9 = "\x09".freeze # fastest, ~1 second

    # I'm not actually clear on the point of users, but here they are.
    USER_0 = "\x00".freeze
    USER_1 = "\x01".freeze
    USER_2 = "\x02".freeze
    USER_3 = "\x03".freeze

    def self.reset_effect
      "\xaa\xaa\x60".force_encoding(Encoding::BINARY).freeze
    end

    def self.save_changes
      "\xaa\xaa\x04".force_encoding(Encoding::BINARY).freeze
    end

    def self.pressed_key_lighting(rgb_hex, user = :user0)
      # byte number 6 (just before rgb) determines user. 0x00-0x03
      "\xaa\xaa\x62\x00\x04\x00#{rgb_hex}".force_encoding(Encoding::BINARY).freeze
    end

    # Backlight color can't be changed AFAICT. Always white.
    def self.pressed_key_lighting_with_backlight(rgb_hex, user = :user0)
      "\xaa\xaa\x63\x00\x04\x00#{rgb_hex}".force_encoding(Encoding::BINARY).freeze
    end

    def self.rainbow_wave
      "\xaa\xaa\x61".force_encoding(Encoding::BINARY).freeze
    end

    def self.shooting_star(rgb_hex, interval, user = USER_0)
      "\xaa\xaa\x64\x00\x05\x00#{interval}#{rgb_hex}".force_encoding(Encoding::BINARY).freeze
    end

    def self.demo_mode
      "\xaa\xaa\x66".force_encoding(Encoding::BINARY).freeze
    end

    def self.random_lights
      "\xaa\xaa\x67".force_encoding(Encoding::BINARY).freeze
    end

    def self.color_bar
      "\xaa\xaa\x68".force_encoding(Encoding::BINARY).freeze
    end

    def self.disable_effects
      "\xaa\xaa\x69".force_encoding(Encoding::BINARY).freeze
    end

    def self.key_lock
      "\xaa\xaa\x82\x00\x01\x01".force_encoding(Encoding::BINARY).freeze
    end

    def self.key_unlock
      "\xaa\xaa\x82\x00\x01\x00".force_encoding(Encoding::BINARY).freeze
    end

    def self.change_brightness(new_brightness)
      "\xaa\xaa\x42\x00\x01#{new_brightness}".force_encoding(Encoding::BINARY).freeze
    end

    def self.change_actuation_height_all(new_height)
      "\xaa\xaa\x20\x00\x01#{new_height}".force_encoding(Encoding::BINARY).freeze
    end

    def self.swap_caps_ctrl
      "\xaa\xaa\x84\x00\x01\x01".force_encoding(Encoding::BINARY).freeze
    end

    def self.unswap_caps_ctrl
      "\xaa\xaa\x84\x00\x01\x00".force_encoding(Encoding::BINARY).freeze
    end
  end
end