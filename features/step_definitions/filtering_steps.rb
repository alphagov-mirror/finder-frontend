Given(/^a collection of documents exist$/) do
  content_store_has_mosw_reports_finder
  stub_rummager_api_request
  stub_taxonomy_api_request
end

Given(/^no results$/) do
  content_store_has_mosw_reports_finder_with_no_facets
  stub_rummager_api_request_with_no_results
  stub_taxonomy_api_request
end

When(/^I view the finder with no keywords and no facets$/) do
  visit finder_path("mosw-reports")
end

And(/there is a zero results message$/) do
  expect(page).to have_content("no matching results")
end

And(/there is not a zero results message$/) do
  expect(page).to_not have_content("no matching results")
end

And(/the page title contains both keywords$/) do
  expect(page).to have_title "Keyword1 Keyword2 - News and communications - GOV.UK"
end

And(/the page title contains only Keyword2$/) do
  expect(page).to have_title "Keyword2 - News and communications - GOV.UK"
end

And(/the page title contains no keywords$/) do
  expect(page).to have_title "News and communications - GOV.UK"
end

And(/the page title is updated$/) do
  expect(page).to have_title "keyword searchable - Ministry of Silly Walks reports - GOV.UK"
end

Then(/^I can get a list of all documents with matching metadata$/) do
  visit finder_path("mosw-reports")

  expect(page).to have_content("2 reports")
  expect(page).to have_css(".finder-results .gem-c-document-list__item", count: 2)
  expect(page).to have_css(".gem-c-metadata")

  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_link(
      "West London wobbley walk",
      href: "/mosw-reports/west-london-wobbley-walk",
    )
    expect(page).to have_content("30 December 2003")
    expect(page).to have_content("Backward")
  end

  visit_filtered_finder("walk_type" => "hopscotch")

  expect(page).to have_content("1 report")
  expect(page).to have_css(".finder-results .gem-c-document-list__item", count: 1)
end

And("I see email and feed sign up links") do
  expect(page).to have_css('a[href="/search/news-and-communications/email-signup"]')
  expect(page).to have_css('a[href="/search/news-and-communications.atom"]')
end

And("I see only one email and feed sign up link on mobile") do
  width = page.driver.browser.manage.window.size.width
  height = page.driver.browser.manage.window.size.height
  page.driver.browser.manage.window.resize_to(375, 812)
  expect(page).to have_css('a[href="/search/news-and-communications/email-signup"]', count: 1)
  expect(page).to have_css('a[href="/search/news-and-communications.atom"]', count: 1)
  page.driver.browser.manage.window.resize_to(width, height)
end

And("I see email and feed sign up links with filters applied") do
  expect(page).to have_css('a[href="/search/news-and-communications/email-signup?people%5B%5D=rufus-scrimgeour"]')
  expect(page).to have_css('a[href="/search/news-and-communications.atom?people%5B%5D=rufus-scrimgeour"]')
end

And("I see email and feed sign up links with filters and order applied") do
  expect(page).to have_css('a[href="/search/news-and-communications/email-signup?people%5B%5D=rufus-scrimgeour&order=updated-newest"]')
  expect(page).to have_css('a[href="/search/news-and-communications.atom?people%5B%5D=rufus-scrimgeour&order=updated-newest"]')
end

When(/^I view a list of news and communications$/) do
  topic_taxonomy_has_taxons
  content_store_has_news_and_communications_finder
  stub_world_locations_api_request
  stub_people_registry_request
  stub_organisations_registry_request
  stub_rummager_api_request_with_news_and_communication_results
  visit finder_path("search/news-and-communications")
end

When(/^I view the news and communications finder$/) do
  stub_taxonomy_api_request
  content_store_has_news_and_communications_finder
  stub_world_locations_api_request
  stub_all_rummager_api_requests_with_news_and_communication_results
  stub_people_registry_request
  stub_organisations_registry_request
  visit finder_path("search/news-and-communications")
end

When(/^I view the news and communications finder filtered on the transition period topic$/) do
  stub_taxonomy_api_request
  content_store_has_news_and_communications_finder
  stub_world_locations_api_request
  stub_all_rummager_api_requests_with_news_and_communication_results
  stub_people_registry_request
  stub_organisations_registry_request
  visit finder_path("search/news-and-communications", topic: "d6c2de5d-ef90-45d1-82d4-5f2438369eea")
end

Then(/^I (can|cannot) see the "show only transition period results" checkbox$/) do |can_or_cannot|
  have_clause = have_css(".govuk-checkboxes__label", text: "Show only transition period results")
  if can_or_cannot == "can"
    expect(page).to have_clause
  else
    expect(page).to_not have_clause
  end
end

When(/^I view the policy papers and consultations finder$/) do
  topic_taxonomy_has_taxons
  content_store_has_policy_and_engagement_finder
  stub_organisations_registry_request
  stub_world_locations_api_request
  stub_rummager_api_request_with_policy_papers_results
  stub_rummager_api_request_with_filtered_policy_papers_results

  visit finder_path("search/policy-papers-and-consultations")
end

When(/^I view the research and statistics finder$/) do
  topic_taxonomy_has_taxons
  content_store_has_statistics_finder
  stub_organisations_registry_request
  stub_manuals_registry_request
  stub_world_locations_api_request
  stub_rummager_api_request_with_research_and_statistics_results
  stub_rummager_api_request_with_filtered_research_and_statistics_results
  visit finder_path("search/research-and-statistics")
end

When(/^I view the research and statistics finder with a topic param set$/) do
  topic_taxonomy_has_taxons([
    FactoryBot.build(
      :level_one_taxon_hash,
      content_id: "c58fdadd-7743-46d6-9629-90bb3ccc4ef0",
      title: "Education, training and skills",
    ),
  ])
  content_store_has_statistics_finder
  stub_organisations_registry_request
  stub_manuals_registry_request
  stub_world_locations_api_request
  stub_rummager_api_request_with_research_and_statistics_results
  stub_rummager_api_request_with_filtered_research_and_statistics_results
  visit finder_path("search/research-and-statistics", topic: "c58fdadd-7743-46d6-9629-90bb3ccc4ef0")
end

When(/^I view the aaib reports finder with a topic param set$/) do
  topic_taxonomy_has_taxons([
    FactoryBot.build(
      :level_one_taxon_hash,
      content_id: "c58fdadd-7743-46d6-9629-90bb3ccc4ef0",
      title: "Education, training and skills",
    ),
  ])
  content_store_has_aaib_reports_finder
  stub_organisations_registry_request
  stub_manuals_registry_request
  stub_world_locations_api_request
  stub_rummager_api_request_with_aaib_reports_results
  visit finder_path("aaib-reports", topic: "c58fdadd-7743-46d6-9629-90bb3ccc4ef0")
end

When(/^I view the all content finder with a manual filter$/) do
  topic_taxonomy_has_taxons
  content_store_has_all_content_finder
  stub_organisations_registry_request
  stub_world_locations_api_request
  stub_people_registry_request
  stub_manuals_registry_request

  stub_request(:get, DocumentHelper::SEARCH_ENDPOINT)
    .with(query: hash_including(q: "Replacing bristles", order: "-public_timestamp"))
    .to_return(body: all_content_results_json)

  stub_request(:get, DocumentHelper::SEARCH_ENDPOINT)
    .with(query: hash_including(
      filter_manual: "/guidance/care-and-use-of-a-nimbus-2000",
      q: "Replacing bristles",
      order: "-public_timestamp",
    )).to_return(body: all_content_manuals_results_json)

  visit finder_path("search/all", manual: "/guidance/care-and-use-of-a-nimbus-2000", q: "Replacing bristles")
end

When(/^I view the all content finder$/) do
  topic_taxonomy_has_taxons
  content_store_has_all_content_finder
  stub_organisations_registry_request
  stub_world_locations_api_request
  stub_people_registry_request
  stub_manuals_registry_request
  stub_rummager_api_request_with_all_content_results

  visit finder_path("search/all")
end

When(/^I view a list of services$/) do
  topic_taxonomy_has_taxons
  content_store_has_services_finder
  stub_rummager_api_request_with_services_results
  stub_people_registry_request
  stub_organisations_registry_request

  visit finder_path("search/services")
end

When(/^I search documents by keyword$/) do
  stub_keyword_search_api_request

  visit finder_path("mosw-reports")

  @keyword_search = "keyword searchable"

  within ".filter-form" do
    fill_in("Search", with: @keyword_search)
  end
  within ".js-live-search-fallback" do
    click_on "Filter results"
  end
end

Then(/^I see all documents which contain the keywords$/) do
  within ".filtered-results" do
    expect(page).to have_css("a", text: @keyword_search)
  end
end

When(/^I visit a finder by keyword with q parameter$/) do
  stub_keyword_search_api_request

  visit finder_path("mosw-reports", q: @keyword_search)
end

Given(/^a government finder exists$/) do
  stub_taxonomy_api_request
  content_store_has_government_finder
  stub_rummager_api_request_with_government_results
  stub_organisations_registry_request
end

Then(/^I can see the government header$/) do
  visit finder_path("government/policies/benefits-reform")
  expect(page).to have_css("#proposition-menu")
end

Then(/^I should see a blue banner$/) do
  expect(page).to have_css(".gem-c-inverse-header")
  expect(page).to have_content("Education, training and skills")
  expect(page).to_not have_css(".app-taxonomy-select")
end

Then(/^I can see documents which are marked as being in history mode$/) do
  expect(page).to have_css(".published-by", count: 5)
  expect(page).to have_content("2005 to 2010 Labour government")
end

Then(/^I can see documents which have government metadata$/) do
  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_content("Updated:")
    expect(page).to have_css('dl time[datetime="2007-02-14"]')

    expect(page).to have_content("News Story")

    expect(page).to have_content("Ministry of Justice")
  end
end

Then(/^I see the atom feed$/) do
  expect(page).to have_selector("id", text: "tag:www.dev.gov.uk,2005:/restrictions-on-usage-of-spells-within-school-grounds")
  expect(page).to have_selector("updated", text: "2017-12-30T10:00:00Z")
  expect(page).to have_selector(:css, 'link[href="http://www.dev.gov.uk/restrictions-on-usage-of-spells-within-school-grounds"]')
  expect(page).to have_selector("title", text: "Restrictions on usage of spells within school grounds")
  expect(page).to have_selector("summary", text: "Restrictions on usage of spells within school grounds")
end

Given(/^a collection of documents with bad metadata exist$/) do
  stub_taxonomy_api_request
  content_store_has_mosw_reports_finder
  stub_rummager_api_request_with_bad_data
end

Then(/^I can get a list of all documents with good metadata$/) do
  visit finder_path("mosw-reports")
  expect(page).to have_css(".finder-results .gem-c-document-list__item", count: 2)

  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_content("Backward")
    expect(page).not_to have_content("England")
  end

  within ".finder-results .gem-c-document-list__item:nth-child(2)" do
    expect(page).to have_content("Northern Ireland")
    expect(page).not_to have_content("Hopscotch")
  end
end

Given(/^a finder tagged to the topic taxonomy$/) do
  stub_taxonomy_api_request
  stub_content_store_with_a_taxon_tagged_finder
  stub_rummager_with_cma_cases
end

Given(/^a collection of documents that can be filtered by dates$/) do
  stub_taxonomy_api_request
  stub_content_store_with_cma_cases_finder
  stub_rummager_with_cma_cases
end

When(/^I use a date filter$/) do
  visit_cma_cases_finder
  apply_date_filter
end

When(/^I use a collection of documents exist that can be filtered by checkbox filter$/) do
  visit_cma_cases_finder
  apply_date_filter
end

Then(/^I only see documents with matching dates$/) do
  assert_cma_cases_are_filtered_by_date
end

Given(/^a finder with a dynamic filter exists$/) do
  stub_taxonomy_api_request
  content_store_has_mosw_reports_finder
  stub_rummager_api_request
end

Then(/^I can see filters based on the results$/) do
  visit finder_path("mosw-reports")

  within first(".app-c-option-select") do
    expect(page).to have_selector("input#walk_type-backward")
    expect(page).to have_content("Hopscotch")
    expect(page).to_not have_selector("input#organisations-ministry-of-silly-walks")
  end
end

And(/^filters are wrapped in a progressive disclosure element$/) do
  expect(page).to have_selector("#facet-wrapper")
end

And(/^filters are not wrapped in a progressive disclosure element$/) do
  expect(page).not_to have_selector("#facet-wrapper")
end

Given(/^a finder with paginated results exists$/) do
  stub_taxonomy_api_request
  content_store_has_government_finder_with_10_items
  stub_rummager_api_request_with_10_government_results
  stub_rummager_api_request_with_query_param_no_results("xxxxxxxxxxxxxxYYYYYYYYYYYxxxxxxxxxxxxxxx")
end

Then(/^I can see pagination$/) do
  visit finder_path("government/policies/benefits-reform")

  expect(page).not_to have_content("Previous page")
  expect(page).to have_content("Next page")
end

Then(/^I can browse to the next page$/) do
  stub_rummager_api_request_with_10_government_results_page_2
  visit finder_path("government/policies/benefits-reform", page: 2)

  expect(page).to have_content("Previous page")
  expect(page).not_to have_content("Next page")
end

Then(/^I browse to a huge page number and get an appropriate error$/) do
  stub_rummager_api_request_with_422_response(999_999)
  visit finder_path("government/policies/benefits-reform", page: 999_999)

  expect(page.status_code).to eq(422)
end

And("I click on the atom feed link") do
  within("#subscription-links-footer") do
    click_on "Subscribe to feed"
  end
end

And("there is machine readable information") do
  schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
  schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

  org_schema = schemas.detect { |schema| schema["@type"] == "SearchResultsPage" }
  expect(org_schema["name"]).to_not be_nil

  tag = "link[rel='canonical']"
  expect(page).to have_css(tag, visible: false)
end

Then(/^I can see that Google won't index the page$/) do
  tag = "meta[name='robots'][content='noindex']"
  expect(page).to have_css(tag, visible: false)
end

Then(/^I can see that Google can index the page$/) do
  tag = "meta[name='robots'][content='noindex']"
  expect(page).not_to have_css(tag, visible: false)
end

Given(/^a finder with description exists$/) do
  stub_taxonomy_api_request
  stub_content_store_with_cma_cases_finder_with_description
  stub_rummager_with_cma_cases
end

Given(/^a finder with a no_index property exists$/) do
  stub_taxonomy_api_request
  stub_content_store_with_cma_cases_finder_with_no_index
  stub_rummager_with_cma_cases
end

Given(/^a finder with metadata exists$/) do
  stub_taxonomy_api_request
  stub_content_store_with_cma_cases_finder_with_metadata
  stub_rummager_with_cma_cases
end

Given(/^a finder with metadata with a topic param set exists$/) do
  stub_taxonomy_api_request
  stub_content_store_with_cma_cases_finder_with_metadata_with_topic_param
  stub_rummager_with_cma_cases
end

When(/^I can see that the finder metadata is present$/) do
  visit "/cma-cases"

  expect(page).to have_css(".gem-c-metadata")
  expect(page).to_not have_css(".gem-c-metadata.gem-c-metadata--inverse")
end

When(/^I can see that the finder metadata is present and inverted$/) do
  expect(page).to have_css(".gem-c-metadata")
  expect(page).to have_css(".gem-c-metadata.gem-c-metadata--inverse")
end

When(/^I can see that the description in the metadata is present$/) do
  visit "/cma-cases"

  desc_text = "Find reports and updates on current and historical CMA investigations"
  desc_tag = "meta[name='description'][content='#{desc_text}']"
  expect(page).to have_css(desc_tag, visible: false)
end

When(/^I can see that the noindex tag is is present in the metadata$/) do
  visit "/cma-cases"

  noindex_tag = "meta[name='robots'][content='noindex']"
  expect(page).to have_css(noindex_tag, visible: false)
end

Given(/^an organisation finder exists$/) do
  stub_taxonomy_api_request
  content_store_has_government_finder
  stub_rummager_api_request_with_government_results
  stub_organisations_registry_request
  stub_people_registry_request
  stub_taxonomy_api_request

  visit finder_path("government/policies/benefits-reform", parent: "ministry-of-magic")
end

Given(/^an organisation finder exists but a bad breadcrumb path is given$/) do
  stub_taxonomy_api_request
  content_store_has_government_finder
  stub_rummager_api_request_with_government_results
  stub_organisations_registry_request
  stub_people_registry_request
  stub_taxonomy_api_request

  visit finder_path("government/policies/benefits-reform", parent: "bernard-cribbins")
end

Then(/^I can see a breadcrumb for home$/) do
  expect(page).to have_link("Home", href: "/")
  expect(page).to have_css("a[data-track-category='homeLinkClicked']", text: "Home")
  expect(page).to have_css("a[data-track-action='homeBreadcrumb']", text: "Home")
  expect(page).to have_css("a[data-track-label='']", text: "Home")
  expect(page).to have_css("a[data-track-options='{}']", text: "Home")
end

Then(/^I can see a breadcrumb for all organisations$/) do
  expect(page).to have_link("Organisations", href: "/government/organisations")
  expect(page).to have_css("a[data-track-category='breadcrumbClicked']", text: "Organisations")
  expect(page).to have_css("a[data-track-action='2']", text: "Organisations")
  expect(page).to have_css("a[data-track-label='/government/organisations']", text: "Organisations")
  expect(page).to have_css("a[data-track-options='{\"dimension28\":\"3\",\"dimension29\":\"Organisations\"}']", text: "Organisations")
end

And(/^no breadcrumb for all organisations$/) do
  expect(page).to_not have_link("Organisations", href: "/government/organisations")
end

Then(/^I can see a breadcrumb for the organisation$/) do
  expect(page).to have_link("Ministry of Magic", href: "/government/organisations/ministry-of-magic")
  expect(page).to have_css("a[data-track-category='breadcrumbClicked']", text: "Ministry of Magic")
  expect(page).to have_css("a[data-track-action='3']", text: "Ministry of Magic")
  expect(page).to have_css("a[data-track-label='/government/organisations/ministry-of-magic']", text: "Ministry of Magic")
  expect(page).to have_css("a[data-track-options='{\"dimension28\":\"3\",\"dimension29\":\"Ministry of Magic\"}']", text: "Ministry of Magic")
end

Then(/^I can see taxonomy breadcrumbs$/) do
  visit finder_path("cma-cases")
  expect(page).to have_selector(".govuk-breadcrumbs.gem-c-breadcrumbs--collapse-on-mobile")
  expect(page).to have_selector(".govuk-breadcrumbs__list-item", text: "Competition Act and cartels")
  expect(page.find_all(".govuk-breadcrumbs__list-item").count).to eql(2)
end

Then(/^I can see Brexit taxonomy breadcrumbs$/) do
  expect(page).to have_selector(".govuk-breadcrumbs.gem-c-breadcrumbs--collapse-on-mobile")
  expect(page.find_all(".govuk-breadcrumbs__list-item").count).to eql(3)
  expect(page).to have_selector(".govuk-breadcrumbs__list-item", text: "Home")
  expect(page).to have_selector(".govuk-breadcrumbs__list-item", text: "Government")
  expect(page).to have_selector(".govuk-breadcrumbs__list-item", text: "Brexit")
end

Given(/^a collection of documents exist that can be filtered by checkbox$/) do
  stub_taxonomy_api_request
  stub_content_store_with_cma_cases_finder_for_supergroup_checkbox_filter
  stub_rummager_with_cma_cases_for_supergroups_checkbox
  visit_cma_cases_finder
end

When(/^I use a checkbox filter$/) do
  find("label", text: "Show open cases").click
  within ".js-live-search-fallback" do
    click_on "Filter results"
  end
end

Then(/^I only see documents that match the checkbox filter$/) do
  expect(page).to have_content("1 case")
  expect(page).to have_css(".facet-tags__preposition", text: "That Is")
  expect(page).to have_css(".facet-tag__text", text: "Open")

  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_content("Big Beer Co / Salty Snacks Ltd merger inquiry")
    expect(page).to_not have_content("Bakery market investigation")
  end
end

Then(/^The checkbox has the correct tracking data$/) do
  expect(page).to have_css("input[type='checkbox'][data-track-category='filterClicked']")
  expect(page).to have_css("input[type='checkbox'][data-track-action='checkboxFacet']")
  expect(page).to have_css("input[type='checkbox'][data-track-label='Show open cases']")
  expect(page).to_not have_css("input[type='checkbox'][data-module='track-click']")
end

Then(/^I can sort by:$/) do |table|
  expect(find_all(".js-order-results option").collect(&:text)).to eq(table.raw.flatten)
end

When(/^I sort by most viewed$/) do
  select "Most viewed", from: "order"
end

When(/^I sort by A-Z$/) do
  select "A-Z", from: "order"
end

When(/^I sort by most relevant$/) do
  select "Relevance", from: "Sort by"
end

When(/^I filter the results$/) do
  within ".js-live-search-fallback" do
    click_on "Filter results"
  end
end

Then(/^I see the most viewed articles first$/) do
  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_content("Press release from Hogwarts")
    expect(page).to have_content("25 December 2017")
  end

  within ".finder-results .gem-c-document-list__item:nth-child(2)" do
    expect(page).to have_content("16 November 2018")
  end

  expect(page).to have_css("a[data-track-category='navFinderLinkClicked']")
  expect(page).to have_css("#order", text: "Most viewed")
end

Then(/^I see services in alphabetical order$/) do
  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_content("Apply for your full broomstick licence")
  end

  within ".finder-results .gem-c-document-list__item:nth-child(2)" do
    expect(page).to have_content("Register a magical spell")
  end

  expect(page).to have_css("a[data-track-category='navFinderLinkClicked']")
  expect(page).to have_css("#order", text: "A-Z")
end

Then(/^I see most relevant order selected$/) do
  expect(page).to have_select("order", selected: "Relevance")
end

Then(/^I see (.*) order selected$/) do |label|
  expect(page).to have_select("order", selected: label)
end

And(/^I see the facet tag$/) do
  within first ".facet-tags" do
    expect(page).to have_button("✕")
    expect(page).to have_content("Open")
    expect(page).to have_css("[data-module='remove-filter-link']")
    expect(page).to have_css("[aria-label='Remove filter Open']")
  end
end

And(/^I select a taxon$/) do
  select("Taxon_1", from: "Topic")
end

And(/^I select a Person$/) do
  check("Rufus Scrimgeour")
end

And(/^I select some document types$/) do
  click_on("Document type")
  find(".govuk-checkboxes__item .govuk-label", text: "Policy papers").click
  find(".govuk-checkboxes__item .govuk-label", text: "Consultations (closed)").click
end

And(/^I select upcoming statistics$/) do
  find(".govuk-label", text: "Statistics (upcoming)").click
end

And(/^I select published statistics$/) do
  find(".govuk-label", text: "Statistics (published)").click
end

And(/^I click filter results$/) do
  within ".js-live-search-fallback" do
    click_on "Filter results"
  end
end

And(/^I reload the page$/) do
  visit [current_path, page.driver.request.env["QUERY_STRING"]].reject(&:blank?).join("?")
end

Then(/^I should see all people in the people facet$/) do
  expect(page).to have_css('input[id^="people-"]', count: 5)
  find("label", text: "Albus Dumbledore")
  find("label", text: "Cornelius Fudge")
  find("label", text: "Harry Potter")
  find("label", text: "Ron Weasley")
  find("label", text: "Rufus Scrimgeour")
end

And(/^I should see all organisations in the organisation facet$/) do
  expect(page).to have_css('input[id^="organisations-"]', count: 4)
  find("label", text: "Department of Mysteries")
  find("label", text: "Gringots")
  find("label", text: "Ministry of Magic")
  find("label", text: "Closed organisation: Death Eaters")
end

Then(/^I should see all world locations in the world location facet$/) do
  expect(page).to have_css('input[id^="world_locations-"]', count: 2)
  find("label", text: "Azkaban")
  find("label", text: "Tracy Island")
end

And(/^I select a World Location$/) do
  click_on("World location")
  check("Azkaban")
end

And(/^I click button \"([^\"]*)\" and select facet (.*)$/) do |button, facet|
  click_on(button)
  find("label", text: facet).click
end

And(/^I select facet (.*) in the already expanded \"([^\"]*)\" section$/) do |facet, _button|
  find("label", text: facet).click
end

When(/^I click the (.*) remove control$/) do |filter|
  expect(page).to have_css(".js-enabled")

  button = page.find("span[class='facet-tag__text']", text: filter).sibling("button[data-module='remove-filter-link']")
  button.click

  expect(page).to_not have_selector("span[class='facet-tag__text']", text: filter)
end

Then(/^The (.*) checkbox in deselected$/) do |checkbox|
  expect(page.find("##{checkbox}", visible: :all)).to_not be_checked
end

And(/^I fill in some keywords$/) do
  fill_in "Search", with: "Keyword1 Keyword2\n"
end

When(/^I fill in a keyword that should match no results$/) do
  fill_in "Search", with: "xxxxxxxxxxxxxxYYYYYYYYYYYxxxxxxxxxxxxxxx\n"
end

And(/^I submit the form$/) do
  page.execute_script("$('form.js-live-search-form').submit()")
end

Then(/^The keyword textbox is empty$/) do
  expect(page).to have_field("Search", with: "")
end

Then(/^The keyword textbox only contains (.*)$/) do |filter|
  expect(page).to have_field("Search", with: filter)
end

When(/^I use a checkbox filter and another disallowed filter$/) do
  find("label", text: "Show open cases").click
  fill_in("closed_date[from]", with: "1st November 2015")
  stub_rummager_with_cma_cases_for_supergroups_checkbox_and_date
  within ".js-live-search-fallback" do
    click_on "Filter results"
  end
end

Then(/^I can sign up to email alerts for allowed filters$/) do
  stub_email_alert_api_has_subscriber_list(
    "tags" => { "case_type" => { any: %w[ca98-and-civil-cartels] }, "format" => { any: %w[cma_case] } },
    "subscription_url" => "http://www.rathergood.com",
  )

  stub_content_store_has_item("/cma-cases/email-signup", cma_cases_with_multi_facets_signup_content_item)

  within "#subscription-links-footer" do
    click_link("Get emails")
  end

  begin
    click_on("Continue")
  rescue ActionController::RoutingError
    expect(page.status_code).to eq(302)
    expect(page.response_headers["Location"]).to eql("http://www.rathergood.com")
  end
end

When("I create an email subscription") do
  within "#subscription-links-footer" do
    click_link("Get emails")
  end
end

Then("I should see results in the default group") do
  within("#js-results .filtered-results__group") do
    expect(page.all(".gem-c-document-list__item").size).to eq(9) # 9 results in fixture
  end
end

Then("I should see results for scoped by the selected document type") do
  expect(page).to have_text("3 results")
  within("#js-results") do
    expect(page.all(".gem-c-document-list__item").size).to eq(3) # 3 results in fixture
    expect(page).to have_link("Restrictions on usage of spells within school grounds")
    expect(page).to have_link("New platform at Hogwarts for the express train")
    expect(page).to have_link("Installation of double glazing at Hogwarts")

    expect(page).to have_no_link("Proposed changes to magic tournaments")
  end
end

Then("I see results grouped by primary facet value") do
  within("#js-results") do
    expect(page.all(".filtered-results__group").size).to eq(2)

    within(".filtered-results__group:nth-child(1)") do
      expect(page).to have_css("h2.filtered-results__facet-heading", text: "Aerospace")
    end

    within(".filtered-results__group:nth-child(2)") do
      expect(page).to have_css("h2.filtered-results__facet-heading", text: "All businesses")
    end
  end
end

Then("I see results with top result") do
  within("#js-results") do
    expect(page.all(".gem-c-document-list__item--highlight").length).to eq(1)
  end
end

Then("I should see upcoming statistics") do
  expect(page).to have_text("1 result")
  within("#js-results") do
    expect(page.all(".gem-c-document-list__item").size).to eq(1)
    expect(page).to have_link("Restrictions on usage of spells within school grounds")
    expect(page).to have_no_link("New platform at Hogwarts for the express train")
    expect(page).to have_no_link("Installation of double glazing at Hogwarts")
    expect(page).to have_no_link("Proposed changes to magic tournaments")
  end
end

And(/^I press (tab) key to navigate$/) do |key|
  find_field("Search").send_keys key.to_sym
end

Then(/^I click "(.*)" to expand|collapse all facets/) do |link_text|
  click_button(link_text)
end

And(/^I visit the benefits-reform page$/) do
  visit finder_path("government/policies/benefits-reform")
end

Then(/^I should see results and pagination$/) do
  expect(page).to have_text("20 reports")
  expect(page).to have_css(".finder-results", visible: true)
  expect(page).to have_css(".gem-c-pagination")
end

Then(/^the results and pagination should be removed$/) do
  expect(page).not_to have_text("20 reports")
  expect(page).to have_css(".finder-results", visible: false)
  expect(page).to_not have_css(".gem-c-pagination")
end

Then(/^I should (see|not see) a "Skip to results" link$/) do |can_be_seen|
  visibility = can_be_seen == "see"
  expect(page).to have_css('[href="#js-results"]', visible: visibility)
end

Then(/^the page has results region$/) do
  expect(page).to have_css('[id="js-results"]')
end

Then(/^the page has a landmark to the search results$/) do
  expect(page).to have_css('[class="govuk-grid-column-two-thirds js-live-search-results-block filtered-results"][role="region"][aria-label$="search results"]')
end

Then(/^the page has a landmark to the search filters$/) do
  expect(page).to have_css('.govuk-grid-column-one-third[role="search"][aria-label]')
end

And(/^I should not see an upcoming statistics facet tag$/) do
  expect(page).to_not have_css("span.facet-tag__text", text: "Upcoming statistics")
end

And(/^The top result has the correct tracking data$/) do
  expect(page).to have_css("a[data-track-category='navFinderLinkClicked']")
end

Then(/^I can see results filtered by that manual$/) do
  expect(page).to have_css(".finder-results .gem-c-document-list__item", count: 1)

  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to_not have_content("Restrictions on usage of spells within school grounds")
    expect(page).to have_content("Replacing bristles in your Nimbus 2000")
  end
end

Then(/^I see all content results$/) do
  expect(page).to have_css(".finder-results .gem-c-document-list__item", count: 1)

  within ".finder-results .gem-c-document-list__item:nth-child(1)" do
    expect(page).to have_content("Restrictions on usage of spells within school grounds")
    expect(page).to_not have_content("Replacing bristles in your Nimbus 2000")
  end
end
