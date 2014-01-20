module NavigationHelper

	# def bearing_to_angle(bearing)
	# 	azimuth = {''=>0,'a'=>0,'ab'=>30,'b'=>60,'bc'=>90,'c'=>120,'cd'=>150,'d'=>180,'de'=>210,'e'=>240,'ef'=>270,'f'=>300,'fa'=>330}
	# 	elevation = {''=>0,'+'=>30,'++'=>60,'+++'=>90,'-'=>-30,'--'=>-60,'---'=>-90}
	# 	letters, symbols = split_bearing(bearing)
	# 	puts letters, symbols
	# 	return deg_to_rad(azimuth[letters]), deg_to_rad(elevation[symbols])
	# end

	# def angles_to_unit_vector(angles)
	# 	x = Math.cos(angles[1]) * Math.cos(angles[0])
	# 	y = Math.cos(angles[1]) * Math.sin(angles[0])
	# 	z = Math.sin(angles[1])
	# 	[x,y,z]
	# end

	# def dot_product(u,v)
	# 	u[0]*v[0]+u[1]*v[1]+u[2]*v[2]
	# end

	# def magnitude(v)
	# 	Math.sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2])
	# end

	# def get_angle(u,v)
	# 	rad_to_deg(Math.acos(dot_product(u,v)/(magnitude(u)*magnitude(v))))
	# end

	# def rad_to_deg(x)
	# 	((x * 180 / Math::PI) + 360) % 360
	# end

	# def deg_to_rad(x)
	# 	x * Math::PI / 180
	# end

	def split_bearing(bearing)
		breakpoint = bearing.index(/[+-]/)
		case breakpoint
		when nil
			return bearing, ''
		when 0 
			return '', bearing
		else
			return bearing[0..breakpoint-1], bearing[breakpoint..-1]
		end
	end

	def invert_bearing(bearing)
		ring = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		letters, symbols = split_bearing(bearing)
		case symbols
		when '---'
			return '+++'
		when '+++'
			return '---'
		when '++','+'
			return "#{ring[ring.index(letters).to_i-6]}#{symbols.gsub('+','-')}"
		when '--','-'
			return "#{ring[ring.index(letters).to_i-6]}#{symbols.gsub('-','+')}"
		when ''
			return "#{ring[ring.index(letters).to_i-6]}"
		end
	end

	def spin_bearing(bearing, offset)
		ring = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		if offset % 2 == 1 then offset -= 1 end
		letters, symbols = split_bearing(bearing)
		case symbols
		when '+++','---'
			answer = bearing
		else
			answer = "#{ring[ring.index(letters).to_i-offset]}#{symbols}"
		end
		return answer
	end

	def unwrap(bearing)
		unwrap_table=['+++','a++','b++','c++','d++','e++','f++','a+','ab+','b+','bc+','c+','cd+','d+','de+','e+','ef+','f+','fa+','a','ab','b','bc','c','cd','d','de','e','ef','f','fa','a-','ab-','b-','bc-','c-','cd-','d-','de-','e-','ef-','f-','fa-','a--','b--','c--','d--','e--','f--','---','ab++','bc++','cd++','de++','ef++','fa++','ab--','bc--','cd--','de--','ef--','fa--']
		return unwrap_table.index(bearing)
	end

	def rotate_windows(front, top)
		bluegreen = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		if front[-1] == '-' then 
			front = invert_bearing(front)
			top = invert_bearing(top)
		end
		front_letters, front_symbols = split_bearing(front)
		case front_symbols
		when '+++','---'

		when '++','--','+','-',''
			offset = bluegreen.index(front_letters)
			front = spin_bearing(front,offset)
			top = spin_bearing(top,offset)
		end
		return front, top
	end

	def get_distance_chart(origin)
		case origin
			#          |         green         |                     blue                      |                     orange                    |                    low blue                   |       low green       |   |    green line high    |    green line low     |
		when 'a'
			return [3.0,2.0,2.2,3.2,4.0,3.2,2.2,1.0,1.2,2.2,3.2,4.2,4.3,5.0,4.3,4.2,3.2,2.2,1.2,0.0,1.0,2.0,3.0,4.0,5.0,6.0,5.0,4.0,3.0,2.0,1.0,1.0,1.2,2.2,3.2,4.2,4.3,5.0,4.3,4.2,3.2,2.2,1.2,2.0,2.2,3.2,4.0,3.2,2.2,3.0,2.2,3.2,4.0,4.0,3.2,2.2,2.2,3.2,4.0,4.0,3.2,2.2]
		when 'ab'
			return [3.0,2.0,2.0,3.0,4.0,4.0,3.0,1.2,1.0,1.2,2.2,3.2,4.2,5.0,5.0,5.0,4.2,3.2,2.2,1.0,0.0,1.0,2.0,3.0,4.0,5.0,6.0,5.0,4.0,3.0,2.0,1.2,1.0,1.2,2.2,3.2,4.2,5.0,5.0,5.0,4.2,3.2,2.2,2.0,2.0,3.0,4.0,4.0,3.0,3.0,2.0,3.0,4.0,4.0,4.0,3.0,2.0,3.0,4.0,4.0,4.0,3.0]
		when 'a+'
			return [2.0,1.0,2.0,3.0,3.0,3.0,2.0,0.0,1.0,2.0,3.0,4.0,4.0,4.0,4.0,4.0,3.0,2.0,1.0,1.0,1.2,2.2,3.2,4.2,5.0,5.0,5.0,4.2,3.2,2.2,1.2,2.0,2.2,3.2,4.2,5.2,5.2,6.0,5.2,5.2,4.2,3.2,2.2,3.0,3.2,4.2,5.0,4.2,3.2,4.0,2.0,3.0,3.0,3.0,3.0,2.0,3.2,4.2,5.0,5.0,4.2,3.2]
		when 'ab+'
			return [2.0,1.0,1.0,2.0,3.0,3.0,2.0,1.0,0.0,1.0,2.0,3.0,3.1,4.0,4.0,4.0,3.1,3.0,2.0,1.2,1.0,1.2,2.2,3.2,4.0,4.2,5.0,4.2,4.0,3.2,2.2,2.2,2.0,2.2,3.2,4.2,5.0,5.2,6.0,5.2,5.0,4.2,3.2,3.0,3.0,4.0,5.0,5.0,4.0,4.0,1.0,2.0,3.0,3.0,3.0,2.0,3.0,4.2,5.0,5.0,5.0,4.2]
		when 'a++'
			return [1.0,0.0,1.0,2.0,2.0,2.0,1.0,1.0,1.0,2.0,2.1,3.0,3.0,3.0,3.0,3.0,2.1,2.0,1.0,2.0,2.0,2.2,3.0,3.2,4.0,4.0,4.0,3.2,3.0,2.2,2.0,3.0,3.0,3.2,4.0,4.2,5.0,5.2,5.0,4.2,4.0,3.2,3.0,4.0,4.0,5.0,6.0,5.0,4.0,5.0,1.0,2.0,2.0,2.0,2.0,1.0,4.0,5.0,6.0,6.0,5.0,4.0]
		when '+++'
			return [0.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,5.0,5.0,5.0,5.0,5.0,5.0,6.0,1.0,1.0,1.0,1.0,1.0,1.0,5.0,5.0,5.0,5.0,5.0,5.0]
		when 'ab++'
			return [1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,1.0,2.0,2.1,3.0,3.0,3.0,3.0,3.0,3.0,3.0,2.1,2.2,2.0,2.2,3.0,3.2,4.0,4.0,4.0,4.0,4.0,3.2,3.0,3.2,3.0,3.2,4.0,4.2,5.0,5.0,5.0,5.0,5.0,4.2,4.0,4.0,4.0,5.0,6.0,6.0,5.0,5.0,0.0,2.0,2.0,2.0,2.0,2.0,4.0,5.0,6.0,6.0,6.0,5.0]
		end
	end

	def get_window_chart(origin)
		case origin
		when 'a'
			return {0 => ['a'], 1 => ['ab','fa','ab+','a+','fa+','ab-','a-','fa-'], 2 => ['b','f','b+','f+','b++','a++','f++','b-','f-','b--','a--','f--','ab++','fa++','ab--','fa--'], 3 => ['bc','ef','bc+','ef+','c++','e++','+++','bc-','ef-','c--','e--','---','bc++','ef++','bc--','ef--'], 4 => ['c','e','c+','e+','cd+','de+','d++','c-','e-','cd-','de-','d--','cd++','de++','cd--','de--'], 5 => ['cd','de','d+','d-'], 6 => ['d']}
		when 'ab'
			return {0 => ['ab'], 1 => ['b','a','b+','ab+','a+','b-','ab-','a-'], 2 => ['bc','fa','bc+','fa+','b++','a++','bc-','fa-','b--','a--','ab++','ab--'], 3 => ['c','f','c+','f+','c++','f++','+++','c-','f-','c--','f--','---','bc++','fa++','bc--','fa--'], 4 => ['cd','ef','cd+','ef+','d++','e++','cd-','ef-','d--','e--','cd++','de++','ef++','cd--','de--','ef--'], 5 => ['d','e','d+','de+','e+','d-','de-','e-'], 6 => ['de']}
		when 'a+'
			return {0 => ['a+'], 1 => ['ab+','fa+','a++','ab','a','fa'], 2 => ['b+','f+','b++','f++','+++','b','f','ab-','a-','fa-','ab++','fa++'], 3 => ['bc+','ef+','c++','d++','e++','bc','ef','b-','f-','b--','a--','f--','bc++','cd++','de++','ef++','ab--','fa--'], 4 => ['c+','cd+','de+','e+','d+','c','e','bc-','c--','---','e--','ef-','bc--','ef--'], 5 => ['cd','d','de','d--','c-','e-','cd-','de-','cd--','de--'], 6 => ['d-']}
		when 'ab+'
			return {0 => ['ab+'], 1 => ['b+','a+','b++','a++','b','ab','a','ab++'], 2 => ['bc+','fa+','c++','f++','+++','bc','fa','a-','ab-','b-','bc++','fa++'], 3 => ['c+','f+','cd+','ef+','d++','e++','c','f','bc-','fa-','b--','a--','cd++','de++','ef++','ab--'], 4 => ['d+','de+','e+','d','e','cd','ef','c-','f-','c--','f--','---','bc--','fa--'], 5 => ['de','d-','e-','d--','e--','cd-','ef-','cd--','de--','ef--'], 6 => ['de-']}
		when 'a++'
			return {0 => ['a++'], 1 => ['b++','f++','+++','ab+','a+','fa+','ab++','fa++'], 2 => ['c++','d++','e++','bc+','b+','ef+','f+','f','fa','a','ab','b','bc++','cd++','de++','ef++'], 3 => ['d+','cd+','c+','de+','e+','bc','c','e','ef','b-','ab-','a-','fa-','f-'], 4 => ['d','cd','de','c-','bc-','ef-','e-','b--','a--','f--','ab--','fa--'], 5 => ['d-','cd-','de-','c--','e--','---','bc--','ef--'], 6 => ['d--','cd--','de--']}
		when '+++'
			return {0 => ['+++'], 1 => ['a++','b++','c++','d++','e++','f++','ab++','bc++','cd++','de++','ef++','fa++'], 2 => ['a+','ab+','b+','bc+','c+','cd+','d+','de+','e+','ef+','f+','fa+'], 3 => ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa'], 4 => ['a-','ab-','b-','bc-','c-','cd-','d-','de-','e-','ef-','f-','fa-'], 5 => ['a--','b--','c--','d--','e--','f--','ab--','bc--','cd--','de--','ef--','fa--'], 6 => ['---']}
		when 'ab++'
			return {0 => ['ab++'], 1 => ['a++','b++','+++','ab+'], 2 => ['c++','d++','e++','f++','a+','fa+','b+','bc+','a','ab','b','bc++','cd++','de++','ef++','fa++'], 3 => ['c+','cd+','d+','de+','e+','ef+','f+','c','f','fa','bc','a-','ab-','b-'], 4 => ['cd','d','de','e','ef','c-','bc-','f-','fa-','a--','ab--','b--'], 5 => ['ef-','e-','de-','d-','cd-','c--','f--','bc--','fa--','---'], 6 => ['cd--','d--','de--','e--','ef--']}
		end
	end	

	def get_adjusted_window_chart(window)
		blue = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		letters,symbols = split_bearing(window)
		offset = blue.index(letters)
		offset ||= 0
		fix = letters.length == 2 ? 2 : 0
		if window[-1] == '-'
			window = invert_bearing(window)
			invert = true
		end
		origin = spin_bearing(window,offset)
		chart = get_window_chart(origin)
		adjusted_chart = {}
		chart.each do |k,v|
			adjusted_chart[k] = v.map{|bearing| spin_bearing(bearing,12-offset+fix)}.map{|bearing| if invert then invert_bearing(bearing) else bearing end }
		end
		return adjusted_chart
	end

	def get_window_distance(first,second)
		# angle_one = bearing_to_angle(first)
		# angle_two = bearing_to_angle(second)
		# puts angle_one, angle_two
		# u = angles_to_unit_vector(angle_one)
		# v = angles_to_unit_vector(angle_two)
		# puts u,v
		# distance = get_angle(u,v)
		# puts distance
		# case 
		# when distance < 15
		# 	return 0
		# when distance < 45
		# 	return 1
		# when distance < 75
		# 	return 2
		# when distance < 105
		# 	return 3
		# when distance < 135
		# 	return 4
		# when distance < 165
		# 	return 5
		# else
		# 	return 6
		# end
		one,two = rotate_windows(first,second)
		get_distance_chart(one)[unwrap(two)].to_i
	end

end
