require "active_support"
require "dry-configurable"

module Trackstamps
  module Base
    @mixins = ::Concurrent::Map.new

    class Current < ::ActiveSupport::CurrentAttributes
      attribute :user
    end

    def self.[](instance_name = :default)
      @mixins.fetch_or_store(instance_name.to_s) do
        Module.new do
          @@trackstamps_target_key = instance_name
          const_set(:Current, Trackstamps::Base::Current)

          extend Dry::Configurable
          extend ActiveSupport::Concern
          autoload :VERSION, "trackstamps/reborn/version"

          setting :get_current_user, default: -> { Current.user }

          setting :user_class_name, default: "User".freeze
          setting :updater_foreign_key, default: "updated_by_id".freeze
          setting :creator_foreign_key, default: "created_by_id".freeze

          def trackstamps_current_user
            Trackstamps::Base[@@trackstamps_target_key].config.get_current_user.call
          end

          def self.inspect
            "Trackstamps::Reborn[:#{@@trackstamps_target_key}]"
          end

          def self.included(base)
            trackstamps_module_self = self
            base.class_eval do
              before_save :trackstamps_set_updater
              before_create :trackstamps_set_creator

              const_set(:UPDATER_FOREIGN_KEY, trackstamps_module_self.config.updater_foreign_key.dup.freeze)

              private_constant :UPDATER_FOREIGN_KEY

              belongs_to :updater,
                class_name: trackstamps_module_self.config.user_class_name,
                foreign_key: const_get(:UPDATER_FOREIGN_KEY),
                optional: true

              const_set(:CREATOR_FOREIGN_KEY, trackstamps_module_self.config.creator_foreign_key.dup.freeze)
              private_constant :CREATOR_FOREIGN_KEY

              belongs_to :creator,
                class_name: trackstamps_module_self.config.user_class_name,
                foreign_key: const_get(:CREATOR_FOREIGN_KEY),
                optional: true

              def trackstamps_set_updater
                return unless trackstamps_current_user

                send(:"#{self.class.const_get(:UPDATER_FOREIGN_KEY)}=", trackstamps_current_user.id)
              end

              def trackstamps_set_creator
                return unless trackstamps_current_user

                send(:"#{self.class.const_get(:CREATOR_FOREIGN_KEY)}=", trackstamps_current_user.id)
              end
            end
          end

          class_methods do
            def with_trackstamps
              includes(:creator, :updater)
            end
          end
        end
      end
    end
  end
end
