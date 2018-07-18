class ClientMailer < ApplicationMailer
  default from: 'wolna.hotel@gmail.com'

  def welcome_email
    @reservation = params[:reservation]
    mail(to: @reservation.email, subject: 'Резервация удалась!')
  end
end