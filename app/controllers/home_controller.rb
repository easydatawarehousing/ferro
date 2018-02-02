class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { sleep 2; render json: { msg: 'Computer says no' }, status: 501 }
    end
  end

  def content
    content_file = Rails.root.join('tmp/main_content.json')

    ContentCollector.new(
      Rails.root.join('content'),
      content_file,
      false
    )

    send_file(content_file, filename: 'main_content.json',  type: 'application/json')
  end
end