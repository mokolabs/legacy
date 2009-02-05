class LegacyTheater < LegacyBase
  set_table_name "theater"

  def map
    {
      :name => self.name_present,
      :description => self.desc_long
    }
  end

end
