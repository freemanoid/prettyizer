require 'httparty'

class TypeformRequest
  include HTTParty
  base_uri 'https://api.typeform.io/v0.4'

  attr_reader :fields, :title, :form_submit_url

  def initialize(fields:, title:, form_submit_url:)
    @fields, @title, @form_submit_url = fields, title, form_submit_url
  end

  def send
    self.class.post("/forms", body: body, headers: { "X-API-TOKEN" => ENV["TYPEFORM_API_TOKEN"] })
  end

  private def body
    {
      title: title,
      fields: fields,
      webhook_submit_url: "#{ENV["APP_DOMAIN"]}/form_submit?form_submit_url=#{form_submit_url}"
    }.to_json
  end
end
