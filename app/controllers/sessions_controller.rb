class SessionsController < ApplicationController
  before_action :check_accounts_enabled

  def create
    redirect_to account_manager_url and return if logged_in?

    redirect_if_not_test Services.oidc.auth_uri(redirect_path: params["redirect_path"])[:uri]
  end

  def callback
    redirect_to Plek.new.website_root and return unless params[:code]

    state = params.require(:state)

    callback = Services.oidc.callback(
      params.require(:code),
      state,
    )

    tokens = callback[:access_token].token_response
    set_account_session_cookie(
      sub: callback[:sub],
      access_token: tokens[:access_token],
      refresh_token: tokens[:refresh_token],
    )

    if callback[:cookie_consent] && cookies[:cookies_policy]
      cookies_policy = JSON.parse(cookies[:cookies_policy]).symbolize_keys
      cookies[:cookies_policy] = cookies_policy.merge(usage: true).to_json
    end

    redirect_if_not_test(callback[:redirect_path] || account_manager_url)
  end

  def delete
    if params[:continue]
      logout!
      redirect_if_not_test "#{account_manager_url}/sign-out?done=#{params[:continue]}"
    elsif params[:done]
      logout!
      redirect_if_not_test "/transition"
    else
      redirect_if_not_test "#{account_manager_url}/sign-out?continue=1"
    end
  end

protected

  def account_manager_url
    Plek.find("account-manager")
  end

  def redirect_if_not_test(url)
    if Rails.env.test?
      render plain: "Redirecting to #{url}"
    else
      redirect_to url
    end
  end
end
