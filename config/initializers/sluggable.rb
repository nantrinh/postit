module Sluggable
  extend ActiveSupport::Concern

  included do
    after_save :generate_slug!
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
      slug += next_number(slug).to_s 
    end
    self.slug = slug
  end
  
  def to_slug(str)
    str = str.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.downcase
  end

  def next_number(slug)
    number = 1
    slug = "{slug}-{number}"
    loop do
      obj = self.class.find_by slug: slug 
      break if obj.nil?
      number += 1
    end
    number
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end
