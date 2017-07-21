require 'spec_helper'

RSpec.describe RfRgb::Keyboard do
  context 'sending messages' do
    context 'retry behavior' do
      before :each do
        @handle = double(
          'device handle',
          :auto_detach_kernel_driver= => true,
          :set_configuration => nil,
          :claim_interface => nil,
          :interrupt_transfer => "\x10",
          :release_interface => nil,
          :close => nil
        )
        @device = double('device', open: @handle)

        @board = RfRgb::Keyboard.new(@device)
        allow(@board).to receive(:reset_effect)
        allow(RfRgb::Keyboard).to receive(:new).and_return(@board)
      end

      it 'retries if the ack does not validate' do
        allow(@board).to receive(:verify_message).and_return(false, false, true)

        expect(@board).to receive(:send_message).with(RfRgb::Protocol.rainbow_wave).exactly(3).times

        RfRgb::Keyboard.run_and_release(@device) do |kb|
          kb.effect_rainbow_wave
        end
      end

      it 'throws an error after the third failed verification' do
        allow(@board).to receive(:verify_message).and_return(false)

        expect(@board).to receive(:send_message).with(RfRgb::Protocol.rainbow_wave).exactly(3).times

        expect do
          RfRgb::Keyboard.run_and_release(@device) do |kb|
            kb.effect_rainbow_wave
          end
        end.to raise_error(RfRgb::VerificationError)
      end
    end
  end
end
