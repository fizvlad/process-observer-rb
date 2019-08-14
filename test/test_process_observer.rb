require_relative "./helper"

class ProcessObserverTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::ProcessObserver::VERSION
  end
  
end
