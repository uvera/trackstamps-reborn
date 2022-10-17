require 'trackstamps/reborn/current'
require 'active_support/current_attributes'
require 'active_support/concern'

module Trackstamps
  module Reborn
    extend ActiveSupport::Concern
    autoload :VERSION, "trackstamps/reborn/version"

    def trackstamps_current_user
      Current.user
    end

    TRACKSTAMPS_USER_CLASS_NAME = 'User'
    TRACKSTAMPS_UPDATER_FOREIGN_KEY = 'updated_by_id'
    TRACKSTAMPS_CREATOR_FOREIGN_KEY = 'created_by_id'

    included do
      before_save :trackstamps_set_updater
      before_create :trackstamps_set_updater

      belongs_to :updater, class_name: TRACKSTAMPS_USER_CLASS_NAME, foreign_key: TRACKSTAMPS_UPDATER_FOREIGN_KEY, optional: true
      belongs_to :creator, class_name: TRACKSTAMPS_USER_CLASS_NAME, foreign_key: TRACKSTAMPS_CREATOR_FOREIGN_KEY, optional: true

      def trackstamps_set_updater
        return unless trackstamps_current_user
        self.send("#{TRACKSTAMPS_UPDATER_FOREIGN_KEY}=", trackstamps_current_user.id)
      end

      def trackstamps_set_creator
        return unless trackstamps_current_user
        self.send("#{TRACKSTAMPS_CREATOR_FOREIGN_KEY}=", trackstamps_current_user.id)
      end
    end
  end
end
