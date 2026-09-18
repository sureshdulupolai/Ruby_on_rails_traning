# frozen_string_literal: true

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid any tokens
  # that have been already generated.
  # Devise will use Rails.application.secret_key_base by default.
  # config.secret_key = '...'

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # :email. You can configure it to use [:username, :subdomain], etc.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating
  # a user and modifying their profile.
  config.strip_whitespace_keys = [:email]

  # Tell if authentication through request.params is enabled. True by default.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Basic Auth is enabled. False by default.
  # config.http_authenticatable = false

  # If http headers should be used for HTTP Basic Auth. Hash of { header: :method }.
  # config.http_authenticatable_additional_headers = {}

  # Set if Subdomain is allowed for authentication. True by default.
  # config.http_authentication_realm = 'Application'

  # It will change confirmation, password recovery and other workflows
  # to behave in the same way for invalid e-mails or not.
  config.paranoid = true

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 12.
  config.stretches = Rails.env.test? ? 1 : 12

  # Set up a pepper to generate the hashed password.
  # config.pepper = '...'

  # Send a notification email when the user's password is changed
  # config.send_password_change_notification = false

  # ==> Configuration for :confirmable
  # A period that the user is allowed to confirm their account before their
  # token becomes invalid.
  # config.confirm_within = 3.days

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  config.remember_for = 2.weeks

  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :recoverable
  # Defines which key will be used when recovering the password for an account
  config.reset_password_keys = [:email]

  # Time interval you can reset your password with a given token.
  config.reset_password_within = 6.hours

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational.
  config.navigational_formats = ['*/*', :html, :turbo_stream]

  # When using Turbo, sign_out requests are DELETE requests
  config.sign_out_via = :delete

  # ==> Responder configuration
  # To use custom responder or Turbo Streams with Devise
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
