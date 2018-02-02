namespace :content do

  desc "Collect content markdown files and create a json file in public folder"
  task :collect => :environment do

    require_relative '../collector/content_collector'

    ContentCollector.new(
      Rails.root.join('content'),
      Rails.root.join('public/main_content.json')
    )
  end

  desc "Build all static website files"
  task :build => :environment do

    if Rails.env.production?
      require_relative '../builder/content_builder'

      ContentBuilder.new(
        Rails.root.join('content'),
        Rails.root.join('public/main_content.json'),
        Rails.root.join('public'),
        'https://example.com'
      )
    else
      puts "Please set 'RAILS_ENV=production' first"
    end
  end

  desc "Build website and publish to github pages (master branch /docs folder)"
  task :build_and_gh_publish => :environment do

    if Rails.env.production?
      require_relative '../builder/content_publisher'

      ContentPublisher.new(
        Rails.root.join('content'),
        Rails.root.join('docs/main_content.json'),
        Rails.root.join('docs'),
        'https://easydatawarehousing.github.io/ferro/'
      )
    else
      puts "Please set 'RAILS_ENV=production' first"
    end
  end
end