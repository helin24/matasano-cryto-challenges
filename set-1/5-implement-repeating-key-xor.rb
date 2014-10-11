require_relative '4-detect-single-character-xor'

str1 = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
str2 = "I go crazy when I hear a cymbal"
key = "ICE"

def repeat_key_xor(string, key)
	str_dec = []
	string.each_char do |c|
		str_dec << c.ord
	end
	key_dec = []
	key.each_char do |c|
		key_dec << c.ord
	end
	xor_dec = []
	str_dec.each.with_index do |c, i|
		xor_dec << ( c ^ key_dec[i % key.length] )
	end
	puts xor_dec.inspect
	xor_hex = xor_dec.map do |num|
		decimal_to_hex(num)
	end
	xor_hex.join('')
	xor_dec.join('').to_i.to_s(16)
#	str_bin = str_to_bin_arr(string)
#	key_bin = str_to_bin_arr(key)
#	puts "string is #{str_bin} and key is #{key_bin}"
#	xor_bin = [] 
#	str_bin.each.with_index do |bin, index|
#		xor_bin << combine_bin(bin, key_bin[index % key.length])
#	end
#	puts "xor is #{xor_bin}"
#	convert_to_hex(xor_bin.join(''))
end

def str_to_bin_arr(string)
	bin_arr = []
	string.each_char do |c|
		bin_arr << c.ord.to_s(2)
	end
	bin_arr
end

puts repeat_key_xor(str1, key).inspect
puts repeat_key_xor(str2, key).inspect
