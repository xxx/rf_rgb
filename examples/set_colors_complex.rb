require 'rf_rgb'

# Set all keys based on a passed-in mapping
colors = {
  # Any key not specified will be set to the default value of the mapping.
  # If no default is set in the mapping, will default to 000000 (i.e. not lit)
  default: '11aa43',

  a: 'ff00ff',
  s: 'ff00ff',
  d: 'ff00ff',
  f: 'ff00ff',

  j: '00ffff',
  k: '00ffff',
  l: '00ffff',
  semicolon: '00ffff'
}

RfRgb::Keyboard.run_and_release do |keyboard|
  keyboard.colors = colors
  keyboard.save
end