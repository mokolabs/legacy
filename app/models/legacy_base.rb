class LegacyBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "legacy"
  
  def migrate
    new_record = eval("#{self.class}".gsub(/Legacy/,'')).new(map)
    new_record[:id] = self.id
    new_record.save
  end

end
