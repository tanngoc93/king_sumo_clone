class ContestantMailer < ApplicationMailer

  def confirmation_email
    @contestant = params[:contestant]
    mail(from: "#{@contestant.campaign.offered_by_name || "Gemkhin Team"} <marketing@gemkhin.com>", reply_to: @contestant.campaign.user.email, to: @contestant.email, subject: "Confirm Your Entry for \"#{@contestant.campaign.title}\"")
  end
end
