class Bearing
	include BearingsHelper
	extend ActiveModel::Naming
	attr_reader :front, :top, :targets #, :math_front, :math_top, :math_targets, :invert
	# serialize :targets, Array

	def initialize(front,top,targets)
		if validate_bearing(front.strip.downcase) then	@front = front.strip.downcase.intern else @front = nil end
		if validate_bearing(top.strip.downcase, lines = true) then @top = top.strip.downcase.intern else @top = nil end
		@targets = targets.downcase.split(',').map { |t| if validate_bearing(t.strip) then t.strip.downcase.intern else '' end }
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
		@evaluated ||= {}
		unless @evaluated.include?(target)
			# @evaluated[target] = evaluate_aspect(@math_front,@math_top,@math_targets[targets.index(target)],@invert)
			@evaluated[target] = evaluate(front,top,target)
		end
		return @evaluated[target]
	end

end