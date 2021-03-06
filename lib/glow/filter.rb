require 'active_support/concern'

module Glow
  module Filter
    extend ActiveSupport::Concern
    included do
      after_filter    :flash_to_headers
      class_attribute :glow_request_formats
    end

    def flash_to_headers
      return unless flash.any? && flash_to_headers?
      return if flash[:skip_glow] and flash.delete(:skip_glow)

      type, message = flash.first
      response.headers['X-Message'] = message.to_s.unpack('U*').map{ |i| "&##{i};" }.join
        response.headers['X-Message-Type'] = type.to_s
      flash.discard  # don't want the flash to appear when you reload page
    end

    def flash_to_headers?
      request.xhr? ||
      glow_request_formats? && glow_request_formats.include?(request.format.to_sym)
    end


    module ClassMethods
      def headerize_flash_for *formats
        self.glow_request_formats = formats
      end
    end

  end
end
