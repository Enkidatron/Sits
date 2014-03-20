module RaltHelper

	def validate_distance_string(input)
		input =~ /\A([a-f\+-]\d+)+\Z/
	end

	def rad_to_deg(x)
		((x * 180 / Math::PI) + 360) % 360
	end

	def consolidate_vectors(distance)
		direction_pairs = [['a','d'],['b','e'],['c','f'],['+','-']]
		flat_directions = ['a','b','c','d','e','f']
		components = Hash[*distance.scan(/[a-f\+-]|\d+/)]
		components.default = 0
		components.each { |direction,distance| components[direction] = distance.to_i }
		direction_pairs.each do |d|
			smaller = [components[d[0]],components[d[1]]].min
			components[d[0]]-=smaller
			components[d[1]]-=smaller
		end
		flat_directions.each_with_index do |d,index|
			smaller = [components[flat_directions[index-1]],components[flat_directions[(index+1)%flat_directions.length]]].min
			components[flat_directions[index-1]]-=smaller
			components[flat_directions[index]]+=smaller
			components[flat_directions[(index+1)%flat_directions.length]]-=smaller
			# puts "#{d}#{smaller}#{components.inspect}"
		end
		direction_pairs.each do |d|
			smaller = [components[d[0]],components[d[1]]].min
			components[d[0]]-=smaller
			components[d[1]]-=smaller
		end
		components.select! { |k,v| !v.nil? and v>0 }
	end

	def compute_bearing(components)
		components.default = 0
		flat = ['a','b','c','d','e','f']
		flat_components = components.map { |k,v| v if flat.include?(k)}.reject { |v| v.nil? or v==0 }
		flat_distance = flat_components.inject(0, :+)
		up_distance = components['+']+components['-']
		symbol = components.keys.include?('+') ? '+' : '-'
		angle = flat_distance == 0 ? 90 : rad_to_deg(Math.atan(up_distance.to_f/flat_distance.to_f))
		case
		when angle > 75
			symbols = symbol * 3
		when angle > 45
			symbols = symbol * 2
		when angle > 15
			symbols = symbol
		else 
			symbols = ''
		end
		# puts "angle:#{angle} symbols:#{symbols}"
		case symbols
		when '+++','---'
			letters = ''
		when '++','--'
			letters = components.find{|k,v| v == flat_components.max}[0]
			# this does not account for the case where distance in two flat directions are equal
			# the following attempts to, but we will leave it alone for now. 
			# all_letters = components.select{|k,v| v == flat_distance.max}
			# letters = all_letters.length == 1 ? all_letters[0] : "#{all_letters.sort[0]}#{all_letters.sort[1]}"
		when '+','-',''
			if flat_components.max >= flat_components.min * 3 then
				letters = components.find{|k,v| v == flat_components.max}[0]
			else
				both = components.select{|k,v| flat.include?(k)}.map {|k,v| k}
				both.sort!
				letters = "#{both[0]}#{both[1]}"
			end
		end
		return "#{letters}#{symbols}".intern, Math.hypot(flat_distance,up_distance).to_i, components
	end

	def display_distance(components)
		components.default = 0
		directions = ['a','b','c','d','e','f','+','-']
		result = ''
		directions.each do |direction|
			result += "#{direction}#{components[direction]}" if components[direction]>0
		end
		result
	end
	
end
