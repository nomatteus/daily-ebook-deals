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

      campaign = h.campaigns({:campaign_id => self.mc_campaign_id})["data"][0]
    end
    campaign
  end


end
