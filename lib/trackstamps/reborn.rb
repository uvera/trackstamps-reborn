module Trackstamps
  module Reborn
    extend ActiveSupport::Concern
    autoload :VERSION, "trackstamps/reborn/version"

    included(_) do
      before_save :trackstamps_set_updater
      before_create :trackstamps_set_updater

      belongs_to :updater, class_name: trackstamps_user_class_name, foreign_key: trackstamps_updater_foreign_key, optional: true
      belongs_to :creator, class_name: trackstamps_user_class_name, foreign_key: trackstamps_creator_foreign_key, optional: true

      def trackstamps_set_updater
        return unless trackstamps_current_user
        self.send("#{:updated_by}=", trackstamps_current_user.id)
      end

      def trackstamps_set_creator
        return unless trackstamps_current_user
        self.send("#{:created_by}=", trackstamps_current_user.id)
      end
    end

    class << self
      def trackstamps_current_user
        Current.user
      end

      def trackstamps_user_class_name
        'User'
      end

      def trackstamps_updater_foreign_key
        'updated_by_id'
      end

      def trackstamps_creator_foreign_key
        'created_by_id'
      end
    end
  end
end
