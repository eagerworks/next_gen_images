require 'next_gen_images/view_helpers'

module NextGenImages
  class Railtie < Rails::Railtie
    initializer 'next_gen_images.view_helpers' do
      ActionView::Base.include ViewHelpers
    end

    # Load all rake tasks automatically when this gem is required in a Rails app
    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
