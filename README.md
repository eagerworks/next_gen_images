# Next Gen Images

## Motivation

*Update:*
Since Rails 7.1 and this [PR](https://github.com/rails/rails/pull/48100), Rails has a `picture` HTML tag helper.

This gem provides helpers to simplify the transition to using WebP images in Ruby on Rails.
A Carrierwave module with some utility methods is provided.


## Installation

IMPORTANT:
Since this gem adds the ability to convert all your project images to WebP and depends on `webp-ffi`, you will need to install the WebP converter before. You can check specific instructions for your operating system [here](https://github.com/le0pard/webp-ffi#installation)

Once you are ready with, install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add next_gen_images
```

Or add it to your application's Gemfile
```ruby
gem 'next_gen_images'
```
and then run
```bash
bundle install
```

## Usage

### Asset conversion to public/assets for production usage

A rake task called `next_gen_images:precompile` that precompiles all of your images to WebP is provided. You can enable it so it runs automatically when you do an `assets:precompile` via an initializer like this:

```ruby
NextGenImages.configure do |config|
  config.run_on_precompile = true
end
```

If you want to manually convert your images, you can run:
```bash
rake next_gen_images:precompile
```
Assets will be compiled to `public/assets/` or the path that you specifed in `Rails.application.config.assets.prefix`.
The file names of the generated image assets will be in the format:`OLD_IMAGE.OLD_EXTENSION.webp`

### Asset conversion of /app/assets/images directory

In addition to the `next_gen_images:precompile` task, there's also a task to convert images in the `app/assets/images` directory to WebP. It leaves the original images untouched:

```bash
rake next_gen_images:convert_app_images
```
The file names of the generated image assets will be in the format `OLD_IMAGE.webp` and will be placed in the `app/assets/images` directory.

### ActiveStorage integration

If you are using ActiveStorage you will need to first enable the `image_processing` gem. Usually, uncommenting this from your Gemfile:
```
gem "image_processing"
```

Then, you will need to install the VIPS image processing library binaries. Check the [VIPS Ruby wrapper gem](https://github.com/libvips/ruby-vips) for installation instructions for your OS.

Finally, in `application.rb` configure ActiveStorage to use VIPS:

```ruby
config.active_storage.variant_processor = :vips
```

You are ready to start using WebP variants in your models like this:

```ruby
class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [400, 400]
    attachable.variant :webp, {
      convert: :webp,
      format: :webp,
      saver: { quality: 80 }
    }
    attachable.variant :webp_small, {
      resize_to_limit: [400, 400],
      convert: :webp,
      format: :webp,
      saver: { quality: 80 }
    }
  end
end
```

### Carrierwave integration

A `convert_to_webp` method that converts images to WebP is provided. You can send any encoding option available to [webp-ffi](https://github.com/le0pard/webp-ffi#encode-webp-image).
We also provide a helper method called `build_webp_full_filename` that allows you to generate the WebP filename from the original filename and version.

Example Uploader class:
```ruby
class ImageUploader < CarrierWave::Uploader::Base
  include NextGenImages::CarrierwaveHelpers

  version :small do
    process resize_to_fit: [400, 400]
  end

  version :webp do
    process convert_to_webp: [{ quality: 80, method: 5 }]

    def full_filename(file)
      build_webp_full_filename(file, version_name)
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eagerworks/next_gen_images.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
