class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook] # <<< FB 3rd-party login

  # FB 3rd-party login:
  def self.find_for_facebook_oauth(auth)
    # auth is a { } returned from FB
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name")
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params) # if user signed-up with email before & sign-in with FB now, update with FB info
    else
      user = User.new(user_params) # if user never signed-up
      user.password = Devise.friendly_token[0,20] # Fake password for Devise validation
      user.save
    end

    return user
  end

  has_many :cars
  has_many :bookings

  validates :first_name, :last_name, presence: true

  def fullname
    name = "#{first_name} #{last_name}"
    name.strip
  end

  def pending_requests
    Booking.joins(:car).where(cars: { user: self }).where(status: Booking::BOOKING_STATUS[:pending])
  end

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end
end
