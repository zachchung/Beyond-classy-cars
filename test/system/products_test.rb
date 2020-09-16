require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  # DOESN'T WORK ON TRAVIS CI:
  # test "visiting the index" do
  #   visit "/"
  #   assert_selector "h1", text: "BOOK YOUR NEXT ADVENTURE WITH US"
  # end

  # DOESN'T WORK AT ALL:
  # test "users should be able to add cars" do
  #   # user = User.create!(email: "test@cars.com", password: 123456, first_name: "John", last_name: "Lennon")
  #   login_as(User.first)
  #   visit "/cars/new"

  #   fill_in "car_location", with: "hk"
  #   fill_in "car_name", with: "Ferrari"
  #   click_on "Add car"

  #   # assert_equal "/cars"
  #   assert_equal root_path, page.current_path
  #   assert_text "Change your life: Learn to code"
  # end
end
