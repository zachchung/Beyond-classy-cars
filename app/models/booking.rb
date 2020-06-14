class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :user
  has_one :review, dependent: :destroy # review will be destroyed upon booking destroy

  validates :start_date, :end_date, presence: true
  validate :date_available?, on: :create

  def date_available?
    if car.can_book_for?(start_date, end_date)
      return true
    else
      errors.add(:dates, "Selected dates are not available to book!")
      return false
    end
  end

  def approved!
    update(status: "confirmed")
  end

  def declined!
    update(status: "declined")
  end

  def cancelled!
    update(status: "cancelled")
  end

  def duration
    (end_date - start_date).to_i
  end
end
