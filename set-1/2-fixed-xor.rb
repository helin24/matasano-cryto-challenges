def xor_combination(hex_str1, hex_str2)
	bin_str1 = convert_to_binary_array(hex_str1).join('')
	bin_str2 = convert_to_binary_array(hex_str2).join('')
	puts "binary string 1 is #{bin_str1} and binary string 2 is #{bin_str2}"
	combined = combine_bin(bin_str1, bin_str2)
	puts "combined binary string is #{combined}"
	new_hex = convert_to_hex(combined)
end

def convert_to_hex(bin_str)
	bin_arr = bin_str.scan(/..../)
	hex_array = []
	bin_arr.each do |bin|
		decimal = 0
		bin.reverse.each_char.with_index {|char, i| decimal += char.to_i * 2 ** i }
		hex_array << decimal_to_hex(decimal)
	end
	hex_array.join('')
end

def convert_to_binary_array(str)
	binary_str = []
	str.split('').each do |char|
		bin = sprintf("%b", hex_to_decimal(char))
		num_zeros = 4 - bin.length
		binary_str << '0' * num_zeros + bin
	end
	binary_str
end

def hex_to_decimal(hex_char)
	hex = ('0'..'9').to_a + ('a'..'f').to_a
	hex.index(hex_char)
end

def decimal_to_hex(num)
	hex = ('0'..'9').to_a + ('a'..'f').to_a
	hex[num]
end

def combine_bin(bin_str1, bin_str2)
	bin_arr1 = bin_str1.split('')
	bin_arr2 = bin_str2.split('')
	combined = []
	bin_arr1.length.times do |index|
		bin_arr1[index] == bin_arr2[index] ? combined << '0' : combined << '1'
	end
	combined.join('')
end
