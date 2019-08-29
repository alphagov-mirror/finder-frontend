class ChecklistController < ApplicationController
  include ChecklistHelper
  layout "finder_layout"

  protect_from_forgery except: :confirm_email_signup

  before_action do
    expires_in(5.minutes, public: true)
  end

  def show
    @questions = Checklists::Question.load_all
    @page_service = Checklists::PageService.new(questions: @questions,
                                                criteria_keys: criteria_keys,
                                                current_page_from_params: current_page_from_params)

    return redirect_to_result_page if @page_service.redirect_to_results?

    @current_question = @questions[@page_service.current_page]
    render "checklist/show"
  end

  def results
    all_actions = Checklists::Action.load_all
    @criteria = Checklists::Criterion.load_by(criteria_keys)
    @actions = filter_actions(all_actions, criteria_keys)

    render "checklist/results"
  end

  def email_signup; end

  def confirm_email_signup
    request = Services.email_alert_api.find_or_create_subscriber_list(subscriber_list_options)
    subscriber_list_slug = request.dig("subscriber_list", "slug")

    redirect_to email_alert_frontend_signup_path(topic_id: subscriber_list_slug)
  end

private

  ###
  # Email signup
  ###

  def subscriber_list_options
    path = checklist_results_path(c: criteria_keys)

    {
      "title" => "Your Get ready for Brexit results",
      "slug" => "brexit-checklist-#{criteria_keys.sort.join('-')}",
      "description" => "[You can view a copy of your Brexit tool results](#{Plek.new.website_root}#{path}) on GOV.UK.",
      "tags" => { "brexit_checklist_criteria" => { "any" => criteria_keys } },
      "url" => path,
    }
  end

  ###
  # Redirect
  ###

  def redirect_to_results?
    @page_service.redirect_to_results?
  end

  def redirect_to_result_page
    redirect_to checklist_results_path(filtered_params)
  end

  ###
  # Filtered params
  ###

  def filtered_params
    request.query_parameters.except(:page)
  end
  helper_method :filtered_params

  def criteria_keys
    request.query_parameters.fetch(:c, []).reject(&:blank?)
  end
  helper_method :criteria_keys

  ###
  # Current page
  ###

  def current_page_from_params
    params[:page].to_i
  end

  ###
  # Results page
  ###

  def action_based_description
    if @actions.any?
      t('checklists_results.description')
    else
      t('checklists_results.description_no_actions')
    end
  end
  helper_method :action_based_description

  def action_based_email_link_label
    if @actions.any?
      t('checklists_results.email_sign_up_link')
    else
      t('checklists_results.email_sign_up_link_no_actions')
    end
  end
  helper_method :action_based_email_link_label
end