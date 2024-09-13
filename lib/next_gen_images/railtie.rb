# frozen_string_literal: true

module NextGenImages
  # Load everything we need into rails
  class Railtie < Rails::Railtie
    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
