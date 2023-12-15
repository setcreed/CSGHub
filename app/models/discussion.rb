class Discussion < ApplicationRecord
  include ActionView::Helpers::DateHelper

  has_many :comments, as: :commentable
  belongs_to :user

  def as_json_data
    {
      id: id,
      title: title,
      time: time_ago_in_words(created_at),
      user: user_json
    }
  end

  private

  def user_json
    {
      id: user.id,
      name: user.display_name,
      avatar: user.avatar
    }
  end
end
