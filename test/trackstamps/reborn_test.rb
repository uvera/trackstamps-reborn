require "test_helper"

class Trackstamps::RebornTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Trackstamps::Reborn::VERSION
  end
end
