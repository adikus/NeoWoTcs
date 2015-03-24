class PlayerTank < ActiveRecord::Base
  belongs_to :player
  belongs_to :tank
end