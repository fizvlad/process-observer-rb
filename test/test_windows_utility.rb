require_relative "./helper"

class ProcessObserverTest < Minitest::Test

  def test_hash_to_str
    assert_equal("/one_param 42", ProcessObserver::Windows.to_arg(one_param: 42))
    assert_equal("/one_param", ProcessObserver::Windows.to_arg(one_param: true))
    assert_equal("/first /second", ProcessObserver::Windows.to_arg(first: true, second: true))
    assert_equal("/first", ProcessObserver::Windows.to_arg(first: true, second: false))
    assert_equal("/first /second \"str example\"", ProcessObserver::Windows.to_arg(first: true, second: "str example"))
    assert_raises(ProcessObserver::SpecialCharacterError) do
      ProcessObserver::Windows.to_arg(first: true, second: "str with quote: \"")
    end
  end

end
