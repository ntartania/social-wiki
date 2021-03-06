class User < ActiveRecord::Base
=begin
User attributes
username:   this is the username that the user goes by it can be used to log in.
       It showed be shown next to users posts and comments. S
       Should be unique
password:   personal password used to log in
email:     user's email addres it can be used to log in
=end
  has_many :posts
  has_many :comments
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  EMAIL_REGEX =  %r{[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z}i

  validates :username, presence: true, uniqueness: true, length: { in: 3..32 }
  validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX
  validates :password, confirmation: true, length: {in: 8..256}
  validates :password_confirmation, presence: true

  acts_as_voter
  has_secure_password

  def trustscore
      up_score = 0.0
      vote_score = 0.0
      self.posts.each do |post|
        up_score += post.get_upvotes.size
        vote_score += post.votes_for.size
      end
      if vote_score == 0.0
        vote_score =1.0
      end
      return up_score/vote_score * 10
    end

  def self.authenticate_with_username_or_email(username_or_email,login_password)
    if EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end
    if user.try :authenticate, login_password
      user
    else
      return nil
    end
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  def to_s
    username
  end
end
