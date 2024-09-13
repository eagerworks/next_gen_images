# frozen_string_literal: true

require 'webp-ffi'

require_relative 'next_gen_images/version'
require_relative 'next_gen_images/config'
require_relative 'next_gen_images/railtie' if defined?(Rails)
require_relative 'next_gen_images/engine'
require_relative 'next_gen_images/carrierwave_helpers'
