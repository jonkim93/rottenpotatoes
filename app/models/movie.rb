class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.get_all_ratings
  	uniq.pluck(:rating)
  end
end
