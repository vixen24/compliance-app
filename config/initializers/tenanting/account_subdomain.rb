module AccountSubdomain
  class Extractor
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      return @app.call(env) if active_storage_request?(request)

      subdomain = request.subdomain.presence
      account = Account.find_by(subdomain: subdomain) if subdomain.present?

      if account
        env["current.account_id"] = account.id

        return Current.with_account(account) do
          @app.call(env)
        end
      end

      Current.without_account do
        @app.call(env)
      end
    end

    private

    def active_storage_request?(request)
      request.path.start_with?("/rails/active_storage")
    end
  end
end

Rails.application.config.middleware.insert_after Rack::TempfileReaper, AccountSubdomain::Extractor
