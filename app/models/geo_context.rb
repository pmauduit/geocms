class GeoContext < ActiveRecord::Base
  acts_as_taggable

  extend FriendlyId
  friendly_id :name, :use => :slugged
  has_attached_file :wmc

  belongs_to :taxon, :foreign_key => :category_id

  validates_presence_of :name

  def wmc_content
    return nil if wmc.nil?
    return nil unless File.exists?(wmc.path)
    return File.read(wmc.path)
  end

  def title 
    name
  end

  def credits
    ""
  end
end
