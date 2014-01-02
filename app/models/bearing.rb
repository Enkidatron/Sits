class Bearing
	include BearingsHelper
	extend ActiveModel::Naming
	attr_reader :front, :top, :targets #, :math_front, :math_top, :math_targets, :invert
	# serialize :targets, Array

	def initialize(front,top,targets)
		if validate_bearing(front) then	@front = front else @front = nil end
		if validate_bearing(top, lines = true) then @top = top else @top = nil end
		@targets = targets.split(',').map { |t| if validate_bearing(t.strip) then t.strip else '' end }
		@targets.reject! { |t| t.empty? }
		@math_front, @math_top, @math_targets, @invert = rotate_bearings(@front,@top,@targets) unless is_invalid?
	end

	def is_ship_valid?
		return validate_ship(@math_front, @math_top)
	end

	def is_invalid?
		return (front.nil? or top.nil?)
	end

	def has_targets?
		if targets.nil? then return false end
		return targets.length > 0
	end

	def evaluate_target(target)
		return evaluate_aspect(@math_front,@math_top,@math_targets[targets.index(target)],@invert)
	end

end