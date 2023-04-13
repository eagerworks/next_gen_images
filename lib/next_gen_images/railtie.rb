# frozen_string_literal: true

require 'next_gen_images/view_helpers'

module NextGenImages
  # Load everything we need into rails
  class Railtie < Rails::Railtie
    initializer 'next_gen_images.view_helpers' do
      ActionView::Base.include ViewHelpers
    end

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
