module BearingsHelper

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

	def validate_ship(front, top)
		blue = ['+++','bc++','bc+','bc','bc-','bc--','---','ef--','ef-','ef','ef+','ef++']
		blue_offset = ['+++','c++','c+','c','c-','c--','---','f--','f-','f','f+','f++']
		green = ['d++','c++','bc+','bc','bc-','b--','a--','f--','ef-','ef','ef+','e++']
		green_offset = ['de++','cd++','c+','c','c-','bc--','ab--','fa--','f-','f','f+','ef++']
		orange = ['d+','cd+','c+','bc','b-','ab-','a-','fa-','f-','ef','e+','de+']
		purple = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		top_rings = {'a' => blue, 'ab' => blue_offset, 'a+' => green, 'ab+' => green_offset, 'a++' => orange, '+++' => purple}
		ring = top_rings[front]
		if ring.include?(top) then true else false end
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

	def rotate_bearings(front, top, targets)
		bluegreen = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		invert = false
		if front[-1] == '-' then 
			front = invert_bearing(front)
			top = invert_bearing(top)
			targets = targets.map { |t| invert_bearing(t)} unless targets.nil?
			invert = true
		end
		front_letters, front_symbols = split_bearing(front)
		case front_symbols
		when '+++','---'

		when '++','--','+','-',''
			offset = bluegreen.index(front_letters)
			front = spin_bearing(front,offset)
			top = spin_bearing(top,offset)
			targets = targets.map { |t| spin_bearing(t,offset)} unless targets.nil?
		end
		return front, top, targets, invert
	end

	def unwrap(bearing)
		unwrap_table=['+++','a++','b++','c++','d++','e++','f++','a+','ab+','b+','bc+','c+','cd+','d+','de+','e+','ef+','f+','fa+','a','ab','b','bc','c','cd','d','de','e','ef','f','fa','a-','ab-','b-','bc-','c-','cd-','d-','de-','e-','ef-','f-','fa-','a--','b--','c--','d--','e--','f--','---']
		return unwrap_table.index(bearing)
	end

	def find_orb(front, top)
		case front
		when 'a'
			case top
			when '+++'
				# 		  pur|---orange--------------|---green-high----------------------------------|---blue----------------------------------------|---green-low-----------------------------------|---orange-low----------|pur
				return [:tw,:tw,:tw,:tw,:tw,:tw,:tw,:fr,:fs,:st,:st,:st,:tp,:tp,:tp,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:as,:aa,:ap,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:tp,:tp,:tp,:pt,:pt,:pt,:fp,:bw,:bw,:bw,:bw,:bw,:bw,:bw]
			when 'bc++'
				return [:tw,:tw,:tw,:tw,:tw,:pt,:pt,:fp,:fr,:tw,:tw,:tw,:tw,:tw,:ap,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:tw,:aa,:bw,:pt,:pt,:pt,:fp,:fs,:fs,:st,:st,:st,:as,:bw,:bw,:bw,:bw,:bw,:fr,:bw,:st,:st,:bw,:bw,:bw,:bw]
			when 'bc+'
				return [:pt,:pt,:tw,:tw,:pt,:pt,:pt,:fp,:fr,:tw,:tw,:tw,:tw,:tw,:ap,:pt,:pt,:pt,:fp,:fr,:fs,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:fp,:fs,:fs,:st,:st,:st,:as,:bw,:bw,:bw,:bw,:bw,:fr,:st,:st,:st,:st,:bw,:bw,:st]
			when 'bc'
				return [:pt,:pt,:pt,:pt,:pt,:pt,:pt,:fp,:fp,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:fp,:fr,:fr,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:fr,:fs,:fs,:tw,:tw,:tw,:tw,:as,:bw,:bw,:bw,:bw,:fs,:st,:st,:st,:st,:st,:st,:st]
			when 'bc-'
				return [:pt,:pt,:pt,:pt,:pt,:bw,:bw,:fp,:fp,:pt,:pt,:pt,:ap,:bw,:bw,:bw,:bw,:bw,:fr,:fr,:fp,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:fs,:fs,:fr,:tw,:tw,:tw,:tw,:tw,:as,:st,:st,:st,:fs,:st,:tw,:tw,:st,:st,:st,:st]
			when 'bc--'
				return [:bw,:bw,:pt,:pt,:bw,:bw,:bw,:fp,:fp,:pt,:pt,:pt,:ap,:bw,:bw,:bw,:bw,:bw,:fr,:fr,:fp,:pt,:pt,:pt,:tw,:aa,:bw,:st,:st,:st,:fs,:fs,:fr,:tw,:tw,:tw,:tw,:tw,:as,:st,:st,:st,:fs,:tw,:tw,:tw,:tw,:st,:st,:tw]
			when '---'
				return [:bw,:bw,:bw,:bw,:bw,:bw,:bw,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:ap,:aa,:as,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:tw,:tw,:tw,:st,:st,:st,:fs,:tw,:tw,:tw,:tw,:tw,:tw,:tw]
			when 'ef--'
				return [:bw,:bw,:bw,:bw,:bw,:st,:st,:fs,:fr,:bw,:bw,:bw,:bw,:bw,:as,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:aa,:tw,:st,:st,:st,:fs,:fp,:fp,:pt,:pt,:pt,:ap,:tw,:tw,:tw,:tw,:tw,:fr,:tw,:pt,:pt,:tw,:tw,:tw,:tw]
			when 'ef-'
				return [:st,:st,:bw,:bw,:st,:st,:st,:fs,:fr,:bw,:bw,:bw,:bw,:bw,:as,:st,:st,:st,:fs,:fr,:fp,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:fs,:fp,:fp,:pt,:pt,:pt,:ap,:tw,:tw,:tw,:tw,:tw,:fr,:pt,:pt,:pt,:pt,:tw,:tw,:pt]
			when 'ef'
				return [:st,:st,:st,:st,:st,:st,:st,:fs,:fs,:bw,:bw,:bw,:bw,:as,:tw,:bw,:bw,:tw,:fs,:fr,:fr,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:fr,:fp,:fp,:bw,:bw,:bw,:bw,:ap,:tw,:tw,:tw,:tw,:fp,:pt,:pt,:pt,:pt,:pt,:pt,:pt]
			when 'ef+'
				return [:st,:st,:st,:st,:st,:tw,:tw,:fs,:fs,:st,:st,:st,:as,:tw,:tw,:tw,:tw,:tw,:fr,:fr,:fs,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:fp,:fp,:fr,:bw,:bw,:bw,:bw,:bw,:ap,:pt,:pt,:pt,:fp,:pt,:bw,:bw,:pt,:pt,:pt,:pt]
			when 'ef++'
				return [:tw,:tw,:st,:st,:tw,:tw,:tw,:fs,:fs,:st,:st,:st,:as,:tw,:tw,:tw,:tw,:tw,:fr,:fr,:fs,:st,:st,:st,:bw,:aa,:tw,:pt,:pt,:pt,:fp,:fp,:fr,:bw,:bw,:bw,:bw,:bw,:ap,:pt,:pt,:pt,:fp,:bw,:bw,:bw,:bw,:pt,:pt,:bw]
			end
		when 'ab'
			case top
			when '+++'
				# 		  pur|---orange--------------|---green-high----------------------------------|---blue----------------------------------------|---green-low-----------------------------------|---orange-low----------|pur
				return [:tw,:tw,:tw,:tw,:tw,:tw,:tw,:fp,:fr,:fs,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:as,:aa,:ap,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:bw,:bw,:bw,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:bw,:bw]
			when 'c++'
				return [:tw,:pt,:tw,:tw,:tw,:pt,:pt,:fp,:fp,:fr,:tw,:tw,:tw,:tw,:tw,:ap,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:tw,:aa,:bw,:pt,:pt,:pt,:fr,:fs,:fs,:st,:st,:st,:as,:bw,:bw,:bw,:bw,:bw,:bw,:st,:st,:st,:bw,:bw,:bw]
			when 'c+'
				return [:pt,:pt,:tw,:tw,:tw,:pt,:pt,:fp,:fp,:fr,:tw,:tw,:tw,:tw,:tw,:ap,:pt,:pt,:pt,:fp,:fr,:fs,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:fr,:fs,:fs,:st,:st,:st,:as,:bw,:bw,:bw,:bw,:bw,:bw,:st,:st,:st,:bw,:bw,:st]
			when 'c'
				return [:pt,:pt,:pt,:pt,:pt,:pt,:pt,:fp,:fp,:fp,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:fr,:fr,:fr,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:fs,:fs,:fs,:tw,:tw,:tw,:tw,:as,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:st,:st,:st]
			when 'c-'
				return [:pt,:bw,:pt,:pt,:pt,:bw,:bw,:fr,:fp,:fp,:pt,:pt,:pt,:ap,:bw,:bw,:bw,:bw,:bw,:fs,:fr,:fp,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:fs,:fs,:fr,:tw,:tw,:tw,:tw,:tw,:as,:st,:st,:st,:st,:tw,:tw,:tw,:st,:st,:st]
			when 'c--'
				return [:bw,:bw,:pt,:pt,:pt,:bw,:bw,:fr,:fp,:fp,:pt,:pt,:pt,:ap,:bw,:bw,:bw,:bw,:bw,:fs,:fr,:fp,:pt,:pt,:pt,:tw,:aa,:bw,:st,:st,:st,:fs,:fs,:fr,:tw,:tw,:tw,:tw,:tw,:as,:st,:st,:st,:st,:tw,:tw,:tw,:st,:st,:tw]
			when '---'
				return [:bw,:bw,:bw,:bw,:bw,:bw,:bw,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:ap,:aa,:as,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:tw,:tw,:tw,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:tw,:tw]
			when 'f--'
				return [:bw,:st,:bw,:bw,:bw,:st,:st,:fs,:fs,:fr,:bw,:bw,:bw,:bw,:bw,:as,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:aa,:tw,:st,:st,:st,:fr,:fp,:fp,:pt,:pt,:pt,:ap,:tw,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:tw,:tw,:tw]
			when 'f-'
				return [:st,:st,:bw,:bw,:bw,:st,:st,:fs,:fs,:fr,:bw,:bw,:bw,:bw,:bw,:as,:st,:st,:st,:fs,:fr,:fp,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:fr,:fp,:fp,:pt,:pt,:pt,:ap,:tw,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:tw,:tw,:pt]
			when 'f'
				return [:st,:st,:st,:st,:st,:st,:st,:fs,:fs,:fs,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:fr,:fr,:fr,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:fp,:fp,:fp,:bw,:bw,:bw,:bw,:ap,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:pt,:pt,:pt]
			when 'f+'
				return [:st,:tw,:st,:st,:st,:tw,:tw,:fr,:fs,:fs,:st,:st,:st,:as,:tw,:tw,:tw,:tw,:tw,:fp,:fr,:fs,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:fp,:fp,:fr,:bw,:bw,:bw,:bw,:bw,:ap,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:pt,:pt,:pt]
			when 'f++'
				return [:tw,:tw,:st,:st,:st,:tw,:tw,:fr,:fs,:fs,:st,:st,:st,:as,:tw,:tw,:tw,:tw,:tw,:fp,:fr,:fs,:st,:st,:st,:bw,:aa,:tw,:pt,:pt,:pt,:fp,:fp,:fr,:bw,:bw,:bw,:bw,:bw,:ap,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:pt,:pt,:bw]
			end
		when 'a+'
			case top
			when 'd++'
				# 		  pur|---orange--------------|---green-high----------------------------------|---blue----------------------------------------|---green-low-----------------------------------|---orange-low----------|pur
				return [:tw,:fr,:fs,:tw,:tw,:tw,:fp,:fr,:fs,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:fp,:bw,:bw,:st,:st,:st,:as,:aa,:ap,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:bw,:bw,:bw]
			when 'c++'
				return [:tw,:fp,:tw,:tw,:tw,:pt,:pt,:fr,:fr,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:fp,:fs,:fs,:st,:st,:st,:tw,:tw,:ap,:pt,:pt,:pt,:fr,:bw,:st,:st,:st,:st,:as,:aa,:bw,:bw,:bw,:bw,:bw,:bw,:st,:st,:bw,:bw,:bw,:bw]
			when 'bc+'
				return [:pt,:fp,:tw,:tw,:pt,:pt,:pt,:fr,:fr,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:pt,:fp,:fs,:fs,:tw,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:fr,:st,:st,:st,:st,:st,:as,:aa,:bw,:bw,:bw,:bw,:bw,:st,:st,:st,:bw,:bw,:bw,:st]
			when 'bc'
				return [:pt,:fp,:fp,:pt,:pt,:pt,:fp,:fr,:fr,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:fr,:fs,:fs,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:fs,:st,:st,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:st,:st,:st,:tw,:as,:bw,:st,:st]
			when 'bc-'
				return [:pt,:fp,:pt,:pt,:pt,:bw,:bw,:fr,:fp,:pt,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:fr,:fs,:fr,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:bw,:fs,:st,:tw,:tw,:tw,:tw,:tw,:aa,:as,:st,:st,:st,:st,:st,:tw,:tw,:tw,:st,:st,:st]
			when 'b--'
				return [:bw,:fp,:pt,:pt,:bw,:bw,:bw,:fr,:fp,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:fr,:fs,:fr,:pt,:pt,:pt,:ap,:bw,:bw,:st,:st,:st,:fs,:tw,:tw,:tw,:tw,:tw,:tw,:aa,:as,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:st,:st,:tw]
			when 'a--'
				return [:bw,:fr,:fp,:bw,:bw,:bw,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:fs,:tw,:tw,:pt,:pt,:pt,:ap,:aa,:as,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:tw,:tw,:tw]
			when 'f--'
				return [:bw,:fs,:bw,:bw,:bw,:st,:st,:fr,:fr,:bw,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:fs,:fp,:fp,:pt,:pt,:pt,:bw,:bw,:as,:st,:st,:st,:fr,:tw,:pt,:pt,:pt,:pt,:ap,:aa,:tw,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:tw,:tw,:tw,:tw]
			when 'ef-'
				return [:st,:fs,:bw,:bw,:st,:st,:st,:fr,:fr,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:st,:fs,:fp,:fp,:bw,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:fr,:pt,:pt,:pt,:pt,:pt,:ap,:aa,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:tw,:tw,:tw,:pt]
			when 'ef'
				return [:st,:fs,:fs,:st,:st,:st,:fs,:fr,:fr,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:fr,:fp,:fp,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:fp,:pt,:pt,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:ap,:tw,:pt,:pt]
			when 'ef+'
				return [:st,:fs,:st,:st,:st,:tw,:tw,:fr,:fs,:st,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:fr,:fp,:fr,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:tw,:fp,:pt,:bw,:bw,:bw,:bw,:bw,:aa,:ap,:pt,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:pt,:pt,:pt]
			when 'e++'
				return [:tw,:fs,:st,:st,:tw,:tw,:tw,:fr,:fs,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:fr,:fp,:fr,:st,:st,:st,:as,:tw,:tw,:pt,:pt,:pt,:fp,:bw,:bw,:bw,:bw,:bw,:bw,:aa,:ap,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:pt,:pt,:bw]
			end
		when 'ab+'
			case top
				# 		  pur|---orange--------------|---green-high----------------------------------|---blue----------------------------------------|---green-low-----------------------------------|---orange-low----------|pur
			when 'de++'
				return [:tw,:fr,:fr,:tw,:tw,:tw,:tw,:fp,:fr,:fs,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:fp,:fr,:fs,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:as,:aa,:ap,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:bw,:bw]
			when 'cd++'
				return [:tw,:fp,:fr,:tw,:tw,:tw,:pt,:fp,:fr,:fs,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:fr,:fs,:fs,:st,:st,:st,:tw,:tw,:ap,:pt,:pt,:pt,:bw,:bw,:st,:st,:st,:st,:as,:aa,:bw,:bw,:bw,:bw,:bw,:bw,:st,:bw,:bw,:bw,:bw]
			when 'c+'
				return [:pt,:fp,:fp,:tw,:tw,:pt,:pt,:fp,:fr,:fr,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:pt,:fr,:fs,:fs,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:st,:tw,:aa,:bw,:bw,:bw,:bw,:bw,:st,:st,:as,:bw,:bw,:st]
			when 'c'
				return [:pt,:fp,:fp,:pt,:pt,:pt,:pt,:fr,:fr,:fr,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:fs,:fs,:fs,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:tw,:aa,:bw,:bw,:bw,:bw,:st,:st,:st,:as,:as,:st,:st]
			when 'c-'
				return [:pt,:fp,:fp,:pt,:pt,:bw,:bw,:fr,:fr,:fp,:pt,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:fs,:fs,:fr,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:st,:st,:tw,:tw,:tw,:tw,:tw,:aa,:bw,:st,:st,:st,:st,:tw,:tw,:tw,:as,:st,:st]
			when 'bc--'
				return [:bw,:fr,:fp,:pt,:bw,:bw,:bw,:fs,:fr,:fp,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:fs,:fs,:fr,:pt,:pt,:pt,:ap,:bw,:bw,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:tw,:aa,:as,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:st,:tw]
			when 'ab--'
				return [:bw,:fr,:fr,:bw,:bw,:bw,:bw,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:ap,:aa,:as,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:tw,:tw]
			when 'fa--'
				return [:bw,:fs,:fr,:bw,:bw,:bw,:st,:fs,:fr,:fp,:bw,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:fr,:fp,:fp,:pt,:pt,:pt,:bw,:bw,:as,:st,:st,:st,:tw,:tw,:pt,:pt,:pt,:pt,:ap,:aa,:tw,:tw,:tw,:tw,:tw,:tw,:pt,:tw,:tw,:tw,:tw]
			when 'f-'
				return [:st,:fs,:fs,:bw,:bw,:st,:st,:fs,:fr,:fr,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:st,:fr,:fp,:fp,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:pt,:bw,:aa,:tw,:tw,:tw,:tw,:tw,:pt,:pt,:ap,:tw,:tw,:pt]
			when 'f'
				return [:st,:fs,:fs,:st,:st,:st,:st,:fr,:fr,:fr,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:fp,:fp,:fp,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:aa,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:ap,:ap,:pt,:pt]
			when 'f+'
				return [:st,:fs,:fs,:st,:st,:tw,:tw,:fr,:fr,:fs,:st,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:fp,:fp,:fr,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:aa,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:ap,:pt,:pt]
			when 'ef++'
				return [:tw,:fr,:fs,:st,:tw,:tw,:tw,:fp,:fr,:fs,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:tw,:fp,:fp,:fr,:st,:st,:st,:as,:tw,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:bw,:bw,:aa,:ap,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:ap,:pt,:pt]
			end
		when 'a++'
			case top
				# 		  pur|---orange--------------|---green-high----------------------------------|---blue----------------------------------------|---green-low-----------------------------------|---orange-low----------|pur
			when 'd+'
				return [:fr,:fr,:fs,:tw,:tw,:tw,:fp,:fr,:fs,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:fp,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:as,:aa,:ap,:bw,:bw]
			when 'cd+'
				return [:fp,:fr,:fr,:tw,:tw,:pt,:fp,:fs,:fs,:st,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:fr,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:st,:tw,:tw,:ap,:pt,:bw,:bw,:bw,:bw,:st,:as,:aa,:bw,:bw,:bw]
			when 'c+'
				return [:fp,:fr,:fr,:tw,:pt,:pt,:fp,:fs,:fs,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:bw,:fr,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:st,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:st,:st,:as,:aa,:bw,:bw,:bw]
			when 'bc'
				return [:fp,:fr,:fr,:pt,:pt,:pt,:fr,:fs,:fs,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:fs,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:bw,:st,:st,:st,:tw,:aa,:bw,:st,:as]
			when 'b-'
				return [:fp,:fr,:fp,:pt,:pt,:bw,:fr,:fs,:fr,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:fs,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:tw,:ap,:bw,:bw,:bw,:st,:st,:st,:st,:tw,:tw,:aa,:as,:st,:tw]
			when 'ab-'
				return [:fp,:fr,:fp,:pt,:bw,:bw,:fr,:fs,:fr,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:st,:fs,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:tw,:pt,:ap,:bw,:bw,:st,:st,:st,:st,:tw,:tw,:tw,:aa,:as,:st,:tw]
			when 'a-'
				return [:fr,:fr,:fp,:bw,:bw,:bw,:fs,:fr,:fp,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:fs,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:ap,:aa,:as,:tw,:tw]
			when 'fa-'
				return [:fs,:fr,:fr,:bw,:bw,:st,:fs,:fp,:fp,:pt,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:fr,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:as,:st,:tw,:tw,:tw,:tw,:pt,:ap,:aa,:tw,:tw,:tw]
			when 'f-'
				return [:fs,:fr,:fr,:bw,:st,:st,:fs,:fp,:fp,:bw,:bw,:bw,:bw,:st,:st,:st,:st,:tw,:fr,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:pt,:pt,:ap,:aa,:tw,:tw,:tw]
			when 'ef'
				return [:fs,:fr,:fr,:st,:st,:st,:fr,:fp,:fp,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:fp,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:aa,:tw,:pt,:ap]
			when 'e+'
				return [:fs,:fr,:fs,:st,:st,:tw,:fr,:fp,:fr,:bw,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:fp,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:as,:tw,:tw,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:aa,:ap,:pt,:bw]
			when 'de+'
				return [:fs,:fr,:fs,:st,:tw,:tw,:fr,:fp,:fr,:st,:st,:st,:st,:tw,:tw,:tw,:tw,:pt,:fp,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:bw,:st,:as,:tw,:tw,:pt,:pt,:pt,:pt,:bw,:bw,:bw,:aa,:ap,:pt,:bw]
			end
		when '+++'
			case top 
				# 		  pur|---orange--------------|---green-high----------------------------------|---blue----------------------------------------|---green-low-----------------------------------|---orange-low----------|pur
			when 'd'
				return [:fr,:fr,:fs,:fs,:fr,:fp,:fp,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:as,:as,:tw,:ap,:ap,:aa]
			when 'cd'
				return [:fr,:fr,:fs,:fr,:fr,:fp,:fr,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:as,:tw,:tw,:ap,:bw,:aa]
			when 'c'
				return [:fr,:fs,:fs,:fr,:fp,:fp,:fr,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:as,:as,:tw,:ap,:ap,:bw,:aa]
			when 'bc'
				return [:fr,:fs,:fr,:fr,:fp,:fr,:fr,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:as,:tw,:tw,:ap,:bw,:bw,:aa]
			when 'b'
				return [:fr,:fs,:fr,:fp,:fp,:fr,:fs,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:as,:tw,:ap,:ap,:bw,:as,:aa]
			when 'ab'
				return [:fr,:fr,:fr,:fp,:fr,:fr,:fs,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:ap,:bw,:bw,:as,:aa]
			when 'a'
				return [:fr,:fr,:fp,:fp,:fr,:fs,:fs,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:ap,:ap,:bw,:as,:as,:aa]
			when 'fa'
				return [:fr,:fr,:fp,:fr,:fr,:fs,:fr,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:ap,:bw,:bw,:as,:tw,:aa]
			when 'f'
				return [:fr,:fp,:fp,:fr,:fs,:fs,:fr,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:ap,:ap,:bw,:as,:as,:tw,:aa]
			when 'ef'
				return [:fr,:fp,:fr,:fr,:fs,:fr,:fr,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:ap,:bw,:bw,:as,:tw,:tw,:aa]
			when 'e'
				return [:fr,:fp,:fr,:fs,:fs,:fr,:fp,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:ap,:bw,:as,:as,:tw,:ap,:aa]
			when 'de'
				return [:fr,:fr,:fr,:fs,:fr,:fr,:fp,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:bw,:st,:st,:st,:tw,:tw,:tw,:pt,:pt,:pt,:bw,:bw,:as,:tw,:tw,:ap,:aa]
			end
		end	
	end

	def evaluate_aspect(front, top, target, invert)
		if invert then
			translation = {tw: 'Top Wedge', bw: 'Bottom Wedge', st: 'Port Broadside', pt: 'Starboard Broadside', fr: 'Fore, unprotected', fs: 'Fore, Port Sidewall', fp: 'Fore, Starboard Sidewall', aa: 'Aft, unprotected', as: 'Aft, Port Sidewall', ap: 'Aft, Starboard Sidewall'}
		else
			translation = {tw: 'Top Wedge', bw: 'Bottom Wedge', st: 'Starboard Broadside', pt: 'Port Broadside', fr: 'Fore, unprotected', fs: 'Fore, Starboard Sidewall', fp: 'Fore, Port Sidewall', aa: 'Aft, Unprotected', as: 'Aft, Starboard Sidewall', ap: 'Aft, Port Sidewall'}
		end
		orb = find_orb(front, top)
		return translation[orb[unwrap(target)]]
	end

	def validate_bearing(bearing, lines=false)
		bluegreen = ['a','ab','b','bc','c','cd','d','de','e','ef','f','fa']
		orange = ['a','b','c','d','e','f']
		purple = ['']
		letters, symbols = split_bearing(bearing)
		case symbols
		when '+','-'
			if bluegreen.include?(letters) then true else false end
		when '++','--'
			if lines
				if bluegreen.include?(letters) then true else false end
			else
				if orange.include?(letters) then true else false end
			end
		when '+++', '---'
			if purple.include?(letters) then true else false end
		when ''
			if bluegreen.include?(letters) then true else false end
		else
			false
		end
	end

end
