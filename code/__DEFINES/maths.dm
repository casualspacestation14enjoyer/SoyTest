// Credits to Nickr5 for the useful procs I've taken from his library resource.
// This file is quadruple wrapped for your pleasure
// (

#define NUM_E 2.71828183

#define SQRT_2 1.414214

#define PI 3.1416
#define INFINITY 1e31	//closer then enough

#define SHORT_REAL_LIMIT 16777216

//"fancy" math for calculating time in ms from tick_usage percentage and the length of ticks
//percent_of_tick_used * (ticklag * 100(to convert to ms)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_lag
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_lag)
#define TICK_USAGE_TO_MS(starting_tickusage) (TICK_DELTA_TO_MS(TICK_USAGE_REAL - starting_tickusage))

#define PERCENT(val) (round((val)*100, 0.1))
#define CLAMP01(x) (clamp(x, 0, 1))

//time of day but automatically adjusts to the server going into the next day within the same round.
//for when you need a reliable time number that doesn't depend on byond time.
#define REALTIMEOFDAY (world.timeofday + (MIDNIGHT_ROLLOVER * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK (GLOB.rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : GLOB.midnight_rollovers)

#define SIGN(x) ((x)!=0 ? (x) / abs(x) : 0)

#define CEILING(x, y) (-round(-(x) / (y)) * (y))

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR(x, y) (round((x) / (y)) * (y))

// Similar to clamp but the bottom rolls around to the top and vice versa. min is inclusive, max is exclusive
#define WRAP(val, min, max) clamp((min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min)))),min,max)

// Real modulus that handles decimals
#define MODULUS(x, y) ((x) - (y) * round((x) / (y)))

// Cotangent
#define COT(x) (1 / tan(x))

// Secant
#define SEC(x) (1 / cos(x))

// Cosecant
#define CSC(x) (1 / sin(x))

#define ATAN2(x, y) (!(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))))

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, (a) % (b)) : a

// Least Common Multiple
#define Lcm(a, b) (abs(a) / Gcd(a, b) * abs(b))

#define INVERSE(x) (1/(x))

// Used for calculating the radioactive strength falloff
#define INVERSE_SQUARE(initial_strength,cur_distance,initial_distance) ((initial_strength)*((initial_distance)**2/(cur_distance)**2))

#define ISABOUTEQUAL(a, b, deviation) (deviation ? abs((a) - (b)) <= deviation : abs((a) - (b)) <= 0.1)

#define ISEVEN(x) (x % 2 == 0)

#define ISODD(x) (x % 2 != 0)

// Returns true if val is from min to max, inclusive.
#define ISINRANGE(val, min, max) (min <= val && val <= max)

// Same as above, exclusive.
#define ISINRANGE_EX(val, min, max) (min < val && val < max)

#define ISINTEGER(x) (round(x) == x)

#define ISMULTIPLE(x, y) ((x) % (y) == 0)

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
#define LERP(a, b, amount) (amount ? ((a) + ((b) - (a)) * (amount)) : a)

// Returns the nth root of x.
#define ROOT(n, x) ((x) ** (1 / (n)))

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d		= b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0)
		return
	var/root = sqrt(d)
	. += (-b + root) / bottom
	if(!d)
		return
	. += (-b - root) / bottom

#define TODEGREES(radians) ((radians) * 57.2957795)

#define TORADIANS(degrees) ((degrees) * 0.0174532925)

/// Gets shift x that would be required the bitflag (1<<x)
#define TOBITSHIFT(bit) (log(2, bit))

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS((degrees), 360))

#define GET_ANGLE_OF_INCIDENCE(face, input) (MODULUS((face) - (input), 360))

//Finds the shortest angle that angle A has to change to get to angle B. Aka, whether to move clock or counterclockwise.
/proc/closer_angle_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DEGREES(a)
	b = SIMPLIFY_DEGREES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec? -dec : inc

//A logarithm that converts an integer to a number scaled between 0 and 1.
//Currently, this is used for hydroponics-produce sprite transforming, but could be useful for other transform functions.
#define TRANSFORM_USING_VARIABLE(input, max) (sin((90*(input))/(max))**2)

//converts a uniform distributed random number into a normal distributed one
//since this method produces two random numbers, one is saved for subsequent calls
//(making the cost negligble for every second call)
//This will return +/- decimals, situated about mean with standard deviation stddev
//68% chance that the number is within 1stddev
//95% chance that the number is within 2stddev
//98% chance that the number is within 3stddev...etc
#define ACCURACY 10000
/proc/gaussian(mean, stddev)
	var/static/gaussian_next
	var/R1;var/R2;var/working
	if(gaussian_next != null)
		R1 = gaussian_next
		gaussian_next = null
	else
		do
			R1 = rand(-ACCURACY,ACCURACY)/ACCURACY
			R2 = rand(-ACCURACY,ACCURACY)/ACCURACY
			working = R1*R1 + R2*R2
		while(working >= 1 || working==0)
		working = sqrt(-2 * log(working) / working)
		R1 *= working
		gaussian_next = R2 * working
	return (mean + stddev * R1)
#undef ACCURACY

/proc/get_turf_in_angle(angle, turf/starting, increments)
	var/pixel_x = 0
	var/pixel_y = 0
	for(var/i in 1 to increments)
		pixel_x += sin(angle)+16*sin(angle)*2
		pixel_y += cos(angle)+16*cos(angle)*2
	var/new_x = starting.x
	var/new_y = starting.y
	while(pixel_x > 16)
		pixel_x -= 32
		new_x++
	while(pixel_x < -16)
		pixel_x += 32
		new_x--
	while(pixel_y > 16)
		pixel_y -= 32
		new_y++
	while(pixel_y < -16)
		pixel_y += 32
		new_y--
	new_x = clamp(new_x, 0, world.maxx)
	new_y = clamp(new_y, 0, world.maxy)
	return locate(new_x, new_y, starting.z)

// Returns a list where [1] is all x values and [2] is all y values that overlap between the given pair of rectangles
/proc/get_overlap(x1, y1, x2, y2, x3, y3, x4, y4)
	var/list/region_x1 = list()
	var/list/region_y1 = list()
	var/list/region_x2 = list()
	var/list/region_y2 = list()

	// These loops create loops filled with x/y values that the boundaries inhabit
	// ex: list(5, 6, 7, 8, 9)
	for(var/i in min(x1, x2) to max(x1, x2))
		region_x1["[i]"] = TRUE
	for(var/i in min(y1, y2) to max(y1, y2))
		region_y1["[i]"] = TRUE
	for(var/i in min(x3, x4) to max(x3, x4))
		region_x2["[i]"] = TRUE
	for(var/i in min(y3, y4) to max(y3, y4))
		region_y2["[i]"] = TRUE

	return list(region_x1 & region_x2, region_y1 & region_y2)

#define EXP_DISTRIBUTION(desired_mean) (-(1/(1/desired_mean)) * log(rand(1, 1000) * 0.001))

#define LORENTZ_DISTRIBUTION(x, s) (s*tan(TODEGREES(PI*(rand()-0.5))) + x)
#define LORENTZ_CUMULATIVE_DISTRIBUTION(x, y, s) ((1/PI)*TORADIANS(arctan((x-y)/s)) + 1/2)

#define RULE_OF_THREE(a, b, x) ((a*x)/b)
// )

/// Taxicab distance--gets you the **actual** time it takes to get from one turf to another due to how we calculate diagonal movement
#define MANHATTAN_DISTANCE(a, b) (abs(a.x - b.x) + abs(a.y - b.y))
// )

/// A function that exponentially approaches a maximum value of L
/// k is the rate at which is approaches L, x_0 is the point where the function = 0
#define LOGISTIC_FUNCTION(L,k,x,x_0) (L/(1+(NUM_E**(-k*(x-x_0)))))

// )
/// Make sure something is a boolean TRUE/FALSE 1/0 value, since things like bitfield & bitflag doesn't always give 1s and 0s.
#define FORCE_BOOLEAN(x) ((x)? TRUE : FALSE)

// )
/// Gives the number of pixels in an orthogonal line of tiles.
#define TILES_TO_PIXELS(tiles) (tiles * PIXELS)
// )

/*
	This proc makes the input taper off above cap. But there's no absolute cutoff.
	Chunks of the input value above cap, are reduced more and more with each successive one and added to the output
	A higher input value always makes a higher output value. but the rate of growth slows
*/
/proc/soft_cap(input, cap = 0, groupsize = 1, groupmult = 0.9)

	//The cap is a ringfenced amount. If we're below that, just return the input
	if (input <= cap)
		return input

	var/output = 0
	var/buffer = 0
	var/power = 1//We increment this after each group, then apply it to the groupmult as a power

	//Ok its above, so the cap is a safe amount, we move that to the output
	input -= cap
	output += cap

	//Now we start moving groups from input to buffer


	while (input > 0)
		buffer = min(input, groupsize)	//We take the groupsize, or all the input has left if its less
		input -= buffer

		buffer *= groupmult**power //This reduces the group by the groupmult to the power of which index we're on.
		//This ensures that each successive group is reduced more than the previous one

		output += buffer
		power++ //Transfer to output, increment power, repeat until the input pile is all used

	return output
