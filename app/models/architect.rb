class Architect < ActiveRecord::Base
  
  def name
    self.first_name + " " + self.last_name
  end

end
