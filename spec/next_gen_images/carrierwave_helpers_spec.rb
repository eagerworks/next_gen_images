# frozen_string_literal: true

require 'spec_helper'
require 'carrierwave'
require 'webp-ffi'

# Dummy class to include the module
class DummyUploader < CarrierWave::Uploader::Base
  include NextGenImages::CarrierwaveHelpers
end

RSpec.describe NextGenImages::CarrierwaveHelpers do
  let(:uploader) { DummyUploader.new }
  let(:filename) { 'example_image.jpg' }
  let(:version_name) { 'thumb' }
  let(:file_path) { "spec/fixtures/#{filename}" }
  let(:webp_path) { "#{file_path}.webp" }

  before do
    allow(uploader).to receive(:store!)
    allow(uploader).to receive(:remove!)
    allow(uploader).to receive(:path).and_return(file_path)
  end

  describe '#convert_to_webp' do
    before do
      allow(WebP).to receive(:encode).and_return(true)
      allow(CarrierWave::SanitizedFile).to receive(:new).and_call_original
      uploader.convert_to_webp
    end

    it 'calls WebP.encode with proper arguments' do
      expect(WebP).to have_received(:encode).with(file_path, webp_path, {})
    end

    it 'updates the filename to webp format' do
      expect(uploader.filename).to eq("#{filename}.webp")
    end

    it 'creates a new CarrierWave::SanitizedFile with webp content type' do
      expect(uploader.file.content_type).to eq('image/webp')
    end
  end

  describe '#build_webp_full_filename' do
    context 'when filename is already in webp format' do
      let(:filename) { 'example_image.webp' }

      it 'returns the correct webp full filename' do
        expect(uploader.build_webp_full_filename(filename, version_name)).to eq('thumb_example_image.webp')
      end
    end

    context 'when filename is not in webp format' do
      it 'returns the correct webp full filename' do
        expect(uploader.build_webp_full_filename(filename, version_name)).to eq('thumb_example_image.jpg.webp')
      end
    end
  end
end
