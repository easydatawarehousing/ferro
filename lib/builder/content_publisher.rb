require_relative 'content_builder'

class ContentPublisher

  def initialize(source_path, content_filename, target_path, sitemap_hostname)
    @source_path      = source_path
    @content_filename = content_filename
    @target_path      = target_path
    @sitemap_hostname = sitemap_hostname

    publish
  end

  private

  def publish
    git_status

    if @clean
      build
      puts "\nDone\nPublish with:\ngit add .\ngit commit -m \"#{git_message}\"\ngit push origin master"
    else
      puts 'Please make sure there are no changes to commit.'
    end
  end

  def build
    @cb = ContentBuilder.new(
      @source_path,
      @content_filename,
      @target_path,
      @sitemap_hostname
    )
  end

  def git_status
    sts = `git status`
    @branch = sts.scan(/on branch (.*)\n/i)&.first&.first&.strip
    @clean  = sts =~ /your branch is up\-to\-date/i || sts =~ /.*nothing to commit/i || false
  end

  def git_message
    head = `git log --pretty="%h" -n1`.strip
    "Site updated to #{head}"
  end
end