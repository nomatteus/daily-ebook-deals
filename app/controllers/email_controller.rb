class EmailsController < ApplicationController

  def text

  end

  def html
    render :partial => "emails/template_html.html.erb", :layout => false, :locals => {}
  end

end
