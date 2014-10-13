KEYSIZE = (1..40).to_a

def chunk_difference(file, key_byte_size)
	base_64_lines = open_file(file)
	base_64_file = base_64_lines.join('')
	bin_file = str_base64_to_bin_str(base_64_file)
	puts bin_file
	first_chunk = bin_file[0..(key_byte_size * 8 - 1)]
	second_chunk = bin_file[(key_byte_size * 8)..(key_byte_size * 8 * 2 -1)]
	[first_chunk, second_chunk] 
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
