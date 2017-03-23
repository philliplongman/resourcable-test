# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_one  :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  validates :name, presence: true
end
