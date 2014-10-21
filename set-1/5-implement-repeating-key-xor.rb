require_relative '4-detect-single-character-xor'

str1 = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
str1 = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
str2 = "I go crazy when I hear a cymbal"
key = "ICE"

def repeat_key_xor(str,key)
	xor_str = ""
	str.each_char.with_index do |letter,index|
		xor_num = letter.ord ^ key[index % key.length].ord
		xor_hex = xor_num.to_s(16)
		xor_hex.length == 1 ? xor_str << '0' + xor_hex : xor_str << xor_hex
	end
	xor_str
end

puts repeat_key_xor(str1, key)
puts repeat_key_xor(str2, key)
