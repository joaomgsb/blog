class Tag < ApplicationRecord
    has_many :post_tags, dependent: :destroy
    has_many :posts, through: :post_tags
    
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :name, length: { minimum: 1, maximum: 50 }
    validates :name, format: { 
      with: /\A[a-zA-Z0-9_\-]+\z/, 
      message: "deve conter apenas letras, números, underscores e hífens" 
    }
    
    before_validation :normalize_name
    
    private
    
    def normalize_name
      self.name = name.to_s.strip.downcase.gsub(/\s+/, '_')
    end
end