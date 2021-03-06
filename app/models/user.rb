class User < ApplicationRecord
  default_scope { order(created_at: :desc) }
  before_create :generate_authentication_token!
  before_save { self.email = email.downcase }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true
  validates :name, presence: true
  validates :email,  presence: true,
                     format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "is not valid."},
                     uniqueness: { case_sensitive:  false }

  validates_confirmation_of :password

  belongs_to :role
  has_many :projects, dependent: :destroy
  has_many :user_experiments
  has_many :experiments, through: :projects
  has_many :assigned_experiments, through: :user_experiments,  source: :experiment


#methods for authorization
  def is_active?
    self.active
  end

  def is_admin?
    self.role_id == 1
  end

  def is_main_investigator?
    self.role_id <= 2
  end

  def is_investigator?
    self.role_id <= 3
  end

  def is_laboratorist?
    self.role_id == 4 || self.is_admin?
  end

#method for generate authentication token
  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

end
