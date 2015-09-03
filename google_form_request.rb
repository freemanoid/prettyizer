class GoogleFormRequest
  attr_reader :answers, :url

  def initialize(answers:, url:)
    @answers, @url = answers, url
  end

  def perform!
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.path)
    request.add_field('Content-Type', 'application/x-www-form-urlencoded')
    request.body = URI.encode_www_form(answers)

    response = http.request(request)
  end
end
