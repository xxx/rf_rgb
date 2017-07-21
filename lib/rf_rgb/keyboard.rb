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
      send_and_verify RfRgb::Protocol.save_changes
    end

    def release_to_os
      return unless @handle
      @handle.release_interface(INTERFACE)
      @handle.close
    end

    def disable_effect
      reset_effect
      send_and_verify RfRgb::Protocol.disable_effects
    end

    def colors=(new_colors)
      if new_colors.is_a? String
        new_colors = {default: new_colors}
      end

      calls = RfRgb::Protocol.user_specified_colors(new_colors)
      reset_effect
      calls.each do |call|
        send_and_verify call
      end
    end
    alias_method :color=, :colors=

    def effect_rainbow_wave
      reset_effect
      send_and_verify RfRgb::Protocol.rainbow_wave
    end

    def effect_pressed_key(rgb_hex)
      reset_effect
      send_and_verify RfRgb::Protocol.pressed_key_lighting(rgb_hex)
    end

    def effect_pressed_key_with_backlight(rgb_hex)
      reset_effect
      send_and_verify RfRgb::Protocol.pressed_key_lighting_with_backlight(rgb_hex)
    end

    def effect_shooting_star(rgb_hex, interval)
      reset_effect
      send_and_verify RfRgb::Protocol.shooting_star(rgb_hex, interval)
    end

    def effect_demo_mode
      reset_effect
      send_and_verify RfRgb::Protocol.demo_mode
    end

    def effect_random_lights
      reset_effect
      send_and_verify RfRgb::Protocol.random_lights
    end

    def effect_color_bar
      reset_effect
      send_and_verify RfRgb::Protocol.color_bar
    end

    # There's more to key locking than just this, but the way it's done is odd
    # and is among the lowest of priorities on this project.
    def lock_keys
      send_and_verify RfRgb::Protocol.key_lock
    end

    def locked_keys=(keys)
      calls = RfRgb::Protocol.user_specified_key_locks(keys)
      calls.each do |call|
        send_and_verify call
      end
    end

    def unlock_keys
      send_and_verify RfRgb::Protocol.key_unlock
    end

    def brightness=(new_brightness)
      send_and_verify RfRgb::Protocol.change_brightness(new_brightness)
    end

    def actuation_height=(new_height)
      if new_height.is_a? String
        send_and_verify RfRgb::Protocol.change_actuation_height_all(new_height)
      else
        calls = RfRgb::Protocol.user_specified_actuation_heights(new_height)
        reset_effect
        calls.each do |call|
          send_and_verify call
        end
      end
    end
    alias_method :actuation_heights=, :actuation_height=

    def swap_caps_ctrl
      send_and_verify RfRgb::Protocol.swap_caps_ctrl
    end

    def unswap_caps_ctrl
      send_and_verify RfRgb::Protocol.unswap_caps_ctrl
    end

    private

    # I don't know what this actually does, but the Windows software
    # sends this message before any effect change.
    def reset_effect
      send_and_verify RfRgb::Protocol.reset_effect
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

    def send_and_verify(data, retries = 2)
      retry_count = 0
      begin
        send_message data
        ack = receive_message
        verify_message!(data, ack)
      rescue RfRgb::VerificationError
        retry_count += 1
        retry if retry_count <= retries
      end
    end

    # The keyboard acknowledges each packet sent with a response of \x55\x55\x<third byte of sent packet>
    def verify_message(data, ack)
      ack.bytes[0..2] == "\x55\x55#{data[2]}".bytes
    end

    def verify_message!(data, ack)
      unless verify_message(data, ack)
        raise RfRgb::VerificationError, "Ack[#{ack.bytes}] did not match data[#{data.bytes}]!"
      end
    end
  end
end