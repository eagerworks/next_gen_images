# frozen_string_literal: true

require_relative 'next_gen_images/version'
require_relative 'next_gen_images/railtie' if defined?(Rails)
require_relative 'next_gen_images/engine'
require_relative 'next_gen_images/view_helpers'
require_relative 'next_gen_images/carrierwave_helpers'
