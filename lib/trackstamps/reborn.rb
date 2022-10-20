require 'trackstamps/reborn/current'
require 'active_support/current_attributes'
require 'active_support/concern'
require 'dry-configurable'

module Trackstamps
  module Reborn
    extend Dry::Configurable
    extend ActiveSupport::Concern
    autoload :VERSION, "trackstamps/reborn/version"

    setting :get_current_user, default: -> { Trackstamps::Reborn::Current.user }

    setting :user_class_name, default: 'User'.freeze
    setting :updater_foreign_key, default: 'updated_by_id'.freeze
    setting :creator_foreign_key, default: 'created_by_id'.freeze

    def trackstamps_current_user
      Trackstamps::Reborn.config.get_current_user.call
    end

    included do
      before_save :trackstamps_set_updater
      before_create :trackstamps_set_creator

      belongs_to :updater,
                 class_name: Trackstamps::Reborn.config.user_class_name,
                 foreign_key: Trackstamps::Reborn.config.updater_foreign_key,
                 optional: true
      belongs_to :creator,
                 class_name: Trackstamps::Reborn.config.user_class_name,
                 foreign_key: Trackstamps::Reborn.config.creator_foreign_key,
                 optional: true

      def trackstamps_set_updater
        return unless trackstamps_current_user

        send("#{Trackstamps::Reborn.config.updater_foreign_key}=", trackstamps_current_user.id)
      end

      def trackstamps_set_creator
        return unless trackstamps_current_user

        send("#{Trackstamps::Reborn.config.creator_foreign_key}=", trackstamps_current_user.id)
      end
    end
  end
end
