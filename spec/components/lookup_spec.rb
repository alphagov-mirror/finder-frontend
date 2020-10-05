require "spec_helper"

describe "lookup", type: :view do
  def component_name
    "lookup"
  end

  def render_component(locals)
    if block_given?
      render("components/#{component_name}", locals) { yield }
    else
      render "components/#{component_name}", locals
    end
  end

  it "displays external link" do
    render_component(link: { text: "Find a postcode on Royal Mail", href: "royalmail.com/share" }) do
      "This is more info"
    end
    assert_select ".govuk-link--external"
    assert_select ".govuk-link.govuk-link--external", text: "Find a postcode on Royal Mail"
    assert_select ".govuk-link.govuk-link--external", href: /royalmail\.com\/share/
  end

  it "displays inline input error alert" do
    render_component(location_error: true) do
      "This is more info"
    end
    assert_select ".gem-c-error-message"
  end

  it "displays error alert box" do
    render_component(location_error: true, error_message: "This isn't a valid postcode.") do
      "This is more info"
    end
    assert_select ".gem-c-error-alert"
    assert_select ".gem-c-error-summary__title", text: "This isn't a valid postcode."
  end

  it "has lookup question" do
    render_component(input_question: "Enter a postcode") do
      "This is more info"
    end
    assert_select "label.gem-c-label.govuk-label.govuk-label--s", text: "Enter a postcode"
  end

  it "missing lookup question" do
    render_component(input_question: "Enter a postcode") do
      "This is more info"
    end
    assert_select "label.gem-c-label.govuk-label.govuk-label--s", text: "Enter a postcode"
  end

  it "contains lookup hint text" do
    render_component(hint_text: "For example SW1A 2AA") do
      "This is more info"
    end
    assert_select ".govuk-hint", text: "For example SW1A 2AA"
  end

  it "contains lookup button and text" do
    render_component(button_text: "Find") do
      "This is more info"
    end
    assert_select ".gem-c-button", text: "Find"
  end

  it "contains autocomplete" do
    render_component(autocomplete: "postcode") do
      "This is more info"
    end
    assert_select ".gem-c-input.govuk-input"
    assert_select ".gem-c-input.govuk-input", autocomplete: "postcode"
  end

end
