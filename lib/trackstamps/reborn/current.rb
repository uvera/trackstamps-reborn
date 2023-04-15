module Trackstamps
  module Reborn
    class Current < ::ActiveSupport::CurrentAttributes
      attribute :user
    end
  end
end
