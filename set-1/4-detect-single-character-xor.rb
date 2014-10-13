require_relative '3-single-byte-xor-cipher'

def detect(filename)
	file = open_file(filename)
	possibilities = []
	file.each do |line|
		puts line[0..-2].inspect
		possibilities << decode(line[0..-2])
	end
	scored = {}
	possibilities.each do |line|
		scored.merge!({line => english_score(line)})
	end
	sorted = scored.sort_by{ |_k, value| value }
	answer = sorted[0][0]
end

def open_file(filename)
	file = []
	File.open(filename, 'r') do |f|
		f.each_line do |line|
			file << line
		end
	end
	file
end


