
def hex_to_base64(hex_str)
	hex = ("0".."9").to_a + ("a".."f").to_a
	decimal_num = 0
	hex_str.split('').reverse.each_with_index do |char, index|
		decimal_num += hex.index(char) * 16 ** index
	end
	base64 = ("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a + ["+","/"]
	backward_base64 = ""
	until decimal_num == 0
		last_digit = decimal_num % 64
		backward_base64 << base64[last_digit]
		decimal_num = decimal_num / 64
	end
	backward_base64.reverse
end

str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
puts hex_to_base64(str)
