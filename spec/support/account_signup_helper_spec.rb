module AccountSignupHelper
  def self.test_ec_key_fixture
    "-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEIBjlMYhN/1FiZX7RRUyKpqDM2bPIHQswhjm+ZPaOXlgQoAoGCCqGSM49\nAwEHoUQDQgAE2pGXU3YkENblp+SMC8CWpkwPDdWXJdEsXoSQ8dWNYxFFbnXKN4Vv\nRGeLYoNKjuK/2t9rlEEumIzm5EtMxts7Jg==\n-----END EC PRIVATE KEY-----\n"
  end

  def account_feature_flag_environment_variables
    {
      "GOVUK_ACCOUNT_OAUTH_CLIENT_ID": "Application's OAuth client ID",
      "GOVUK_ACCOUNT_OAUTH_CLIENT_KEY_UUID": "fake_key_uuid",
      "GOVUK_ACCOUNT_OAUTH_CLIENT_KEY": AccountSignupHelper.test_ec_key_fixture,
      "PLEK_SERVICE_ACCOUNT_MANAGER_URI": "http://account.service.dev.test.gov.uk/",
      "FEATURE_FLAG_ACCOUNTS": "enabled",
    }
  end

  def with_account_feature_flag_and_variables_set(&block)
    ClimateControl.modify(
      account_feature_flag_environment_variables,
      &block
    )
  end
end
