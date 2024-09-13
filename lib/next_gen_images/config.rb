# frozen_string_literal: true

module NextGenImages
  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end
  end

  class Config
    attr_accessor :run_on_precompile

    def initialize
      @run_on_precompile = false
    end
  end
end
