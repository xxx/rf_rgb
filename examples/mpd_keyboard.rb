require 'rf_rgb'

# MY keyboard setup
RfRgb::Keyboard.run_and_release do |keyboard|
  keyboard.effect_pressed_key '00ffff'
  keyboard.actuation_height = RfRgb::Protocol::HEIGHT_15
  keyboard.save
end
