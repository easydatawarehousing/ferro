require_relative 'content_collector'

class ContentBuilder

  def initialize(source_path, content_filename, target_path, sitemap_hostname)
    @target_path = target_path
    mk_target_dir @target_path

    collect_content(source_path, content_filename)
    generate_sitemap(sitemap_hostname)
    precompile
    undigest
    remove_public_assets
    create_index_files
    copy_public_files
  end

  private

  def collect_content(source_path, content_filename)
    puts "Building content file"

    @cc = ContentCollector.new(
      source_path,
      content_filename
    )
  end

  def generate_sitemap(sitemap_hostname)
    if sitemap_hostname
      puts "\nCreate sitemap"
      SitemapGenerator::Sitemap.sitemaps_path = @target_path
      SitemapGenerator::Sitemap.default_host  = sitemap_hostname

      pages = @cc.pagelist

      SitemapGenerator::Sitemap.create do
        pages.each do |page|
          add page, changefreq: 'monthly', priority: 0.5
        end
      end

      # SitemapGenerator::Sitemap.ping_search_engines
      end
  end

  def precompile
    puts "\nPrecompile assets"
    Rake::Task['assets:precompile'].invoke
    Rake::Task['assets:clean'].invoke
  end

  def undigest
    puts "\nUn-digest assets"
    # https://github.com/rails/sprockets-rails/issues/49
    mk_target_dir @target_path.join('javascripts')
    mk_target_dir @target_path.join('stylesheets')

    assets = Dir.glob(File.join(Rails.root, 'public/assets/*'))
    regex = /(-{1}[a-z0-9]{32}*\.{1}){1}/

    assets.each do |file|
      next if File.directory?(file) || file !~ regex

      filename = file.split('/').last.gsub(regex, '.')

      non_digested = if filename =~ /.js|.js.gz\z/
        @target_path.join("javascripts/#{filename}").to_s
      elsif filename =~ /.css|.css.gz\z/
        @target_path.join("stylesheets/#{filename}").to_s
      end

      puts "#{file} =>\n#{non_digested}\n"
      FileUtils.mv(file, non_digested)
    end
  end

  def remove_public_assets
    Dir.entries(Rails.root.join('public/assets')).each do |f|
      if f =~ /sprockets-manifest/
        FileUtils.remove(Rails.root.join("public/assets/#{f}"))
      end
    end

    if Dir.empty?(Rails.root.join('public/assets'))
      FileUtils.remove_dir(Rails.root.join('public/assets'))
    end
  end

  def create_index_files
    index = HomeController.
      render(:index).
      gsub("\n    ", '').
      gsub("\n  ", '')

    puts "\nCreate page: '/'"
    save_file(@target_path.join("index.html"), index)

    @cc.pagelist.each do |page|
      puts "Create page: '#{page}'"
      mk_target_dir(@target_path.join(page))
      save_file(@target_path.join("#{page}/index.html"), index)
    end
  end

  def copy_public_files
    puts "\nCopying public files"
    Dir.entries(Rails.root.join('public')).each do |f|
      if f =~ /.png|.ico|.txt|.jpg\z/
        FileUtils.cp(
          Rails.root.join("public/#{f}"),
          @target_path.join(f)
        )
      end
    end
  end

  def mk_target_dir(target)
    Dir.mkdir(target) if !File.exists?(target)
  end

  def save_file(filename, text)
    f = File.open filename, 'w'
    f.write text
    f.close
  end
end