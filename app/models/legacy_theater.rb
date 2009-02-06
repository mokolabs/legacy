class LegacyTheater < LegacyBase
  set_table_name "theater"

  def map
    {
      :name => recombine_name(self.name_present, self.name_the),
      :description => cleanup(self.desc_long)
    }
  end

  protected
  
    def recombine_name(name, the)
      if the == 'Yes'
        "The " + name
      else
        name
      end    
    end
    
    def cleanup(text)
      text = convert_double_dashes_to_em_dashes(text)
    end
    
    def convert_double_dashes_to_em_dashes(text)
      text = text.gsub(/\-\-/,'&mdash;')
    end
  
end
