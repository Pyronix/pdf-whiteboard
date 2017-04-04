class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: "root", password: "123"

  before_action :init_navigation

  def init_navigation
    @nav_entries = [
        { :label => 'Welcome', :path => url_for(controller: 'welcome', action: 'index'), :css => 'fa-dashboard' },
        { :label => 'Show PDFs', :path => pdfs_path, :css => 'fa-eye' },
        { :label => 'Upload PDf', :path => new_pdf_path, :css => 'fa-upload' },
    ]
  end
end
