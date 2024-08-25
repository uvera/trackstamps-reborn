require_relative "base"

module Trackstamps
  Reborn = Trackstamps::Base[:default]
  Reborn.module_eval do
    def self.[](instance_name)
      Trackstamps::Base[instance_name]
    end
  end
end
