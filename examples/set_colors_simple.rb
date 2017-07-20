require 'rf_rgb'

# Set all keys to a single color
RfRgb::Keyboard.run_and_release do |keyboard|
  keyboard.colors = '11aa43'
  keyboard.save
end