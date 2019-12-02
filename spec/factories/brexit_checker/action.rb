FactoryBot.define do
  factory :brexit_checker_action, class: BrexitChecker::Action do
    title { "A title" }
    title_url { "http://www.gov.uk" }
    id { SecureRandom.uuid }
    consequence { "A consequence" }
    priority { 5 }
    criteria { "w%(test)" }
    audience { "business" }

    trait :citizen do
      audience { "citizen" }
      grouping_criteria { "%w(living-uk)" }
      criteria { %w(living-uk) }
    end

    trait :business do
      audience { "business" }
      criteria { "%w(construction)" }
    end

    initialize_with { BrexitChecker::Action.new(attributes) }
  end
end
