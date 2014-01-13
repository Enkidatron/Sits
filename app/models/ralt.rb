class Ralt
	include RaltHelper
	include BearingsHelper

	attr_reader :bearing_vectors, :ship

	def initialize(front,top,distances)
		unless distances.nil?
			distances = distances.downcase
			distances = distances.split(',').map{|v| v.strip}
			all_components = distances.map{ |d| if validate_distance_string(d) then consolidate_vectors(d) end }.reject{ |v| v.nil? }
			@bearing_vectors = all_components.map{ |components| compute_bearing(components) }.reject{|v| v.nil? or v[1]==0}
		end
		@ship_valid = false
		unless front.nil? or top.nil? or front == '' or top == ''
			@has_ship = true
			front = front.downcase.strip
			top = top.downcase.strip
			if validate_bearing(front) and validate_bearing(top)
				@ship_valid = true
				@ship = Bearing.new(front,top,@bearing_vectors.map{|vector| vector[0]}.join(','))
			end
		end
	end

	def has_ship?
		!@has_ship.nil?
	end

	def valid_ship?
		!@ship.nil?
	end

	def has_targets?
		!@bearing_vectors.nil? and @bearing_vectors.length>0
	end

end