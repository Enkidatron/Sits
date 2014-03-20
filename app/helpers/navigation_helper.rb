module NavigationHelper

	def split_bearing(bearing)
		breakpoint = bearing.to_s.index(/[+-]/)
		case breakpoint
		when nil
			return bearing.intern, :''
		when 0 
			return :'', bearing.intern
		else
			return bearing[0..breakpoint-1].intern, bearing[breakpoint..-1].intern
		end
	end

	def invert_bearing(bearing)
		ring = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		letters, symbols = split_bearing(bearing)
		case symbols
		when :'---'
			return :'+++'
		when :'+++'
			return :'---'
		when :'++',:'+'
			return "#{ring[ring.index(letters).to_i-6].to_s}#{symbols.to_s.gsub('+','-')}".intern
		when :'--',:'-'
			return "#{ring[ring.index(letters).to_i-6].to_s}#{symbols.to_s.gsub('-','+')}".intern
		when :''
			return ring[ring.index(letters).to_i-6]
		end
	end

	def spin_bearing(bearing, offset)
		ring = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		if offset % 2 == 1 then offset -= 1 end
		letters, symbols = split_bearing(bearing)
		case symbols
		when :'+++',:'---'
			answer = bearing
		else
			answer = "#{ring[ring.index(letters).to_i-offset].to_s}#{symbols.to_s}".intern
		end
		return answer
	end

	def unwrap(bearing)
		unwrap_table=[:'+++',:'a++',:'b++',:'c++',:'d++',:'e++',:'f++',:'a+',:'ab+',:'b+',:'bc+',:'c+',:'cd+',:'d+',:'de+',:'e+',:'ef+',:'f+',:'fa+',:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa',:'a-',:'ab-',:'b-',:'bc-',:'c-',:'cd-',:'d-',:'de-',:'e-',:'ef-',:'f-',:'fa-',:'a--',:'b--',:'c--',:'d--',:'e--',:'f--',:'---',:'ab++',:'bc++',:'cd++',:'de++',:'ef++',:'fa++',:'ab--',:'bc--',:'cd--',:'de--',:'ef--',:'fa--']
		return unwrap_table.index(bearing)
	end

	def rotate_windows(front, top)
		bluegreen = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		if front.to_s[-1] == '-' then 
			front = invert_bearing(front)
			top = invert_bearing(top)
		end
		front_letters, front_symbols = split_bearing(front)
		case front_symbols
		when :'+++',:'---'

		when :'++',:'--',:'+',:'-',:''
			offset = bluegreen.index(front_letters)
			front = spin_bearing(front,offset)
			top = spin_bearing(top,offset)
		end
		return front, top
	end

	def get_distance_chart(origin)
		case origin
			#      |   |         green         |                     blue                      |                     orange                    |                    low blue                   |       low green       |   |    green line high    |    green line low     |
		when :'a'
			return [3.0,2.0,2.2,3.2,4.0,3.2,2.2,1.0,1.2,2.2,3.2,4.2,4.3,5.0,4.3,4.2,3.2,2.2,1.2,0.0,1.0,2.0,3.0,4.0,5.0,6.0,5.0,4.0,3.0,2.0,1.0,1.0,1.2,2.2,3.2,4.2,4.3,5.0,4.3,4.2,3.2,2.2,1.2,2.0,2.2,3.2,4.0,3.2,2.2,3.0,2.2,3.2,4.0,4.0,3.2,2.2,2.2,3.2,4.0,4.0,3.2,2.2]
		when :'ab'
			return [3.0,2.0,2.0,3.0,4.0,4.0,3.0,1.2,1.0,1.2,2.2,3.2,4.2,5.0,5.0,5.0,4.2,3.2,2.2,1.0,0.0,1.0,2.0,3.0,4.0,5.0,6.0,5.0,4.0,3.0,2.0,1.2,1.0,1.2,2.2,3.2,4.2,5.0,5.0,5.0,4.2,3.2,2.2,2.0,2.0,3.0,4.0,4.0,3.0,3.0,2.0,3.0,4.0,4.0,4.0,3.0,2.0,3.0,4.0,4.0,4.0,3.0]
		when :'a+'
			return [2.0,1.0,2.0,3.0,3.0,3.0,2.0,0.0,1.0,2.0,3.0,4.0,4.0,4.0,4.0,4.0,3.0,2.0,1.0,1.0,1.2,2.2,3.2,4.2,5.0,5.0,5.0,4.2,3.2,2.2,1.2,2.0,2.2,3.2,4.2,5.2,5.2,6.0,5.2,5.2,4.2,3.2,2.2,3.0,3.2,4.2,5.0,4.2,3.2,4.0,2.0,3.0,3.0,3.0,3.0,2.0,3.2,4.2,5.0,5.0,4.2,3.2]
		when :'ab+'
			return [2.0,1.0,1.0,2.0,3.0,3.0,2.0,1.0,0.0,1.0,2.0,3.0,3.1,4.0,4.0,4.0,3.1,3.0,2.0,1.2,1.0,1.2,2.2,3.2,4.0,4.2,5.0,4.2,4.0,3.2,2.2,2.2,2.0,2.2,3.2,4.2,5.0,5.2,6.0,5.2,5.0,4.2,3.2,3.0,3.0,4.0,5.0,5.0,4.0,4.0,1.0,2.0,3.0,3.0,3.0,2.0,3.0,4.2,5.0,5.0,5.0,4.2]
		when :'a++'
			return [1.0,0.0,1.0,2.0,2.0,2.0,1.0,1.0,1.0,2.0,2.1,3.0,3.0,3.0,3.0,3.0,2.1,2.0,1.0,2.0,2.0,2.2,3.0,3.2,4.0,4.0,4.0,3.2,3.0,2.2,2.0,3.0,3.0,3.2,4.0,4.2,5.0,5.2,5.0,4.2,4.0,3.2,3.0,4.0,4.0,5.0,6.0,5.0,4.0,5.0,1.0,2.0,2.0,2.0,2.0,1.0,4.0,5.0,6.0,6.0,5.0,4.0]
		when :'+++'
			return [0.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,5.0,5.0,5.0,5.0,5.0,5.0,6.0,1.0,1.0,1.0,1.0,1.0,1.0,5.0,5.0,5.0,5.0,5.0,5.0]
		when :'ab++'
			return [1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,1.0,2.0,2.1,3.0,3.0,3.0,3.0,3.0,3.0,3.0,2.1,2.2,2.0,2.2,3.0,3.2,4.0,4.0,4.0,4.0,4.0,3.2,3.0,3.2,3.0,3.2,4.0,4.2,5.0,5.0,5.0,5.0,5.0,4.2,4.0,4.0,4.0,5.0,6.0,6.0,5.0,5.0,0.0,2.0,2.0,2.0,2.0,2.0,4.0,5.0,6.0,6.0,6.0,5.0]
		end
	end

	def get_window_chart(origin)
		case origin
		when :'a'
			return {0 => [:'a'], 1 => [:'a+',:'ab+',:'ab',:'ab-',:'a-',:'fa-',:'fa',:'fa+'], 2 => [:'a++',:'ab++',:'b++',:'b+',:'b',:'b-',:'b--',:'ab--',:'a--',:'fa--',:'f--',:'f-',:'f',:'f+',:'f++',:'fa++'], 3 => [:'+++',:'c++',:'bc++',:'bc+',:'bc',:'bc-',:'bc--',:'c--',:'---',:'e--',:'ef--',:'ef-',:'ef',:'ef+',:'ef++',:'e++'], 4 => [:'d++',:'cd++',:'cd+',:'c+',:'c',:'c-',:'cd-',:'cd--',:'d--',:'de--',:'de-',:'e-',:'e',:'e+',:'de+',:'de++'], 5 => [:'d+',:'cd',:'d-',:'de'], 6 => [:'d']}
		when :'ab'
			return {0 => [:'ab'], 1 => [:'ab+',:'b+',:'b',:'b-',:'ab-',:'a-',:'a',:'a+'], 2 => [:'ab++',:'b++',:'bc+',:'bc',:'bc-',:'b--',:'ab--',:'a--',:'fa-',:'fa',:'fa+',:'a++'], 3 => [:'+++',:'bc++',:'c++',:'c+',:'c',:'c-',:'c--',:'bc--',:'---',:'fa--',:'f--',:'f-',:'f',:'f+',:'f++',:'fa++'], 4 => [:'de++',:'d++',:'cd++',:'cd+',:'cd',:'cd-',:'cd--',:'d--',:'de--',:'e--',:'ef--',:'ef-',:'ef',:'ef+',:'ef++',:'e++'], 5 => [:'de+',:'d+',:'d',:'d-',:'de-',:'e-',:'e',:'e+'], 6 => [:'de']}
		when :'a+'
			return {0 => [:'a+'], 1 => [:'a++',:'ab+',:'ab',:'a',:'fa',:'fa+'], 2 => [:'+++',:'ab++',:'b++',:'b+',:'b',:'ab-',:'a-',:'fa-',:'f',:'f+',:'f++',:'fa++'], 3 => [:'d++',:'cd++',:'c++',:'bc++',:'bc+',:'bc',:'b-',:'b--',:'ab--',:'a--',:'fa--',:'f--',:'f-',:'ef',:'ef+',:'ef++',:'e++',:'de++'], 4 => [:'d+',:'cd+',:'c+',:'c',:'bc-',:'bc--',:'c--',:'---',:'e--',:'ef--',:'ef-',:'e',:'e+',:'de+'], 5 => [:'d',:'cd',:'cd-',:'c-',:'cd--',:'d--',:'de--',:'e-',:'de-',:'de'], 6 => [:'d-']}
		when :'ab+'
			return {0 => [:'ab+'], 1 => [:'ab++',:'b++',:'b+',:'b',:'ab',:'a',:'a+',:'a++'], 2 => [:'+++',:'c++',:'bc++',:'bc+',:'bc',:'b-',:'ab-',:'a-',:'fa',:'fa+',:'fa++',:'f++'], 3 => [:'de++',:'d++',:'cd++',:'cd+',:'c+',:'c',:'bc-',:'b--',:'ab--',:'a--',:'fa-',:'f',:'f+',:'ef+',:'ef++',:'e++'], 4 => [:'de+',:'d+',:'d',:'cd',:'c-',:'c--',:'bc--',:'---',:'fa--',:'f--',:'f-',:'ef',:'e',:'e+'], 5 => [:'de',:'d-',:'cd-',:'cd--',:'d--',:'de--',:'e--',:'ef--',:'ef-',:'e-'], 6 => [:'de-']}
		when :'a++'
			return {0 => [:'a++'], 1 => [:'+++',:'b++',:'ab++',:'ab+',:'a+',:'fa+',:'fa++',:'f++'], 2 => [:'d++',:'cd++',:'c++',:'bc++',:'bc+',:'b+',:'b',:'ab',:'a',:'fa',:'f',:'f+',:'ef+',:'ef++',:'e++',:'de++'], 3 => [:'d+',:'cd+',:'c+',:'c',:'bc',:'b-',:'ab-',:'a-',:'fa-',:'f-',:'ef',:'e',:'e+',:'de+'], 4 => [:'d',:'cd',:'c-',:'bc-',:'b--',:'ab--',:'a--',:'fa--',:'f--',:'ef-',:'e-',:'de'], 5 => [:'d-',:'cd-',:'c--',:'bc--',:'---',:'ef--',:'e--',:'de-'], 6 => [:'d--',:'cd--',:'de--']}
		when :'+++'
			return {0 => [:'+++'], 1 => [:'d++',:'cd++',:'c++',:'bc++',:'b++',:'ab++',:'a++',:'fa++',:'f++',:'ef++',:'e++',:'de++'], 2 => [:'d+',:'cd+',:'c+',:'bc+',:'b+',:'ab+',:'a+',:'fa+',:'f+',:'ef+',:'e+',:'de+'], 3 => [:'d',:'cd',:'c',:'bc',:'b',:'ab',:'a',:'fa',:'f',:'ef',:'e',:'de'], 4 => [:'d-',:'cd-',:'c-',:'bc-',:'b-',:'ab-',:'a-',:'fa-',:'f-',:'ef-',:'e-',:'de-'], 5 => [:'d--',:'cd--',:'c--',:'bc--',:'b--',:'ab--',:'a--',:'fa--',:'f--',:'ef--',:'e--',:'de--'], 6 => [:'---']}
		when :'ab++'
			return {0 => [:'ab++'], 1 => [:'+++',:'b++',:'ab+',:'a++'], 2 => [:'de++',:'d++',:'cd++',:'c++',:'bc++',:'bc+',:'b+',:'b',:'ab',:'a',:'a+',:'fa+',:'fa++',:'f++',:'ef++',:'e++'], 3 => [:'de+',:'d+',:'cd+',:'c+',:'c',:'bc',:'b-',:'ab-',:'a-',:'fa',:'f',:'f+',:'ef+',:'e+'], 4 => [:'de',:'d',:'cd',:'c-',:'bc-',:'b--',:'ab--',:'a--',:'fa-',:'f-',:'ef',:'e'], 5 => [:'de-',:'d-',:'cd-',:'c--',:'bc--',:'---',:'fa--',:'f--',:'ef-',:'e-'], 6 => [:'de--',:'d--',:'cd--',:'ef--',:'e--']}
		end
	end	

	def get_adjusted_window_chart(window)
		invert = false
		if window.to_s[-1] == '-'
			window = invert_bearing(window)
			invert = true
		end
		blue = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		letters,symbols = split_bearing(window)
		offset = blue.index(letters)
		offset ||= 0
		fix = letters.length == 2 ? 2 : 0
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

	def validate_bearing(bearing, lines=false)
		return false if bearing.nil?
		bluegreen = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		orange = [:'a',:'b',:'c',:'d',:'e',:'f']
		purple = [:'']
		letters, symbols = split_bearing(bearing)
		case symbols
		when :'+',:'-'
			if bluegreen.include?(letters) then true else false end
		when :'++',:'--'
			if lines
				if bluegreen.include?(letters) then true else false end
			else
				if orange.include?(letters) then true else false end
			end
		when :'+++', :'---'
			if purple.include?(letters) then true else false end
		when :''
			if bluegreen.include?(letters) then true else false end
		else
			false
		end
	end

end
