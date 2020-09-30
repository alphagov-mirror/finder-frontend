class BrexitChecker::AccountJwt
  def initialize(criteria_keys)
    @criteria_keys = criteria_keys
  end

  def encode(key = ecdsa_key, algorithmn = "ES256")
    JWT.encode payload, key, algorithmn
  end

private

  attr_reader :criteria_keys

  def payload
    {
      uid: client_oauth_id,
      key: client_oauth_key_uuid,
      scopes: scopes,
      attributes: attributes,
    }
  end

  def scopes
    %w[transition_checker]
  end

  def attributes
    { transition_checker_state: criteria_keys }
  end

  def client_oauth_id
    ENV.fetch("GOVUK_ACCOUNT_OAUTH_CLIENT_ID")
  end

  def client_oauth_key_uuid
    ENV.fetch("GOVUK_ACCOUNT_OAUTH_CLIENT_KEY_UUID")
  end

  def ecdsa_key
    OpenSSL::PKey::EC.new(ENV.fetch("GOVUK_ACCOUNT_OAUTH_CLIENT_KEY"))
  end
end
