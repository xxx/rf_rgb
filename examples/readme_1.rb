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
