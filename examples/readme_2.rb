require 'rf_rgb'

RfRgb::Keyboard.run_and_release do |keyboard|
  keyboard.effect_rainbow_wave
  keyboard.brightness = RfRgb::Protocol::BRIGHTNESS_LOW
  keyboard.actuation_height = RfRgb::Protocol::HEIGHT_22
  keyboard.swap_caps_ctrl
  keyboard.save
end
