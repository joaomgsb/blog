class Comment < ApplicationRecord
    belongs_to :post
    belongs_to :user, optional: true
    
    validates :content, presence: true, length: { minimum: 2, maximum: 1000 }
    validates :author_name, presence: true, length: { minimum: 2, maximum: 50 }, if: -> { user.nil? }
    
    scope :newest_first, -> { order(created_at: :desc) }

    def author_display_name
        if user
            "@#{user.username}"
        else
            author_name
        end
    end
end