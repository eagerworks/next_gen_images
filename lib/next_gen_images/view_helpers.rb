# frozen_string_literal: true

require 'action_view'

module NextGenImages
  module ViewHelpers
    def self.included(klass)
      klass.class_eval do
        include ActionView::Context
      end
    end

    def picture_tag(source, options = {}, &block)
      picture_options = options.except(:image)

      content_tag :picture, picture_options do
        build_picture_content(source, block, options)
      end
    end

    def source_tag(options = {})
      tag :source, options
    end

    private

    def build_picture_content(source, block, options)
      image_options = options.fetch(:image, {})
      image_options[:src] = build_img_src(source)
      add_webp = options.fetch(:add_webp, false)

      content = ''.html_safe
      if block.present?
        content += capture(&block).html_safe
      else
        [source].flatten.each do |img_src|
          content += build_source_from_img(image_path(img_src), add_webp)
        end
      end
      content += tag('img', image_options)
    end

    def build_img_src(source)
      case source
      when String
        image_path(source)
      when Array
        image_path(source.last)
      else
        ''
      end
    end

    def build_source_from_img(img_path, add_webp)
      source_tags = ''.html_safe
      webp_path = "#{img_path}.webp"
      # order of source tags matters
      if add_webp && file_exist_in_public_path?(webp_path)
        source_tags += source_tag(srcset: webp_path, type: 'image/webp')
      end
      source_tags + source_tag(
        srcset: img_path,
        type: image_type(img_path)
      )
    end

    def image_type(image_path)
      extension = File.extname(image_path)
      Rack::Mime::MIME_TYPES.merge!({
                                      '.webp' => 'image/webp'
                                    })
      Rack::Mime.mime_type(extension).to_s
    end

    def file_exist_in_public_path?(path)
      # for performance reasons, we assume production contains the asset
      return true if ::Rails.env.production?

      public_path = File.join(
        ::Rails.root,
        'public',
        path
      )
      File.exist?(public_path)
    end
  end
end
