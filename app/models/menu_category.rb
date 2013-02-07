class MenuCategory < ActiveRecord::Base

  image_accessor :image do
    copy_to(:thumbnail) {|a| a.thumb('128x128#') }
  end
  image_accessor :thumbnail
  attr_accessible :description, :name,
    :image, :retained_image, :remove_image,
  	:thumbnail, :retained_thumbnail, :remove_thumbnail

  belongs_to :gadget
  has_many :menu_items, dependent: :destroy

  validates_uniqueness_of :name, scope: :gadget_id, \
    message: "must be unique for each menu category in menu."
  validates :name, presence: true, length: {maximum: 50 }
  validates :description, length: { maximum: 1000 }
  validates :gadget_id, presence: true

  default_scope order: 'menu_categories.position'

 	before_save :default_values

  def parent
    gadget
  end
  
  def as_json(options={})
    super(options.merge(methods: [:image_url, :thumbnail_url]))
  end

  def image_url
    prefix = Rails.env.production? ? '' : $request.protocol + $request.host_with_port
    prefix+image.remote_url unless image.blank?
  end

  def thumbnail_url
    prefix = Rails.env.production? ? '' : $request.protocol + $request.host_with_port
    prefix+thumbnail.remote_url unless thumbnail.blank?
  end

  def self.find_all_by_app_id(app_id)
    @gadgets = Gadget.where(
      app_id:app_id, 
      gadget_type_id:GadgetType.find_by_name("Menu").id)
    @gadgets.first.menu_categories unless @gadgets.first.nil?
  end

  def self.find_all_by_user_id(user_id)
    app = App.find_by_user_id(user_id)
    MenuCategory.find_all_by_app_id(app.id)
  end

	private
    def default_values
      self.position = 
      	position.blank? ? gadget.menu_categories.count + 1 : position
  	end
end
