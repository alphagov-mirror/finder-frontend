FinderFrontend::Application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/healthcheck.json",
      to: GovukHealthcheck.rack_response(
        Healthchecks::RegistriesCache,
      )
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  root to: redirect("/development") unless Rails.env.test?
  get "/development" => "development#index"

  get "/search" => "search#index", as: :search
  get "/search/opensearch" => "search#opensearch"

  if ENV["GOVUK_WEBSITE_ROOT"] =~ /integration/ || ENV["GOVUK_WEBSITE_ROOT"] =~ /staging/
    get "/test-search/search" => "search#index"
    get "/test-search/search/opensearch" => "search#opensearch"
  end

  # Routes for the for Brexit Checker
  get "/transition-check/results" => "brexit_checker#results", as: :transition_checker_results
  get "/transition-check/questions" => "brexit_checker#show", as: :transition_checker_questions
  get "/transition-check/email-signup" => "brexit_checker#email_signup", as: :transition_checker_email_signup
  post "/transition-check/email-signup" => "brexit_checker#confirm_email_signup", as: :transition_checker_confirm_email_signup

  get "/email/subscriptions/new", to: proc { [200, {}, [""]] }, as: :email_alert_frontend_signup

  get "/*slug/email-signup" => "email_alert_subscriptions#new", as: :new_email_alert_subscriptions
  post "/*slug/email-signup" => "email_alert_subscriptions#create", as: :email_alert_subscriptions

  # Q&A frontend for "UK Nationals in the EU" (www.gov.uk/uk-nationals-in-the-eu)
  get "/uk-nationals-living-eu" => "qa_to_content#show"

  get "/search/advanced" => "redirection#advanced_search"
  get "/postcode-lookup" => "post_code_lookup#show"

  get "/*slug" => "redirection#redirect_covid", constraints: lambda { |request|
    topical_events = request.params["topical_events"]

    request.format == :html &&
      topical_events &&
      topical_events.include?("coronavirus-covid-19-uk-government-response")
  }

  get "/*slug" => "finders#show", as: :finder
end
