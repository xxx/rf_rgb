require 'libusb'
require 'rf_rgb/keyboard'
require 'rf_rgb/protocol'
require 'rf_rgb/version'

module RfRgb
  # 0 is silent, 4 is spewy.
  LIBUSB_DEBUG = ENV['LIBUSB_DEBUG'] || 3
end
