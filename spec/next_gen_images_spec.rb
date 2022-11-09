# frozen_string_literal: true
require 'next_gen_images/view_helpers'
require 'rack'

module NextGenImages
  RSpec.describe NextGenImages do
    include ViewHelpers
    # For Rack::Mime usage
    include ::Rack
    include ActionView::Helpers
    include ActionView::Helpers::TagHelper

    it 'has a version number' do
      expect(VERSION).not_to be nil
    end

    it 'creates a picture tag' do
      expect(picture_tag('image.png')).to match(Regexp.new('\\A<picture>.*?</picture>\\z'))
    end
  end
end