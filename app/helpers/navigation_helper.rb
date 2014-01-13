module NavigationHelper

	def bearing_to_angle(bearing)
		azimuth = {''=>0,'a'=>0,'ab'=>30,'b'=>60,'bc'=>90,'c'=>120,'cd'=>150,'d'=>180,'de'=>210,'e'=>240,'ef'=>270,'f'=>300,'fa'=>330}
		elevation = {''=>0,'+'=>30,'++'=>60,'+++'=>90,'-'=>-30,'--'=>-60,'---'=>-90}
		letters, symbols = split_bearing(bearing)
		puts letters, symbols
		return deg_to_rad(azimuth[letters]), deg_to_rad(elevation[symbols])
	end

	def angles_to_unit_vector(angles)
		x = Math.cos(angles[1]) * Math.cos(angles[0])
		y = Math.cos(angles[1]) * Math.sin(angles[0])
		z = Math.sin(angles[1])
		[x,y,z]
	end

	def dot_product(u,v)
		u[0]*v[0]+u[1]*v[1]+u[2]*v[2]
	end

	def magnitude(v)
		Math.sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2])
	end

	def get_angle(u,v)
		rad_to_deg(Math.acos(dot_product(u,v)/(magnitude(u)*magnitude(v))))
	end

	def rad_to_deg(x)
		((x * 180 / Math::PI) + 360) % 360
	end

	def deg_to_rad(x)
		x * Math::PI / 180
	end

	def get_window_distance(first,second)
		angle_one = bearing_to_angle(first)
		angle_two = bearing_to_angle(second)
		puts angle_one, angle_two
		u = angles_to_unit_vector(angle_one)
		v = angles_to_unit_vector(angle_two)
		puts u,v
		distance = get_angle(u,v)
		puts distance
		case 
		when distance < 15
			return 0
		when distance < 45
			return 1
		when distance < 75
			return 2
		when distance < 105
			return 3
		when distance < 135
			return 4
		when distance < 165
			return 5
		else
			return 6
		end
	end
end
