class AddUser < SeedMigration::Migration
  def up
    user = User.find_by(email: "tanngoc93@gmail.com")

    if user.nil?
      user = User.new(email: "tanngoc93@gmail.com", password: "tanngoc93@gmail.com", password_confirmation: "tanngoc93@gmail.com")
      user.skip_confirmation!
      user.save!
    end
  end

  def down
    user = User.find_by(email: "tanngoc93@gmail.com")

    if user
      user.destroy
    end
  end
end
