class Influencer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :image

  has_many :favorites, dependent: :destroy
  has_many :favorited_projects, through: :favorites, source: :project

  has_many :influencer_projects

  has_many :reviews, dependent: :destroy

  def avg_rate
    unless self.reviews.empty?
      reviews.average(:rate).round(1).to_f
    else
      0.0
    end
  end

  def avg_rate_percentage
    unless self.reviews.empty?
     reviews.average(:rate).round(1).to_f*100/5
    else
     0.0
    end
  end

  def self.guest
    find_or_create_by!(email: 'guest1@example.com') do |influencer|
      influencer.password = SecureRandom.urlsafe_base64
      influencer.nickname = 'ゲスト1'
      # influencer.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  # has_many  :tag_relationships, dependent: :destroy
  # has_many  :tags, through: :tag_relationships
  # def save_tags(saveinfluencer_tags)
  #   saveinfluencer_tags.each do |new_name|
  #   influencer_tag = Tag.find_or_create_by(name: new_name)
  #   influencer_tag
  #   pp influencer_tag
  #   self.tags << influencer_tag
  # end
  # end

  def already_favorited?(project)
    self.favorites.exists?(project_id: project.id)
  end

  # def create_notification(current_influencer)
  #   temp = Notification.where(["visitercompany_id = ? and visitedinflencer_id = ? and action = ? ",current_influencer.id, id])
  #   if temp.blank?
  #     notification = current_influencer.active_notifications.new(
  #       visitedinflencer_id: id,
  #       action: ''
  #     )
  #     notification.save if notification.valid?
  #   end
  # end
end
