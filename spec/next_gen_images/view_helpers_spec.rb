# frozen_string_literal: true
require 'spec_helper'
require 'rack'

module NextGenImages
  RSpec.describe ViewHelpers, type: :helper do
    # For Rack::Mime usage
    include ::Rack
    include ViewHelpers
    include ActionView::Helpers
    include ActionView::Helpers::TagHelper

    it 'has a version number' do
      expect(VERSION).not_to be nil
    end

    describe '#picture_tag' do
      let(:source) { 'example.png' }
      let(:options) { {} }
      let(:result) { picture_tag(source, options) }

      it 'wraps everything in a picture tag' do
        expect(result).to match(Regexp.new('\\A<picture>.*?</picture>\\z'))
      end

      it 'adds an img tag at the end' do
        expect(result).to match(Regexp.new('.*<img.*?/></picture>'))
      end

      context 'when passing image options' do
        let(:options) { { image: { alt: 'laptop', class: 'position-absolute' } } }

        it 'passes image options to the img tag' do
          expect(result).to include(
            "<img alt=\"laptop\" class=\"position-absolute\" src=\"#{image_path(source)}\""
          )
        end
      end

      context 'when given a single image source' do
        let(:options) { { add_webp: true } }

        before do
          allow(self).to receive(:file_exist_in_public_path?) { true }
        end

        it 'returns a picture tag with an source tag' do
          expect(result).to include("<source srcset=\"#{image_path(source)}\"")
        end

        it 'correctly adds the img tag' do
          expect(result).to include("<img src=\"#{image_path(source)}\"")
        end

        it 'adds a webp image if add_webp is present' do
          expect(result).to include("<source srcset=\"#{image_path(source)}\"")
          expect(result).to include("<source srcset=\"#{image_path(source) + '.webp' }\"")          
        end
      end

      context 'when given multiple image sources' do
        let(:source) { ['example.webp', 'example.png'] }

        it 'returns a picture tag with multiple source tags and an img tag' do
          source.each do |src|
            expect(result).to include("<source srcset=\"#{image_path(src)}\"")
          end
        end

        it 'correctly adds the img tag' do
          expect(result).to include("<img src=\"#{image_path(source.last)}\"")
        end
      end

      context 'when given a block' do
        let(:result) do
          picture_tag(source, options) do
            source_tag(srcset: 'example.webp', type: 'image/webp') +
            source_tag(srcset: 'example.png', type: 'image/png')
          end
        end

        it 'returns a picture tag with the block content and an img tag' do
          expect(result).to include("<source srcset=\"example.webp\" type=\"image/webp\"")
          expect(result).to include("<source srcset=\"example.png\" type=\"image/png\"")
        end

        it 'correctly adds the img tag' do
          expect(result).to include("<img src=\"#{image_path(source)}\"")
        end
      end
    end

    describe '#source_tag' do
      let(:options) { { srcset: 'example.png', type: 'image/png' } }
      let(:result) { source_tag(options) }

      it 'returns a source tag with the specified options' do
        expect(result).to eq("<source srcset=\"example.png\" type=\"image/png\" />")
      end
    end
  end
end
