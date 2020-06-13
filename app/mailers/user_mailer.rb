# This is the controller:
class UserMailer < ApplicationMailer
  # rails c: UserMailer.welcome(User.first).deliver_now!
  def welcome(user)
    @user = user # pass @user to view

    mail(to: @user.email, subject: "Welcome to Classy Cars")
  end
end
