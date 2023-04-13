# frozen_string_literal: true

require 'webp-ffi'

namespace :assets do
  desc 'Create .webp versions of assets'
  task webp: :environment do
    image_types = /\.(?:png|jpe?g)$/

    public_assets = File.join(
      Rails.root,
      'public',
      Rails.application.config.assets.prefix
    )

    Dir["#{public_assets}/**/*"].each do |filename|
      next unless filename =~ image_types

      mtime = File.mtime(filename)
      webp_file = "#{filename}.webp"
      next if File.exist?(webp_file) && File.mtime(webp_file) >= mtime

      begin
        # encode with lossy encoding and slowest method (best quality)
        WebP.encode(filename, webp_file, lossless: 0, quality: 80, method: 6)
        File.utime(mtime, mtime, webp_file)
        $stdout.puts "Converted image to Webp: #{webp_file}"
      rescue StandardError => e
        $stdout.puts "Webp conversion error on image #{webp_file}. Error info: #{e.message}"
      end
    end
  end

  # Hook into existing assets:precompile task
  Rake::Task['assets:precompile'].enhance do
    # TODO: if defined?(NextGenImages) && NextGenImages.config.run_on_precompile
    Rake::Task['assets:webp'].invoke
  end
end
