require "active_support"
require "dry-configurable"

# rubocop:disable  Metrics/AbcSize, Metrics/MethodLength
module Trackstamps
  module Base
    @mixins = ::Concurrent::Map.new

    class Current < ::ActiveSupport::CurrentAttributes
      attribute :user
    end

    def self.[](instance_name=:default)
      @mixins.fetch_or_store(instance_name.to_s) do
        construct_new_module(instance_name)
      end
    end

    def self.construct_new_module(module_key)
      mod = Module.new
      mod.define_singleton_method(:inspect) do
        "Trackstamps::Reborn[:#{module_key}]"
      end

      mod.define_method(:trackstamps_module) do
        mod
      end

      mod.module_eval do
        extend Dry::Configurable
        extend ActiveSupport::Concern
        autoload :VERSION, "trackstamps/reborn/version"

        const_set(:Current, Trackstamps::Base::Current)

        setting :get_current_user, default: -> { Current.user }
        setting :user_class_name, default: "User".freeze
        setting :updater_foreign_key, default: "updated_by_id".freeze
        setting :creator_foreign_key, default: "created_by_id".freeze

        included do
          def trackstamps_current_user
            trackstamps_module.config.get_current_user.call
          end

          private :trackstamps_module
          private :trackstamps_current_user

          before_save :trackstamps_set_updater
          before_create :trackstamps_set_creator

          const_set(
            :UPDATER_FOREIGN_KEY,
            mod.config.updater_foreign_key.dup.freeze
          )
          const_set(
            :CREATOR_FOREIGN_KEY,
            mod.config.creator_foreign_key.dup.freeze
          )

          private_constant :UPDATER_FOREIGN_KEY
          private_constant :CREATOR_FOREIGN_KEY

          belongs_to :updater,
                     class_name: mod.config.user_class_name,
                     foreign_key: const_get(:UPDATER_FOREIGN_KEY),
                     optional: true

          belongs_to :creator,
                     class_name: mod.config.user_class_name,
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

        class_methods do
          def with_trackstamps
            includes(:creator, :updater)
          end
        end
      end

      mod
    end
  end
end
# rubocop:enable  Metrics/AbcSize, Metrics/MethodLength
