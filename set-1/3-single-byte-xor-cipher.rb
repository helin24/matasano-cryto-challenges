require_relative '2-fixed-xor'

def decode(str)
	possibilities = decode_hex(str)
	closeness = {}
	possibilities.each { |str| closeness[str] = english_score(str) }
	sorted = closeness.sort_by { |_k, value| value }
	puts sorted.inspect
end

def english_score(str)
	common_letters = {
		'a' => 8,
		'e' => 13,
		'i' => 7,
		'o' => 8,
		'u' => 3,
		'h' => 6,
		'n' => 7,
		'r' => 6,
		's' => 6,
		't' => 9,
		'\u0000' => 14
		}
	str_distribution = {}
	str.each_char do |letter|
		puts letter.inspect
		letter = letter.downcase
		if common_letters.keys.include?(letter)
			str_distribution[letter] = str_distribution[letter] ? str_distribution[letter] + 1 : 1
		end
	end
	frequencies = {}
	str_distribution.each {|letter, freq| frequencies[letter] = freq.to_f / str.length * 100}

	puts frequencies.inspect
	closeness = 0
	common_letters.each do |letter, freq|
		str_freq = frequencies[letter] == nil ? 0 : frequencies[letter]
		puts "comparing freq #{freq} with str freq #{str_freq}"
		closeness += (freq - str_freq) ** 2
	end
	closeness 
end

def decode_hex(str)
	bin_str = convert_to_binary_array(str).join('')
	combined_bins = []
	bin_alphabet.each do |letter|
		combined_bins << combine_bin(bin_str, letter * (bin_str.length / 2))
	end
	translations = []
	combined_bins.each do |bin_str|
		translations << bin_to_ascii(bin_str).to_s 
	end
	translations
end

def bin_alphabet
	alphabet = ('a'..'z').to_a
	alphabet.map! { |letter| letter.unpack('B*').join('')}
end

def bin_to_ascii(bin_str)
	bin_arr = bin_str.scan(/.{8}/)
	bin_arr.map!{|bin| bin.to_i(2).chr}.join('')
end

def count_letters(str)
	alphabet = ('a'..'z').to_a
	str.split('').count{|c| alphabet.include?(c.downcase) }
end
