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

    def self.user_specified_colors(mapping, user = USER_1)
      m = lambda { |sym| color_transform(mapping[sym]) || color_transform(mapping[:default]) || "\x00\x00\x00" }

      [
        "\xaa\xaa\x40\x41\x3a#{user}\x00\x00\x00#{m[:grave]}#{m[:one]}#{m[:two]}#{m[:three]}#{m[:four]}#{m[:five]}#{m[:six]}#{m[:seven]}#{m[:eight]}#{m[:nine]}#{m[:zero]}#{m[:hyphen]}#{m[:equals]}\x00\x00\x00#{m[:backspace]}#{m[:tab]}#{m[:q]}#{m[:w]}\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x40\x82\x3a#{user}#{m[:e]}#{m[:r]}#{m[:t]}#{m[:y]}#{m[:u]}#{m[:i]}#{m[:o]}#{m[:p]}#{m[:lbracket]}#{m[:rbracket]}#{m[:backslash]}#{m[:capslock]}#{m[:a]}#{m[:s]}#{m[:d]}#{m[:f]}#{m[:g]}#{m[:h]}#{m[:j]}\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x40\x83\x3a#{user}#{m[:k]}#{m[:l]}#{m[:semicolon]}#{m[:apostrophe]}\x00\x00\x00#{m[:enter]}#{m[:lshift]}\x00\x00\x00#{m[:z]}#{m[:x]}#{m[:c]}#{m[:v]}#{m[:b]}#{m[:n]}#{m[:m]}#{m[:comma]}#{m[:period]}#{m[:slash]}\x00\x00\x00\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x40\x84\x3a#{user}#{m[:rshift]}#{m[:lctrl]}\x00\x00\x00#{m[:lalt]}#{m[:space]}#{m[:ralt]}\x00\x00\x00#{m[:rctrl]}\x00\x00\x00\x00\x00\x00\x00\x00\x00#{m[:lwin]}#{m[:rwin]}#{m[:fn]}#{m[:mute]}#{m[:voldown]}#{m[:volup]}#{m[:actuation]}#{m[:ins]}\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x40\x85\x3a#{user}#{m[:del]}\x00\x00\x00\x00\x00\x00#{m[:left]}#{m[:home]}#{m[:end]}\x00\x00\x00#{m[:up]}#{m[:down]}#{m[:pgup]}#{m[:pgdn]}\x00\x00\x00\x00\x00\x00#{m[:right]}#{m[:numlk]}#{m[:np_seven]}#{m[:np_four]}#{m[:np_one]}\x00\x00\x00\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x40\x86\x3a#{user}#{m[:np_div]}#{m[:np_eight]}#{m[:np_five]}#{m[:np_two]}#{m[:np_zero]}#{m[:np_mult]}#{m[:np_nine]}#{m[:np_six]}#{m[:np_three]}#{m[:np_dot]}#{m[:np_minus]}#{m[:np_plus]}\x00\x00\x00#{m[:np_enter]}\x00\x00\x00#{m[:esc]}\x00\x00\x00#{m[:f1]}#{m[:f2]}\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x40\xc7\x2b#{user}#{m[:f3]}#{m[:f4]}#{m[:f5]}#{m[:f6]}#{m[:f7]}#{m[:f8]}#{m[:f9]}#{m[:f10]}#{m[:f11]}#{m[:f12]}#{m[:prtsc]}#{m[:scrlk]}#{m[:pause]}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x44\x00\x0d#{user}".force_encoding(Encoding::BINARY).freeze
      ]
    end

    def self.user_specified_actuation_heights(mapping)
      bytes = {
        '15' => HEIGHT_15,
        '22' => HEIGHT_22,
        '30' => HEIGHT_30
      }

      m = lambda { |sym| bytes[mapping[sym].to_s] || bytes[mapping[:default].to_s] || HEIGHT_15 }

      [
        "\xaa\xaa\x21\x41\x3b\x00#{m[:grave]}#{m[:one]}#{m[:two]}#{m[:three]}#{m[:four]}#{m[:five]}#{m[:six]}#{m[:seven]}#{m[:eight]}#{m[:nine]}#{m[:zero]}#{m[:hyphen]}#{m[:equals]}\x00#{m[:backspace]}#{m[:tab]}#{m[:q]}#{m[:w]}#{m[:e]}#{m[:r]}#{m[:t]}#{m[:y]}#{m[:u]}#{m[:i]}#{m[:o]}#{m[:p]}#{m[:lbracket]}#{m[:rbracket]}#{m[:backslash]}#{m[:capslock]}#{m[:a]}#{m[:s]}#{m[:d]}#{m[:f]}#{m[:g]}#{m[:h]}#{m[:j]}#{m[:k]}#{m[:l]}#{m[:semicolon]}#{m[:apostrophe]}\x00#{m[:enter]}#{m[:lshift]}\x00#{m[:z]}#{m[:x]}#{m[:c]}#{m[:v]}#{m[:b]}#{m[:n]}#{m[:m]}#{m[:comma]}#{m[:period]}#{m[:slash]}\x00#{m[:rshift]}#{m[:lctrl]}".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x21\x82\x3b\x00#{m[:lalt]}#{m[:space]}#{m[:ralt]}\x00#{m[:rctrl]}\x00\x00\x00#{m[:lwin]}#{m[:rwin]}#{m[:fn]}#{m[:mute]}#{m[:voldown]}#{m[:volup]}#{m[:actuation]}#{m[:ins]}#{m[:del]}\x00\x00#{m[:left]}#{m[:home]}#{m[:end]}\x00#{m[:up]}#{m[:down]}#{m[:pgup]}#{m[:pgdn]}\x00\x00#{m[:right]}#{m[:numlk]}#{m[:np_seven]}#{m[:np_four]}#{m[:np_one]}\x00#{m[:np_div]}#{m[:np_eight]}#{m[:np_five]}#{m[:np_two]}#{m[:np_zero]}#{m[:np_mult]}#{m[:np_nine]}#{m[:np_six]}#{m[:np_three]}#{m[:np_dot]}#{m[:np_minus]}#{m[:np_plus]}\x00#{m[:np_enter]}\x00#{m[:esc]}\x00#{m[:f1]}#{m[:f2]}#{m[:f3]}#{m[:f4]}#{m[:f5]}#{m[:f6]}".force_encoding(Encoding::BINARY).freeze,
        "\xaa\xaa\x21\xc3\x0a#{m[:f7]}#{m[:f8]}#{m[:f9]}#{m[:f10]}#{m[:f11]}#{m[:f12]}#{m[:prtsc]}#{m[:scrlk]}#{m[:pause]}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".force_encoding(Encoding::BINARY).freeze
      ]
    end

    def self.pressed_key_lighting(rgb_hex, user = :user0)
      # byte number 6 (just before rgb) determines user. 0x00-0x03
      "\xaa\xaa\x62\x00\x04\x00#{color_transform rgb_hex}".force_encoding(Encoding::BINARY).freeze
    end

    # Backlight color can't be changed AFAICT. Always white.
    def self.pressed_key_lighting_with_backlight(rgb_hex, user = :user0)
      "\xaa\xaa\x63\x00\x04\x00#{color_transform rgb_hex}".force_encoding(Encoding::BINARY).freeze
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

    def self.color_transform(color)
      return nil unless color
      return color unless color.length == 6 # rrggbb string
      [color].pack('H*').force_encoding(Encoding::UTF_8)
    end
  end
end