class Tank < ActiveRecord::Base
  enum tank_type: {
         heavy: 'heavyTank',
         medium: 'mediumTank',
         light: 'lightTank',
         td: 'AT-SPG',
         arty: 'SPG'
       }

  enum nation: {
         ussr: 'ussr',
         usa: 'usa',
         uk: 'uk',
         germany: 'germany',
         china: 'china',
         japan: 'japan',
         france: 'france'
       }

  scope :top, -> { where(level: 10) }
  scope :top_scout, -> { where(level: 8).light }
end