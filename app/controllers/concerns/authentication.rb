module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
    helper_method :email_address_pending_authentication

    include Authentication::ViaMagicLink
  end

  class_methods do
    def require_unauthenticated_access(**options)
      allow_unauthenticated_access(**options)
      before_action :redirect_authenticated_user, **options
    end

    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to main_app.new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def redirect_authenticated_user
      redirect_to main_app.root_url if authenticated?
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end

    def resume_session
      # Current.session =|| find_session_by_cookie
      return Current.session if Current.session

      session = find_session_by_cookie

      if session && session_active?(session)
        touch_session(session)
        Current.session = session
      else
        terminate_session_if_exists(session)
        nil
      end
    end

    def session_active?(session)
      timeout = session.user.account.session_timeout
      timeout.blank? || session.updated_at > Time.current - timeout
    end

    def touch_session(session)
      session.touch # updates updated_at
    end

    def terminate_session_if_exists(session)
      session&.destroy
      cookies.delete(:session_id)
    end
end
