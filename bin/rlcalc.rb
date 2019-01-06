#!/usr/bin/env ruby

clargs = ARGV.map { |arg|
	arg.to_f
}.sort

rollod = clargs[2].to_f
coreod = clargs[1].to_f
thickness = clargs[0].to_f

exit(1) if rollod.zero? || coreod.zero? || thickness.zero?

def roller(c, r, t)
	od = c
	circ  = 0
	begin
		circ += Math::PI * od
		od += 2 * t
	end while od <= r
	return circ
end

inches = roller(coreod, rollod, thickness)
yards = inches / 36

printf "%.2f %s\n", yards, "YARDS"
