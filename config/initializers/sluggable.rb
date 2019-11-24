module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    # expose a class attribute that we can set per class that we include Sluggable in
    class_attribute :slug_column
  end

  # overrides the to_param method so the path helpers
  # (e.g., post_path(post)) would use the slug column to build the url
  def to_param
    self.slug 
  end

  def generate_slug!
    slug = to_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by slug: slug
    if obj && obj != self
      self.slug = next_slug(slug)
    else
      self.slug = slug
    end
  end
  
  def to_slug(str)
    str = str.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.downcase
  end

  def next_slug(slug)
    number = 1
    new_slug = ''
    loop do
      new_slug = "#{slug}-#{number}"
      obj = self.class.find_by slug: new_slug 
      break if obj.nil?
      number += 1
    end
    new_slug 
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end
