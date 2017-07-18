require 'libusb'
require 'pry'

VENDOR_ID = 0x0853
PRODUCT_ID = 0x013a
ENDPOINT = 0x04
# data = 'aaaa6'
data = "\xaa\xaa\x62\x00\x04\x00\xff\x00\x00".force_encoding(Encoding::BINARY)
# data2 = '55556'
# data3 = 'aaaa61'
# data4 = 'aaaa62'

usb = LIBUSB::Context.new
usb.debug = 4

devices = usb.devices(idVendor: VENDOR_ID, idProduct: PRODUCT_ID)
device = devices.first

raise 'No device found' unless device

handle = nil
begin
  handle = device.open
  handle.auto_detach_kernel_driver = true
  handle.set_configuration(1) rescue nil
  handle.claim_interface(0)
  # handle.clear_halt endpoint0

  response = handle.interrupt_transfer(
    endpoint: ENDPOINT,
    dataOut: data,
    timeout: 10000
  )

  p response

ensure
  handle.release_interface(0)
  handle.close
end
