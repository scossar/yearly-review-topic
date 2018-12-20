review_username ='reviewbot'
user = User.find_by(id: -3)

def seed_primary_email
  UserEmail.seed do |ue|
    ue.id = -3
    ue.email = "reviewbot_email"
    ue.primary = true
    ue.user_id = -3
  end
end

if !user
  suggested_username = UserNameSuggester.suggest(review_username)

  seed_primary_email

  User.seed do |u|
    u.id = -3
    u.name = suggested_username
    u.username = suggested_username
    u.username_lower = suggested_username.downcase
    u.password = SecureRandom.hex
    u.active = true
    u.approved = true
    u.trust_level = TrustLevel[4]
  end

  # TODO Pull the user avatar from that thread for now. In the future, pull it from a local file or from some central discobot repo.
  if !Rails.env.test?
    UserAvatar.import_url_for_user(
      "https://cdn.discourse.org/dev/uploads/default/original/2X/e/edb63d57a720838a7ce6a68f02ba4618787f2299.png",
      User.find(-3),
      override_gravatar: true
    )
  end
end

bot = User.find(-3)
bot.update!(admin:true, moderator: false)

bot.user_option.update!(
  email_private_messages: false,
  email_direct: false
)

if !bot.user_profile.bio_raw
  bot.user_profile.update!(
    bio_raw: I18n.t('discourse_yearly_review.review_bot.bio')
  )
end

Group.user_trust_level_change!(-3, TrustLevel[4])