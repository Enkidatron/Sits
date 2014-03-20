module BearingsHelper
	include NavigationHelper

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

	def roll_and_validate_ship(front,top)
		new_front, new_top,_ ,_ = rotate_bearings(front,top,nil)
		validate_ship(new_front,new_top)
	end

	def validate_ship(front, top)
		orange = [:'+++',:'bc++',:'bc+',:'bc',:'bc-',:'bc--',:'---',:'ef--',:'ef-',:'ef',:'ef+',:'ef++']
		orange_offset = [:'+++',:'c++',:'c+',:'c',:'c-',:'c--',:'---',:'f--',:'f-',:'f',:'f+',:'f++']
		blue = [:'d++',:'c++',:'bc+',:'bc',:'bc-',:'b--',:'a--',:'f--',:'ef-',:'ef',:'ef+',:'e++']
		blue_offset = [:'de++',:'cd++',:'c+',:'c',:'c-',:'bc--',:'ab--',:'fa--',:'f-',:'f',:'f+',:'ef++']
		green = [:'d+',:'cd+',:'c+',:'bc',:'b-',:'ab-',:'a-',:'fa-',:'f-',:'ef',:'e+',:'de+']
		purple = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		top_rings = {:'a' => orange, :'ab' => orange_offset, :'a+' => blue, :'ab+' => blue_offset, :'a++' => green, :'+++' => purple}
		ring = top_rings[front]
		if ring.include?(top) then true else false end
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

	def rotate_bearings(front, top, targets)
		bluegreen = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		invert = false
		if front.to_s[-1] == '-' then 
			front = invert_bearing(front)
			top = invert_bearing(top)
			targets = targets.map { |t| invert_bearing(t)} unless targets.nil?
			invert = true
		end
		front_letters, front_symbols = split_bearing(front)
		case front_symbols
		when :'+++',:'---'

		when :'++',:'--',:'+',:'-',:''
			offset = bluegreen.index(front_letters)
			front = spin_bearing(front,offset)
			top = spin_bearing(top,offset)
			targets = targets.map { |t| spin_bearing(t,offset)} unless targets.nil?
		end
		return front, top, targets, invert
	end

	def find_starboard(front,top)
		orange = [:'+++',:'bc++',:'bc+',:'bc',:'bc-',:'bc--',:'---',:'ef--',:'ef-',:'ef',:'ef+',:'ef++']
		orange_offset = [:'+++',:'c++',:'c+',:'c',:'c-',:'c--',:'---',:'f--',:'f-',:'f',:'f+',:'f++']
		blue = [:'d++',:'c++',:'bc+',:'bc',:'bc-',:'b--',:'a--',:'f--',:'ef-',:'ef',:'ef+',:'e++']
		blue_offset = [:'de++',:'cd++',:'c+',:'c',:'c-',:'bc--',:'ab--',:'fa--',:'f-',:'f',:'f+',:'ef++']
		green = [:'d+',:'cd+',:'c+',:'bc',:'b-',:'ab-',:'a-',:'fa-',:'f-',:'ef',:'e+',:'de+']
		purple = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		orangeblue = [:'a',:'ab',:'b',:'bc',:'c',:'cd',:'d',:'de',:'e',:'ef',:'f',:'fa']
		letters,symbols = split_bearing(front)
		offset = orangeblue.index(letters)
		offset ||= 0
		fix = letters.length == 2 ? 2 : 0
		new_front,new_top,_,invert = rotate_bearings(front,top,nil)
		top_rings = {:'a' => orange, :'ab' => orange_offset, :'a+' => blue, :'ab+' => blue_offset, :'a++' => green, :'+++' => purple}
		ring = top_rings[new_front]
		new_starboard = ring[ring.index(new_top)-9]
		starboard = spin_bearing(new_starboard,12-offset+fix)
		if invert
			starboard = invert_bearing(starboard)
		end
		return starboard
	end

	def evaluate(front,top,target)
		starboard = find_starboard(front,top)
		aft = invert_bearing(front)
		bottom = invert_bearing(top)
		port = invert_bearing(starboard)
		distances = [[front,:fr],[aft,:af],[top,:tp],[bottom,:bt],[starboard,:st],[port,:pt]].map{|bearing,label| [label,get_window_distance(bearing,target)]}
		distances = distances.sort do |a,b|
			unless a[1] == b[1]
				a[1] <=> b[1]
			else
				priority = [:fr,:af,:st,:pt,:tp,:bt]
				priority.index(a[0]) <=> priority.index(b[0])
			end
		end
		tie = distances[1][1] == distances[2][1]
		case distances[0][0]
		when :st
			answer = "Starboard Broadside"
		when :pt
			answer = "Port Broadside"
		when :tp
			answer = "Top Wedge"
			case distances[1][0]
			when :fr
				answer += ", leak to Fore"
			when :af
				answer += ", leak to Aft"
			when :pt
				answer += ", leak to Port"
			when :st
				answer += ", leak to Starboard"
			end
		when :bt
			answer = "Bottom Wedge"
			case distances[1][0]
			when :fr
				answer += ", leak to Fore"
			when :af
				answer += ", leak to Aft"
			when :pt
				answer += ", leak to Port"
			when :st
				answer += ", leak to Starboard"
			end
		when :fr
			answer = "Fore"
			if distances[0][1]==0
				answer += ", Unprotected"
			else
				case distances[1][0]
				when :tp,:bt
					answer += ", Unprotected"
				when :pt
					answer += ", Port Sidewall"
				when :st
					answer += ", Starboard Sidewall"
				end
			end
		when :af
			if distances[0][1]==0
				answer = "Aft, Unprotected"
			else
				case distances[1][0]
				when :tp
					answer = "Top Wedge, leak to Aft"
				when :bt
					answer = "Bottom Wedge, leak to Aft"
				when :pt
					if tie
						case distances[2][0]
						when :tp
							answer = "Top Wedge, leak to Aft, Port Sidewall"
						when :bt
							answer = "Bottom Wedge, leak to Aft, Port Sidewall"
						end
					else
						anwer = "Aft, Port Sidewall"
					end
				when :st
					if tie
						case distances[2][0]
						when :tp
							answer = "Top Wedge, leak to Aft, Starboard Sidewall"
						when :bt
							answer = "Bottom Wedge, leak to Aft, Starboard Sidewall"
						end
					else
						anwer = "Aft, Starboard Sidewall"
					end
				end
			end
		end
		return answer
	end

	def validate_bearing(bearing, lines=false)
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
