class BookingMailer < ApplicationMailer
  def confirmation(booking)
    @booking = booking

    mail(to: @booking.user.email, subject: "Booking Confirmation ##{@booking.id}")
  end
end
