require 'full_text_search'

module ActsAsFullTextSearchable
  def acts_as_full_text_searchable(options={})
    puts "full text searchable: #{self}"
    FullTextSearch.classes << self
    send :extend, FullTextSearch::ClassMethods
  end
end

["ActiveRecord::Base", "Mongoid::Document"].each do |class_name|
  begin
    Kernel.const_get(class_name).send(:extend, ActsAsFullTextSearchable)
  rescue
  end
end