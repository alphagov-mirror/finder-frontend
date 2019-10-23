require "net/http"

class BrexitChecker::LinkMonitor
  def call
    actions = Action.load_all
    actions_with_invalid_title_urls = actions.reject do |action|
      action.title_url.nil? || link_valid?(action.title_url)
    end
    actions_with_invalid_guidance_urls = actions.reject do |action|
      action.guidance_url.nil? || link_valid?(action.guidance_url)
    end
    puts "Invalid title_urls:"
    puts actions_with_invalid_title_urls.map(&:title)
    puts "Invalid guidance_urls:"
    puts actions_with_invalid_guidance_urls.map(&:title)
  end

private

  def link_valid?(url)
    parsed_url = URI.parse(url)
    req = Net::HTTP.new(parsed_url.host, parsed_url.port)
    req.use_ssl = parsed_url.scheme == "https"
    req.request_head(parsed_url.path).code == "200"
  end
end
