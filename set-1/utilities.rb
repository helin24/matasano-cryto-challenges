
def open_file(filename) 
	file = []
	File.open(filename, 'r') do |f|
		f.each_line do |line|
			file << line[0..-2] # remove \n
		end
	end
	file
end

def base64_str_to_bin_str(str)
	num_extra_bits = str.count('=')
	bin_str = ""
	str = str[0..-(num_extra_bits + 1)]
	str.each_char do |c|
		bin_str << base64_alphabet.index(c).to_s(2).rjust(6, '0')
	end
	bin_str = bin_str[0..-(num_extra_bits * 2 + 1)]
	bin_str
end

def base64_alphabet
	('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a << '+' << '/'
end

def bin_str_to_ascii_str(bin_str)
	bin_arr = bin_str_to_bin_arr(bin_str)
	bin_arr_to_ascii_str(bin_arr)	
end

def bin_str_to_bin_arr(bin_str)
	bin_arr = []
	bin = bin_str.dup.split('')
	until bin.length == 0 do
		bin_arr << bin.shift(8).join('')
	end
	bin_arr
end


def bin_arr_to_ascii_str(bin_arr)
	str = ""
	bin_arr.each do |bin|
		str << bin.to_i(2).chr
	end
	str
end


