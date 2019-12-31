# frozen_string_literal: true

# name: yearly-review-topic
# about: Creates an automated Year in Review summary topic
# version: 0.1
# author: Simon Cossar
# url: https://github.com/scossar/yearly-review-topic

enabled_site_setting :yearly_review_enabled
register_asset 'stylesheets/yearly_review.scss'

after_initialize do

  module ::YearlyReview
    PLUGIN_NAME = 'yearly-review-topic'

    def self.current_year
      Time.now.year
    end

    def self.last_year
      current_year - 1
    end
  end

  ::ActionController::Base.prepend_view_path File.expand_path('../app/views/yearly-review', __FILE__)

  [
    '../../yearly-review-topic/app/jobs/yearly_review.rb'
  ].each { |path| load File.expand_path(path, __FILE__) }

  require_dependency 'email/styles'
  Email::Styles.register_plugin_style do |doc|
    doc.css('[data-review-topic-users] table').each do |element|
      element['width'] = '100%'
    end
    doc.css('[data-review-featured-topics] table').each do |element|
      element['width'] = '100%'
    end

    doc.css('[data-review-topic-users] th').each do |element|
      element['style'] = 'text-align:left;padding-bottom:12px;'
      element['width'] = '50%'
    end
    doc.css('[data-review-featured-topics] th').each do |element|
      element['style'] = 'text-align:left;padding-bottom:12px;'
    end
    doc.css('[data-review-featured-topics] th:first-child').each do |element|
      element['width'] = '10%'
    end
    doc.css('[data-review-featured-topics] th:nth-child(2)').each do |element|
      element['width'] = '60%'
    end
    doc.css('[data-review-featured-topics] th:last-child').each do |element|
      element['width'] = '30%'
    end

    doc.css('[data-review-topic-users] td').each do |element|
      element['style'] = 'padding-bottom: 6px;'
      element['valign'] = 'top'
    end
    doc.css('[data-review-featured-topics] td').each do |element|
      element['style'] = 'padding-bottom: 6px;'
      element['valign'] = 'top'
    end
    doc.css('[data-review-featured-topics] td:nth-child(2)').each do |element|
      element['style'] = 'padding-bottom: 6px;padding-right:6px;'
      element['valign'] = 'top'
    end

    doc.css('[data-review-topic-users] td table td:first-child').each do |element|
      element['style'] = 'padding-bottom:6px;'
        element['width'] = '25'
    end
    doc.css('[data-review-topic-users] td table td:nth-child(2)').each do |element|
      element['style'] = 'padding-left:4px;padding-bottom:6px;'
    end
  end
end
