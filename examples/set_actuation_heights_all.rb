require 'rf_rgb'

# Valid values are 15, 22, and 30.
# This hash can also accept a :default key, a la colors
heights = {
  a: 30,
  actuation: 30,
  apostrophe: 30,
  b: 30,
  backslash: 30,
  backspace: 30,
  c: 30,
  capslock: 30,
  comma: 30,
  d: 30,
  del: 30,
  down: 30,
  e: 30,
  eight: 30,
  end: 30,
  enter: 30,
  equals: 30,
  esc: 30,
  f: 30,
  f1: 30,
  f10: 30,
  f11: 30,
  f12: 30,
  f2: 30,
  f3: 30,
  f4: 30,
  f5: 30,
  f6: 30,
  f7: 30,
  f8: 30,
  f9: 30,
  five: 30,
  fn: 30,
  four: 30,
  g: 30,
  grave: 30,
  h: 30,
  home: 30,
  hyphen: 30,
  i: 30,
  ins: 30,
  j: 30,
  k: 30,
  l: 30,
  lalt: 30,
  lbracket: 30,
  lctrl: 30,
  left: 30,
  lshift: 30,
  lwin: 30,
  m: 30,
  mute: 30,
  n: 30,
  nine: 30,
  np_div: 30,
  np_dot: 30,
  np_eight: 30,
  np_enter: 30,
  np_five: 30,
  np_four: 30,
  np_minus: 30,
  np_mult: 30,
  np_nine: 30,
  np_one: 30,
  np_plus: 30,
  np_seven: 30,
  np_six: 30,
  np_three: 30,
  np_two: 30,
  np_zero: 30,
  numlk: 30,
  o: 30,
  one: 30,
  p: 30,
  pause: 30,
  period: 30,
  pgdn: 30,
  pgup: 30,
  prtsc: 30,
  q: 30,
  r: 30,
  ralt: 30,
  rbracket: 30,
  rctrl: 30,
  right: 30,
  rshift: 30,
  rwin: 30,
  s: 30,
  scrlk: 30,
  semicolon: 30,
  seven: 30,
  six: 30,
  slash: 30,
  space: 30,
  t: 30,
  tab: 30,
  three: 30,
  two: 30,
  u: 30,
  up: 30,
  v: 30,
  voldown: 30,
  volup: 30,
  w: 30,
  x: 30,
  y: 30,
  z: 30,
  zero: 30
}

RfRgb::Keyboard.run_and_release do |keyboard|
  keyboard.actuation_height = heights
  keyboard.save
end