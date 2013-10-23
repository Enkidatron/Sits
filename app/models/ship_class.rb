class ShipClass < ActiveRecord::Base
  attr_accessible :name, :faction, :classification, :base_cost
  attr_accessible :officers, :enlisted, :marines, :recon_drones
  serialize :small_craft, Hash
  serialize :fore_fcon, Array
  serialize :aft_fcon, Array
  serialize :port_fcon, Array
  serialize :star_fcon, Array
  serialize :fore_missiles, Hash
  serialize :aft_missiles, Hash
	serialize :port_missiles, Hash
	serialize :star_missiles, Hash
	serialize :fore_energy, Hash
	serialize :aft_energy, Hash
	serialize :port_energy, Hash
	serialize :star_energy, Hash
	serialize :fore_cm, Array
	serialize :aft_cm, Array
	serialize :port_cm, Array
	serialize :star_cm, Array
	serialize :fore_pd, Array
	serialize :aft_pd, Array
	serialize :port_pd, Array
	serialize :star_pd, Array
	attr_accessible :small_craft, :fore_fcon, :aft_fcon, :port_fcon, :star_fcon
	attr_accessible :fore_missiles, :aft_missiles, :port_missiles, :star_missiles
	attr_accessible :fore_energy, :aft_energy, :port_energy, :star_energy
	attr_accessible :fore_cm, :aft_cm, :port_cm, :star_cm
	attr_accessible :fore_pd, :aft_pd, :port_pd, :star_pd

	attr_accessible :fore_mag, :aft_mag, :port_mag, :star_mag
	attr_accessible :fore_decoy, :aft_decoy, :port_decoy, :star_decoy, :decoy_strength
	attr_accessible :scale, :core_armor
	serialize :star_sidewall, Array
	serialize :port_sidewall, Array
	serialize :brg, Array
	serialize :flg, Array
	serialize :ecm, Array
	serialize :piv, Array
	serialize :rol, Array
	serialize :thrust, Array
	serialize :si, Array
	serialize :repair_parties, Array
	attr_accessible :star_sidewall, :port_sidewall
	attr_accessible :brg, :flg, :ecm, :piv, :rol, :thrust, :si, :repair_parties

	attr_accessible :lif, :com, :fwd, :aft, :hyp, :hull
	serialize :range_bands, Array
	serialize :cost_adjusters, Hash
attr_accessible :range_bands, :cost_adjusters

  has_many :ship, :dependent => :destroy
  validates :name, presence: true

  def total_crew
  	self.officers + self.enlisted + self.marines
  end

  def range_band_display
  	answer = []
  	answer[0] = []
  	answer[1] = []
  	j = 0
  	min = 0
  	max = 0
  	mql = self.range_bands[0]
  	for i in 1...self.range_bands.length
  		unless mql == self.range_bands[i]
  			max = i-1
  			answer[0][j] = "#{min}-#{max}"
  			answer[1][j] = self.range_bands[min]
  			min = i
  			j += 1
  			mql = self.range_bands[i]
  		end
  	end
  	max = self.range_bands.length - 1
  	answer[0][j] = "#{min}-#{max}"
  	answer[1][j] = self.range_bands[min]
  	answer

  end

end
