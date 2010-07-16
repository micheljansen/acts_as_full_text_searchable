module FullTextSearch
  
  def FullTextSearch.classes
    @classes ||= []
  end
    
  # runs and aggregates full_text_search 
  # for all classes that act_as_full_text_searchable
  def FullTextSearch.global_search(condition)
    FullTextSearch.classes.inject([]) do |list, klass|
      list += klass.full_text_search(condition).to_a
    end
  end
  
  def FullTextSearch.add_default_options(options)
    options[:method] = :or unless options[:method]
    options
  end
  
  module ClassMethods
    # searches all fields for condition 
    # by naively passing condition to the where method for each attribute
    # options: {:method => :and} or {:method => :or}
    def full_text_search(condition, options={})
      options = FullTextSearch.add_default_options(options)
      return [] unless self.respond_to?(:where)
      
      keys = []
      if self.respond_to?(:fields)
        keys = self.fields.map{|k,v| k}
      elsif self.respond_to(:attribute_names)
        keys = self.attribute_names
      end
      
      results = []
      if(options[:method] == :and)
        query = keys.inject({}) {|q,k| q.merge(k => condition)}
        results = self.all.where(query).to_a
      else
        #TODO refactor this as soon as arel's .or works
        counted_results = Hash.new(0)
        
        keys.each do |key|
          results = self.all.where(query).to_a
          results.each do |key|
            counted_results[key] = counted_results[key]+1
          end
        end
        
        counted_results.sort {|a,b| a[1]<=>b[1]}.map{|pair| pair.first}
      end
      
      results
    end #full_text_search
  end #ClassMethods
  
end