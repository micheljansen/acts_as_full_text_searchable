require 'full_text_search'

module ActsAsFullTextSearchable
  def acts_as_full_text_searchable(options={})
    FullTextSearch.classes << self
    send :extend, FullTextSearch::ClassMethods
  end
end

# just extend Mongoid and Activerecord for now

module Mongoid
  module Finders
    include ActsAsFullTextSearchable
  end
end
  
module ActiveRecord    
  class Base
    extend ActsAsFullTextSearchable
  end
end
