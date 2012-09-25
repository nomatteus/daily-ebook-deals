class Email < ActiveRecord::Base
  has_one :deal

  # h is a hominid object
  def create_mailchimp_campaign h
    campaign_options = {
      :list_id    => self.mc_list_id,
      :subject    => self.subject,
      :from_email => self.from_email,
      :from_name  => self.from_name,
    }
    #av = ActionView::Base.new(RailsVersion::Application.config.paths["app/views"].first)
    #html = ActionView::Base.new(RailsVersion::Application.config.paths["app/views"].first).render(:partial => "emails/template", :layout => false, :locals => {:deal => Deal.todays_deal})
    #Rails.logger.info html
    campaign_content = {
      :html => self.email_html,
      :text => self.email_text
    }
    if self.mc_campaign_id.nil?
      campaign = h.campaign_create('regular', campaign_options ,campaign_content)
      self.mc_campaign_id = campaign
      self.save
    else
      h.campaign_update(self.mc_campaign_id, 'subject', campaign_options[:subject])
      h.campaign_update(self.mc_campaign_id, 'from_email', campaign_options[:from_email])
      h.campaign_update(self.mc_campaign_id, 'from_name', campaign_options[:from_name])
      h.campaign_update(self.mc_campaign_id, 'content', campaign_content)
    end
    campaign = h.campaigns({:campaign_id => self.mc_campaign_id})["data"][0]
  end

  def send_mailchimp_campaign h
    campaign = h.campaigns({:campaign_id => self.mc_campaign_id})["data"][0]

    # Send a test email
    if h.campaign_send_test(self.mc_campaign_id, ["nomatteus@gmail.com"])
      ap "Test email sent!"
    end

    # Schedule the real email for an hour later... so I have an hour to see the test
    # mail, and stop the email from sending if necessary.
    # in YYYY-MM-DD HH:II:SS format in GMT
    schedule_time = (DateTime.now + 1.hour).utc.strftime("%Y-%m-%d %H:%M:%S")
    if h.campaign_schedule(self.mc_campaign_id, schedule_time)
      ap "Email campaign scheduled for an hour from now! (%s)" % schedule_time
    end

  end

end
