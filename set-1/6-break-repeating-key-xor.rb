KEYSIZE = (1..40).to_a


def keysize_differences(file, keysizes)
	bin_str = file_base_64_to_bin_str(file)
	keysize_hamming_differences = []
	keysizes.each do |size|
		abs_diff = chunk_difference(bin_str, size)
		keysize_hamming_differences << normalize_hamming(abs_diff, size) 
	end
	keysize_hamming_differences
end

def file_base_64_to_bin_str(file)
	base_64_lines = open_file(file)
	base_64_file = base_64_lines.join('')
	bin_str = str_base64_to_bin_str(base_64_file)
end

def chunk_difference(bin_str, key_byte_size)
	first_chunk = bin_str[0..(key_byte_size * 8 - 1)]
	second_chunk = bin_str[(key_byte_size * 8)..(key_byte_size * 8 * 2 -1)]
	puts [first_chunk, second_chunk]
	hamming_distance_bin(first_chunk, second_chunk)
end

def normalize_hamming(value, key_byte_size)
	value.to_f / key_byte_size
end

def base64_alphabet
	('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a << '+' << '/'
end

def str_base64_to_bin_str(str)
	num_extra_bits = str.count('=')
	bin_str = ""
	str = str[0..-(num_extra_bits + 1)]
	p str
	str.each_char do |c|
		bin_str << base64_alphabet.index(c).to_s(2).rjust(6, '0')
	end
	bin_str = bin_str[0..-(num_extra_bits * 2 + 1)]
	bin_str
end

def hamming_distance(str1, str2)
	bin_str1 = str_to_bin_str(str1)
	bin_str2 = str_to_bin_str(str2)
	hamming_distance_bin(bin_str1, bin_str2)
end

def hamming_distance_bin(bin_str1, bin_str2)
	diff = 0
	bin_str1.length.times do |num|
		diff += 1 if bin_str1[num] != bin_str2[num]
	end
	diff
end

def str_to_bin_str(str)
	bin_str = ''
	str.each_char do |c|
		bin_char = c.ord.to_s(2).rjust(8, '0')
		bin_str << bin_char
	end	
	bin_str
end

def open_file(filename) 
	file = []
	File.open(filename, 'r') do |f|
		f.each_line do |line|
			file << line[0..-2] # remove \n
		end
	end
	file
end

str1 = "this is a test"
str2 = "wokka wokka!!!"

# puts hamming_distance(str1, str2)

# NOTES
# keysize is the number of bytes of the key
# for each keysize (of length n) check str1 (0..n) and str1 (n..2n) and see which has lowest difference
