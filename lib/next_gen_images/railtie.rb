require 'next_gen_images/view_helpers'

module NextGenImages
  class Railtie < Rails::Railtie
    initializer 'next_gen_images.view_helpers' do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end