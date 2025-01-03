class User < ApplicationRecord
       devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :validatable

       has_many :posts, dependent: :destroy
       has_many :comments, dependent: :destroy
       has_one_attached :avatar

       # Ajustando as validações
       validates :email, presence: true, uniqueness: true
       validates :username,
                 presence: true,
                 uniqueness: true,
                 length: { minimum: 3, maximum: 20 },
                 format: {
                   with: /\A[a-zA-Z0-9_]+\z/,
                   message: "deve conter apenas letras, números e underscore"
                 }
       validates :name, presence: true, length: { maximum: 50 }
       validates :bio, length: { maximum: 500 }, allow_blank: true
       validates :website,
                 format: { with: URI.regexp(%w[http https]), message: "formato inválido" },
                 allow_blank: true

       # Validações do avatar
       validates :avatar,
                 content_type: { in: [ "image/png", "image/jpeg", "image/jpg", "image/gif" ], message: "deve ser uma imagem (PNG, JPEG, GIF)" },
                 size: { less_than: 5.megabytes, message: "deve ser menor que 5MB" },
                 if: :avatar_attached?

       def display_name
         name.presence || username
       end

       def admin?
         admin
       end

       private

       def avatar_attached?
         avatar.attached?
       end
end
