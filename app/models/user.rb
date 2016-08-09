class User < ApplicationRecord
  before_create :generate_authentication_token!
  before_save { self.email = email.downcase }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true
  #validates :name, presence: true
  validates :email,  presence: true,
                     format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "is not valid."},
                     uniqueness: { case_sensitive:  false }

  #validates :password, length: {minimum: 7}
  validates_confirmation_of :password

  has_many :projects, dependent: :destroy

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
