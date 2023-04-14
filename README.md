# Next Gen Images

## Motivation

Currently Rails does not provide a `picture` HTML tag helper. An HTML `picture` tag provides [several advantages](TODO:LINK) over an image tag, like fallback image support, resolution switching and art direction.
Also, most of a website assets are still JPEG or PNG images, and we don't want to convert our assets manually to WebP, we want this to happen automatically if it's needed.

This gem brings next gen image formats to Ruby on Rails. A `picture_tag` view helper is provided along several utilities to automatically convert them. Currently, it supports `WebP` images.


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

### View Helpers

This gem adds support for a `picture_tag` helper. Syntax is the following:
```
picture_tag SOURCE, PICTURE_TAG_OPTIONS, image: IMAGE_TAG_OPTIONS
```

This will output something like this:
```html
<picture PICTURE_TAG_OPTIONS>
  <source srcset=SOURCE ...>
  ... 
  <img IMAGE_TAG_OPTIONS>
</picture>
```

Depending on your needs, you can use the `picture_tag` in 3 different ways:

1. You can pass your existing image as the source, and add the `add_webp: true` option to automatically infer the `webp` image from the PNG/JPEG and add fallback image support.
```ruby
picture_tag 'satellite.png', image: { alt: 'satellite image', class: 'mt-0' }, add_webp: true
```
This will create the following HTML:
```html
<picture>
  <source srcset="/assets/satellite.png.web" type="image/webp">
  <source srcset="/assets/satellite.png" type="image/png">
  <img alt="satellite image" class="mt-0" src="/assets/satellite.png.webp">
</picture>
```

2. If you want to manually specify your sources, you can pass an array of images to the `picture_tag`. This is extremely useful for dynamically generated images (that a user uploaded for example).
```ruby
picture_tag [post.cover_image.webp.medium.url, post.cover_image.medium.url], image: { alt: 'post image', class: 'rounded' }
```

This will create the following HTML:
```html
<picture>
  <source srcset="/uploads/posts/1/cover-image.png.webp" type="image/webp">
  <source srcset="/uploads/posts/1/cover-image.png" type="image/png">
  <img alt="post image" class="rounded" src="/uploads/posts/1/cover-image.png.webp">
</picture>
```

3. The last option is to provide a block that will be inserted directly into the picture tag. This can be extremely useful for art direction.

```ruby
= picture_tag 'city.png', image: { alt: 'city image' } do
  = source_tag srcset: "#{image_path('city_small.png')}.webp", type: 'image/webp', media: '(max-width: 1728px)'
  = source_tag srcset: "#{image_path('city_big.png')}.webp", type: 'image/webp'
  = source_tag srcset: image_path('city_small.png'), type: 'image/png', media: '(max-width: 1728px)'
  = source_tag srcset: image_path('city_big.png'), type: 'image/png'
```
Which will create the following HTML:
```html
<picture>
  <source srcset="/assets/city_small.png.webp" type="image/webp" media="(max-width: 1728px)">
  <source srcset="/assets/city_small.png.webp" type="image/webp">
  <source srcset="/assets/city_small.png" type="image/png" media="(max-width: 1728px)">
  <source srcset="/assets/city_big.png" type="image/png">
  <img alt="city image" src="/assets/city_small.png.webp">
</picture>
```

### Asset conversion

A rake task called `assets:webp` that converts all of your images to WebP is provided. When you run the `assets:precompile` task, the `assets:webp` task will also run (via an `enhance` to the `assets:precompile` task) and automatically convert your images to WebP.
If you want to manually convert your images, you can run:
```bash
rake assets:webp
```
Assets will be compiled to `public/assets/` or the path that you specifed in `Rails.application.config.assets.prefix`.
The file names of the generated image assets will be in the format:`OLD_IMAGE.OLD_EXTENSION.webp`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eagerworks/next_gen_images.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
