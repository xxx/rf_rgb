module RfRgb
  class Keyboard
    VENDOR_ID = 0x0853
    PRODUCT_ID = 0x013a
    ENDPOINT_OUT = 0x04
    ENDPOINT_IN = 0x83
    INTERFACE = 0

    attr_reader :device, :handle

    def self.all
      context = LIBUSB::Context.new
      context.debug = LIBUSB_DEBUG
      context.devices(idVendor: VENDOR_ID, idProduct: PRODUCT_ID)
    end

    def self.first
      all.first
    end

    def self.run_and_release(device = RfRgb::Keyboard.first, &block)
      keyboard = nil
      begin
        keyboard = new(device)
        yield keyboard
      ensure
        keyboard&.release_to_os
      end
    end

    def initialize(device = RfRgb::Keyboard.first)
      @device = device
      @handle = initialize_device(device)
    end

    def save
      send_message RfRgb::Protocol.save_changes
      receive_message
    end

    def release_to_os
      return unless @handle
      @handle.release_interface(INTERFACE)
      @handle.close
    end

    def disable_effect
      reset_effect
      send_message RfRgb::Protocol.disable_effects
      receive_message
    end

    def colors=(new_colors)
      if new_colors.is_a? String
        new_colors = {default: new_colors}
      end

      calls = RfRgb::Protocol.user_specified_colors(new_colors)
      reset_effect
      calls.each do |call|
        send_message call
        ack = receive_message
        # verify via ack[0..2] == "\x55\x55#{call[2]}" or something
      end
    end

    def effect_rainbow_wave
      reset_effect
      send_message RfRgb::Protocol.rainbow_wave
      receive_message
    end

    def effect_pressed_key(rgb_hex)
      reset_effect
      send_message RfRgb::Protocol.pressed_key_lighting(rgb_hex)
      receive_message
    end

    def effect_pressed_key_with_backlight(rgb_hex)
      reset_effect
      send_message RfRgb::Protocol.pressed_key_lighting_with_backlight(rgb_hex)
      receive_message
    end

    def effect_shooting_star(rgb_hex, interval)
      reset_effect
      send_message RfRgb::Protocol.shooting_star(rgb_hex, interval)
      receive_message
    end

    def effect_demo_mode
      reset_effect
      send_message RfRgb::Protocol.demo_mode
      receive_message
    end

    def effect_random_lights
      reset_effect
      send_message RfRgb::Protocol.random_lights
      receive_message
    end

    def effect_color_bar
      reset_effect
      send_message RfRgb::Protocol.color_bar
      receive_message
    end

    # There's more to key locking than just this, but the way it's done is odd
    # and is among the lowest of priorities on this project.
    def lock_keys
      send_message RfRgb::Protocol.key_lock
      receive_message
    end

    def unlock_keys
      send_message RfRgb::Protocol.key_unlock
      receive_message
    end

    def brightness=(new_brightness)
      send_message RfRgb::Protocol.change_brightness(new_brightness)
      receive_message
    end

    def actuation_height=(new_height)
      send_message RfRgb::Protocol.change_actuation_height_all(new_height)
      receive_message
    end

    def swap_caps_ctrl
      send_message RfRgb::Protocol.swap_caps_ctrl
      receive_message
    end

    def unswap_caps_ctrl
      send_message RfRgb::Protocol.unswap_caps_ctrl
      receive_message
    end

    private

    # I don't know what this actually does, but the Windows software
    # sends this message before any effect change.
    def reset_effect
      send_message RfRgb::Protocol.reset_effect
      receive_message
    end

    def initialize_device(device)
      handle = device.open
      handle.auto_detach_kernel_driver = true
      handle.set_configuration(1) rescue nil
      handle.claim_interface(INTERFACE)
      # handle.clear_halt endpoint0
      handle
    end

    def send_message(data)
      @handle.interrupt_transfer(
        endpoint: ENDPOINT_OUT,
        dataOut: data,
        timeout: 10_000
      )
    end

    def receive_message
      @handle.interrupt_transfer(
        endpoint: ENDPOINT_IN,
        dataIn: 64,
        timeout: 10_000
      )
    end
  end
end