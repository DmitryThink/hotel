class ContactController < BaseController
  skip_before_action :verify_authenticity_token, :only => :create
  before_action :click

  def index; end

  def create
    @message = Message.new(message_params)
    if @message.valid?
      @message.save!
      render :json => { }
    else
      render :json => { :text => errors }, :status => 500
    end
  end

  private

  def errors
    errors = ""
    @message.errors.full_messages.each do |error|
      errors += error.to_s + '; '
    end
    errors
  end

  def message_params
    prms = params.require(:message).permit(:name, :phone_number, :message)
    prms[:phone_number] = prms[:phone_number].gsub!(/[\-|\)|\(| ]/, '') || prms[:phone_number]
    prms[:phone_number] = prms[:phone_number][2..-1] if prms[:phone_number][0..2] == "380"
    prms[:phone_number] = prms[:phone_number][3..-1] if prms[:phone_number][0..3] == "+380"
    prms[:name] = capitalize(prms[:name])
    prms
  end

  def capitalize(str)
    str[0].mb_chars.upcase.to_s + str[1..-1]
  end
end