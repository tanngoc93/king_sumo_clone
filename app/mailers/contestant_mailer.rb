class ContestantMailer < ApplicationMailer

  def confirmation_email
    @contestant = params[:contestant]
    mail(
      to: @contestant.email,
      from: "#{@contestant.campaign.offered_by_name || "Markiee Team"} <marketing@markiee.co>",
      subject: "Confirm your entry for \"#{@contestant.campaign.title}\" campaign",
      reply_to: @contestant.campaign.user.email
    )
  end
end
