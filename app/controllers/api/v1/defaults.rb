module API
  module V1
    module Defaults 
      extend ActiveSupport::Concern

      included do
        version 'v1'
        format :json

        http_basic do |email, password|
          check = false
          @user = User.find_by_email(email)
          if @user
            bcrypt   = ::BCrypt::Password.new(@user.encrypted_password)
            password = ::BCrypt::Engine.hash_secret("#{password}#{User.pepper}", bcrypt.salt)
            check = Devise.secure_compare(password, @user.encrypted_password)
          end
          check ? true : error!('401 Unauthorized.  Verify your credentials.', 401)
        end

        helpers do

          def permitted_params
            sanitized = declared(params, include_missing: false)
            @permitted_params ||= ActionController::Parameters.new(sanitized).permit!
          end

          def user
            @user
          end

        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          if e.message =~ /Couldn't find Company/
            error_response(message: "Invalid credentials.  Verify your user name and password", status: 404)
          elsif e.message =~ /Couldn't find/
            model = e.message.split(/(find)|(with)/)[2].strip
            error_response(message: "#{model} not found.", status: 404)
          end
        end

        rescue_from Grape::Exceptions::ValidationErrors, ActiveRecord::RecordInvalid do |e|
          add = e.message.include?("Email has already been taken") ? ": #{e.record.email}" : ""
          error_response(message: e.message + add, status: 400)
        end

        # rescue_from ArgumentError do |e|
        #   if e.message == "invalid date"
        #     error_response(message: "Invalid format for date.  Use %m/%d/%Y", status: 400)
        #   else
        #     error_response(message: "Internal server error", status: 500)
        #   end
        # end

        rescue_from :all do |e|
          if Rails.env.development? || Rails.env.test?
            error_response(message: "Internal server error: #{e.message}", status: 500)
          else
            error_response(message: "Internal server error", status: 500)
          end
        end

      end
    end
  end
end
