class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts

  after_create :do_stuff
  def do_stuff
    add_role :author
    UserNotifierMailer.send_signup_email(self).deliver
  end

  def can_create?
    self.has_role?(:admin) || self.has_role?(:author)
  end

  def can_update?(post)
    self.has_role?(:admin) || (self.has_role?(:author) && post.user == self)
  end

  def can_destroy?(post)
    self.has_role?(:admin) or (self.has_role?(:author) && post.user == self) or self.has_role?(:moderator)
  end

end
