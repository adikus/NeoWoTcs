class Player < ActiveRecord::Base
  has_many :player_tanks
  has_many :tanks, through: :player_tanks
  has_many :player_stats
  belongs_to :clan

  enum status: {
         ok: 1
       }

  enum role: {
         leader: 'leader',
         vice_leader: 'vice_leader',
         junior_officer: 'junior_officer',
         soldier: 'private',
         personnel_officer: 'personnel_officer',
         diplomat: 'diplomat',
         recruiter: 'recruiter',
         reservist: 'reservist',
         recruit: 'recruit',
         commander: 'commander',
         treasurer: 'treasurer'
       }

  def current_stats
    player_stats.order(created_at: :desc).first
  end

  def update_tanks(tanks_data)
    to_insert = []
    to_update = {}

    tanks_data.each do |tank_data|
      player_tank = player_tanks.detect { |pt| pt.tank_id == tank_data['tank_id'] }
      if player_tank.nil?
        to_insert << [tank_data['tank_id'], id, tank_data['statistics']['wins'], tank_data['statistics']['battles'], tank_data['mark_of_mastery']]
      elsif player_tank.battles < tank_data['statistics']['battles']
        to_update[player_tank.id] = {
          wins: tank_data['statistics']['wins'],
          battles: tank_data['statistics']['battles'],
          mark_of_mastery: tank_data['mark_of_mastery']
        }
      end
    end

    PlayerTank.import [:tank_id, :player_id, :wins, :battles, :mark_of_mastery], to_insert
    PlayerTank.update to_update.keys, to_update.values
  end

  def update_stats(stats_data)
    player_stats.create!({
      battles: stats_data['statistics']['all']['battles'],
      wins: stats_data['statistics']['all']['wins'],
      defeats: stats_data['statistics']['all']['losses'],
      survived: stats_data['statistics']['all']['survived_battles'],
      frags: stats_data['statistics']['all']['frags'],
      spotted: stats_data['statistics']['all']['spotted'],
      accuracy: stats_data['statistics']['all']['hits'].to_f / stats_data['statistics']['all']['shots'],
      damage: stats_data['statistics']['all']['damage_dealt'],
      capture: stats_data['statistics']['all']['capture_points'],
      defense: stats_data['statistics']['all']['dropped_capture_points'],
      experience: stats_data['statistics']['all']['base_xp']
    })
  end
end