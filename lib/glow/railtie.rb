require 'glow/filter'
require 'action_controller/base'

module Glow
  class Railtie < Rails::Railtie
    config.to_prepare do
      ::ActionController::Base.send :include, Glow::Filter
    end
  end
end
