class AddUser < SeedMigration::Migration
  def up
    user = User.find_by(email: "email@example.com")

    unless user
      user = User.new(email: "email@example.com", password: "Q24ya9Z98magfGvg", password_confirmation: "Q24ya9Z98magfGvg")
      user.skip_confirmation!
      user.save!
    end
  end

  def down
    User.find_by(email: "email@example.com").try(:destroy)
  end
end
