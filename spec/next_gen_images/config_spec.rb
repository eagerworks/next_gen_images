# frozen_string_literal: true

require 'spec_helper'
require 'next_gen_images/config'

RSpec.describe NextGenImages::Config do
  describe '.configure' do
    it 'yields the config object' do
      expect { |b| NextGenImages.configure(&b) }.to yield_with_args(NextGenImages.config)
    end

    it 'allows setting configuration options' do
      NextGenImages.configure do |config|
        config.run_on_precompile = true
      end

      expect(NextGenImages.config.run_on_precompile).to be true
    end
  end

  describe '.config' do
    it 'returns a Config instance' do
      expect(NextGenImages.config).to be_an_instance_of(described_class)
    end
  end

  describe NextGenImages::Config do
    describe '#initialize' do
      it 'sets default values' do
        config = described_class.new
        expect(config.run_on_precompile).to be false
      end
    end

    describe '#run_on_precompile' do
      it 'can be set and retrieved' do
        config = described_class.new
        config.run_on_precompile = true
        expect(config.run_on_precompile).to be true
      end
    end
  end
end
