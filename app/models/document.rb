class Document < ActiveRecord::Base

  attr_accessible :name, :content, :slug, :tags
  validates_presence_of :name, :content, :slug
  validates_uniqueness_of :name, :slug
  
  before_validation :set_default_slug
  
  default_scope :order => 'name'
  named_scope :tagged, lambda { |tags|
    tags = [tags] unless tags.class == Array
    concatenated_field = PortAQuery.concat(' ', :tags, ' ')
    conditions = tags.map{|t| "#{concatenated_field} LIKE '%\ #{t}\ %'"}
    { :conditions => conditions.join(' AND ')}
  }
  
  def to_param
    self.slug
  end
  
  def text_content
    self.content.gsub(/<\/?[^>]*>/, '')
  end
  
  def tag_array
    self.tags.split(' ')
  end
  
  def tag_array=(tag_array)
    self.tags = tag_array.join(' ')
  end

  def set_default_slug
   self.slug = self.name.parameterize if self.slug.blank?
  end

end
