FactoryBot.define do
  factory :brexit_checker_group, class: BrexitChecker::Groups do
    key { "living-uk" }
    text { "You live in the UK" }

    initialize_with { BrexitChecker::Groups.new(attributes) }
  end
end
