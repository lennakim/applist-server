class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  validates :content, :presence => true, :length => {:minimum => 3}

  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
