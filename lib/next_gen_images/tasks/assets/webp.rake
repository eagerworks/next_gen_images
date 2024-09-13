# frozen_string_literal: true

require 'webp-ffi'

namespace :next_gen_images do # rubocop:disable Metrics/BlockLength
  desc 'Create .webp versions of assets'
  task precompile: :environment do
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

  desc 'Convert JPEG/PNG images in app/assets/images to WebP'
  task convert_app_images: :environment do
    source_dir = Rails.root.join('app', 'assets', 'images')

    Dir.glob(File.join(source_dir, '**', '*.{jpg,jpeg,png}')).each do |image_path|
      webp_path = image_path.sub(/\.(jpg|jpeg|png)$/i, '.webp')

      begin
        WebP.encode(image_path, webp_path, lossless: 0, quality: 80, method: 6)
        puts "Converted: #{image_path} -> #{webp_path}"
      rescue StandardError => e
        puts "Error converting #{image_path}: #{e.message}"
      end
    end

    puts 'Conversion complete. WebP images are in the same directories as the original images.'
  end
end

# Hook into existing assets:precompile task
Rake::Task['assets:precompile'].enhance do
  Rake::Task['next_gen_images:precompile'].invoke if defined?(NextGenImages) && NextGenImages.config.run_on_precompile
end
