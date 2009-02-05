class LegacyArchitect < LegacyBase
  set_table_name "architect"

  def map
    {
      :first_name => self.name_first,
      :last_name => self.name_last,
      :description => self.desc_long
    }
  end

end
