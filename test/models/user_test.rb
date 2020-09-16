require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "#fullname returns user full name" do
    user = User.new(first_name: "John", last_name: "Lennon")
    assert_equal("John Lennon", user.fullname)
  end

  test "#fullname returns empty string if name is missing" do
    user = User.new(first_name: nil, last_name: nil)
    assert_equal("", user.fullname)
  end

  test "#fullname returns last name if first name is missing" do
    user = User.new(first_name: nil, last_name: "Lennon")
    assert_equal("Lennon", user.fullname)
  end
end
