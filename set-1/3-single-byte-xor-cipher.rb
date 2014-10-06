require_relative '2-fixed-xor'

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
	puts translations
	translations.map{|str| count_letters(str)}
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
