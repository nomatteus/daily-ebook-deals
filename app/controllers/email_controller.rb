class EmailController < ApplicationController

  # I don't think def text and def html are being used anymore?
  # def text

  # end

  # def html
  #   render :partial => "emails/template_html.html.erb", :layout => false, :locals => {}
  # end

  # Handles an AJAX subscribe request
  def subscribe
    h = Hominid::API.new('5d0ef767e66b59f5eeab6c8971fcade6-us4')

    email = params[:email]

    # Assume only one list exists... if more lists added this will break
    # TODO: Allow for (possibly optional) list ID specification in settings
    list = h.lists["data"][0]

    begin
      result = h.list_subscribe(list["id"], email)
      Rails.logger.info result
    rescue Hominid::APIError => e
      Rails.logger.info "Error! <Hominid::APIError>"
      Rails.logger.info "Message: " + e.message
      message = e.message.sub( %r{<[0-9]{3}>\s+}, "")
      return render :json => {:status => "error", :code => e.fault_code, :message => message}
    end
    if result
      return render :json => {:status => "ok", :code => 200, :message => ""}
    else
      return render :json => {:status => "error", :code => nil, :message => result}
    end
  end

end
