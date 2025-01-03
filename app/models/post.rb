class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags

    validates :title, presence: true, length: { minimum: 5, maximum: 100 }
    validates :content, presence: true, length: { minimum: 10 }

    # Aceita atributos aninhados para tags
    accepts_nested_attributes_for :tags, allow_destroy: true

    # Método para adicionar tags com segurança
    def add_tags(tag_list)
      return if tag_list.blank?

      tag_list.each do |tag|
        tags << tag unless tags.include?(tag)
      end
    end

    scope :published, -> { order(created_at: :desc) }

    paginates_per 3 # Configuração do Kaminari para 3 posts por página
end
