require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "#fullname returns user full name" do
    user = User.new(first_name: "John", last_name: "Lenon")
    actual = user.fullname

    assert_equal("John Lenon", actual)
  end
end
