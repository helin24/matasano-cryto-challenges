require_relative '3-single-byte-xor-cipher'

KEYSIZE = (1..40).to_a

def break_repeating_key_xor(file)
	bin_str = file_base_64_to_bin_str(file)
	keysize_differences = keysize_differences(file, KEYSIZE)
	key_size = find_key_size(keysize_differences) # gets most likely key size
	blocks = bin_to_blocks(bin_str, key_size)
	transposed_blocks = blocks.transpose # includes some nil elements for padding
	guess_key = ""
	transposed_blocks.each do |block|
		english_scores = histogram(block)
		puts "the lowest score for this block is #{english_scores.min_by{|k,v| v}}"
		lowest_pair = english_scores.min_by{|_k,v| v}
		guess_key << lowest_pair[0].to_i(2).chr	
	end	
	puts guess_key.inspect
	puts guess_key.length
	puts guess_key.split('').inspect
	key_arr = guess_key.split('').map{|char| char.ord.to_s(2)}
	decrypted_bin = xor_bin_arr_bin_key_arr(blocks.flatten, key_arr)
	translated = decrypted_bin.map{|bin| bin.to_i(2).chr }
end

def xor_bin_arr_bin_key_arr(bin_arr, bin_key_arr)
	xor_bin = []
	bin_arr.each.with_index do |bin, i|
		xor_bin << combine_bin(bin, bin_key_arr[i % bin_key_arr.length]) if bin != nil 
	end
	xor_bin
end 

def histogram(bin_block)
	xor_strings = {}	
	bin_alphabet.each do |bin_letter|
		xor_bin = xor_bin_array_bin_char(bin_block, bin_letter)
		xor_strings.merge!({bin_letter => bin_arr_to_ascii_str(xor_bin)}) 
	end
	english_scores = {}
	xor_strings.each_pair do |bin_letter, xor_string|
		english_scores.merge!({bin_letter => english_score(xor_string)})
	end
	english_scores 		
	# take array of all binary strings that should be xor'd against a specific letter
	# xor each binary string against all of the ascii bin representations
	# for each ascii representation, find the resulting array of characters after xor
	# for each ascii representation, find english score of the string of characters
end

def xor_bin_array_bin_char(bin_array, bin_char)
	xor_bin = []
	bin_array.each do |bin|
		xor_bin << combine_bin(bin, bin_char) if bin != nil
	end
	xor_bin
end

def bin_arr_to_ascii_str(bin_arr)
	str = ""
	bin_arr.each do |bin|
		str << bin.to_i(2).chr
	end
	str
end

def bin_to_blocks(bin_str, key_size)
	bytes = []
	bin_arr = bin_str.split('')
	until bin_arr.length == 0 do 
		bytes << bin_arr.shift(8).join('')
	end
	blocks = []
	while bytes.length >= key_size do 
		blocks << bytes.shift(key_size)
	end
	(key_size - bytes.length % key_size).times { bytes << nil } if bytes.length > 0
	blocks << bytes
	blocks	
end

def keysize_differences(file, keysizes)
	bin_str = file_base_64_to_bin_str(file)
	keysize_hamming_differences = []
	keysizes.each do |size|
		abs_diff = chunk_difference(bin_str, size)
		keysize_hamming_differences << normalize_hamming(abs_diff, size) 
	end
	keysize_hamming_differences
end

def find_key_size(keysize_differences)
	min_diff = keysize_differences.min
	KEYSIZE[keysize_differences.index(min_diff)]
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

def bin_alphabet
	alphabet = (0..255).to_a
	alphabet.map! { |num| num.chr.unpack('B*').join('')}
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
