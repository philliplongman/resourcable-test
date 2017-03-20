# == Schema Information
#
# Table name: profiles
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  display_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ApplicationRecord
  belongs_to :user

  validates :display_name, presence: true
end
