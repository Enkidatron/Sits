class StrictNavigation
	include NavigationHelper
	include BearingsHelper

	attr_reader :loose, :possible_middle_piv, :possible_end_piv, :possible_middle_rol, :possible_end_rol, :strict_piv, :strict_rol

	def strict_analyze(start,midpoint,endpoint)
		start_end_dist = get_window_distance(start,endpoint)
		start_mid_dist = get_window_distance(start,midpoint)
		mid_end_dist = get_window_distance(midpoint,endpoint)
		if start_end_dist % 2 == 0
			#even
			valid_dist = [start_end_dist / 2]
		else
			#odd
			valid_dist = [(start_end_dist-1)/2,(start_end_dist+1)/2]
		end
		if valid_dist.include?(start_mid_dist) and start_mid_dist + mid_end_dist == start_end_dist
			return true
		else
			return false
		end
	end

	def generate_middle_values(start,endpoint)
		start_end_dist = get_window_distance(start,endpoint)
		if start_end_dist % 2 == 0
			#even
			start_ring = get_adjusted_window_chart(start)[start_end_dist/2]
			end_ring = get_adjusted_window_chart(endpoint)[start_end_dist/2]
		else
			#odd
			start_chart = get_adjusted_window_chart(start)
			start_ring = start_chart[(start_end_dist-1)/2] + start_chart[(start_end_dist+1)/2]
			end_chart = get_adjusted_window_chart(endpoint)
			end_ring = end_chart[(start_end_dist-1)/2] + start_chart[(start_end_dist+1)/2]
		end
		answers = []
		start_ring.each do |bearing|
			if end_ring.include?(bearing)
				answers += [bearing]
			end
		end
		answers
	end

	def generate_end_values(start,midpoint,travel)
		start_mid_dist = get_window_distance(start,midpoint)
		possible_end_distance = [(start_mid_dist*2)-1,(start_mid_dist*2),(start_mid_dist*2)+1].reject{|v| v < 0 or v > travel}
		possible_mid_distance = [start_mid_dist-1, start_mid_dist, start_mid_dist +1].reject{|v| v < 0}
		start_ring = []
		mid_ring = []
		possible_end_distance.each do |distance|
			start_ring += get_adjusted_window_chart(start)[distance]
		end
		possible_mid_distance.each do |distance|
			mid_ring += get_adjusted_window_chart(midpoint)[distance]
		end
		potential_answers = start_ring & mid_ring
		answers = potential_answers.reject{|bearing| get_window_distance(midpoint,bearing) + start_mid_dist != get_window_distance(start,bearing)}
		# start_ring.each do |bearing|
		# 	if mid_ring.include?(bearing) and get_window_distance(midpoint,bearing) + start_mid_dist == get_window_distance(start,bearing)
		# 		answers += [bearing]
		# 	end
		# end
		answers
	end


	def initialize(start,middle,endpoint,piv,rol)
		@loose = LooseNavigation.new(start,middle,endpoint,piv,rol)
		pivots = [@loose.start_mid_piv, @loose.mid_end_piv, @loose.start_end_piv]
		rolls = [@loose.start_mid_rol, @loose.mid_end_rol, @loose.start_end_rol]
		case pivots
		when [true, true, true]
			#if all pivots are in place, strict validate them
			@strict_piv = strict_analyze(@loose.start_bearings[0],@loose.middle_bearings[0],@loose.endpoint_bearings[0])
		when [nil, nil, true], [false, false, true]
			#we are missing the middle (nil) or it is out of place, but end is good (false)
			@possible_middle_piv = generate_middle_values(@loose.start_bearings[0],@loose.endpoint_bearings[0])
		when [true, nil, nil], [true, false, false]
			#we are missing the end (nil) or it is out of place, but middle is good (false)
			@possible_end_piv = generate_end_values(@loose.start_bearings[0],@loose.middle_bearings[0],@loose.pivot)
		end
		case rolls
		when [true, true, true]
			#if all rolls are in place, strict validate them
			@strict_rol = strict_analyze(@loose.start_bearings[1],@loose.middle_bearings[1],@loose.endpoint_bearings[1])
		when [nil, nil, true], [false,false,true]
			#we are missing the middle (nil) or it is out of place, but end is good (false)
			@possible_middle_rol = generate_middle_values(@loose.start_bearings[1],@loose.endpoint_bearings[1])
		when [true, nil, nil], [true, false, false]
			#we are missing the end (nil) or it is out of place, but middle is good (false)
			@possible_end_rol = generate_end_values(@loose.start_bearings[1],@loose.middle_bearings[1],@loose.roll)
		end
	end

end