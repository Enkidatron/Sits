class LooseNavigation
	include NavigationHelper
	include BearingsHelper

	attr_reader :start_bearings,:middle_bearings,:endpoint_bearings,:pivot,:roll,:start_mid_piv,:start_mid_rol,:start_end_piv,:start_end_rol,:mid_end_piv,:mid_end_rol

	def analyze(bearing1,bearing2,movement,modifier)
		if !bearing1.nil? and !bearing2.nil? and !movement.nil?
			return get_window_distance(bearing1.intern,bearing2.intern) <= (movement.to_f*modifier).round
		else
			return nil
		end
	end

	def initialize(start,middle,endpoint,piv,rol)
		@start_bearings = start.split(',').reject{ |bearing| bearing.nil? or !validate_bearing(bearing, lines = true)}.map{|v| v.intern } unless start.nil?
		@middle_bearings = middle.split(',').reject{ |bearing| bearing.nil? or !validate_bearing(bearing, lines = true)}.map{|v| v.intern } unless middle.nil?
		@endpoint_bearings = endpoint.split(',').reject{ |bearing| bearing.nil? or !validate_bearing(bearing, lines = true)}.map{|v| v.intern } unless endpoint.nil?
		@pivot = piv.to_i unless piv.nil?
		@roll = rol.to_i unless rol.nil?

		@start_mid_piv = analyze(@start_bearings[0],@middle_bearings[0],@pivot,0.5) unless (@start_bearings.nil? or @middle_bearings.nil?)
		@start_mid_rol = analyze(@start_bearings[1],@middle_bearings[1],@roll,0.5) unless (@start_bearings.nil? or @middle_bearings.nil?)
		@start_end_piv = analyze(@start_bearings[0],@endpoint_bearings[0],@pivot,1.0) unless (@start_bearings.nil? or @endpoint_bearings.nil?)
		@start_end_rol = analyze(@start_bearings[1],@endpoint_bearings[1],@roll,1.0) unless (@start_bearings.nil? or @endpoint_bearings.nil?)
		@mid_end_piv = analyze(@middle_bearings[0],@endpoint_bearings[0],@pivot,0.5) unless (@middle_bearings.nil? or @endpoint_bearings.nil?)
		@mid_end_rol = analyze(@middle_bearings[1],@endpoint_bearings[1],@roll,0.5) unless (@middle_bearings.nil? or @endpoint_bearings.nil?)

		@start_ship = Bearing.new(@start_bearings[0].to_s,@start_bearings[1].to_s,'') unless @start_bearings.nil? or @start_bearings.length < 2
		@middle_ship = Bearing.new(@middle_bearings[0].to_s,@middle_bearings[1].to_s,'') unless @middle_bearings.nil? or @middle_bearings.length < 2
		@endpoint_ship = Bearing.new(@endpoint_bearings[0].to_s,@endpoint_bearings[1].to_s,'') unless @endpoint_bearings.nil? or @endpoint_bearings.length < 2
	end

	def empty?
		@start_mid_piv.nil? and @start_mid_rol.nil? and @start_end_piv.nil? and @start_end_rol.nil? and @mid_end_piv.nil? and @mid_end_rol.nil?
	end

	def start?
		!@start_ship.nil? and @start_ship.is_ship_valid?
	end

	def middle?
		!@middle_ship.nil? and @middle_ship.is_ship_valid?
	end

	def endpoint?
		!@endpoint_ship.nil? and @endpoint_ship.is_ship_valid?
	end

end