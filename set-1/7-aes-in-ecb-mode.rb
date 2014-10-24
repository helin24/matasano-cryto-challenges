require 'openssl'
require_relative 'utilities'

def aes_in_ecb_mode(file, key)
	str_base64 = open_file(file).join('')
	bin_str = base64_str_to_bin_str(str_base64)
	ascii_str = bin_str_to_ascii_str(bin_str)
	cipher = OpenSSL::Cipher.new('AES-128-ECB')
	cipher.key = key
	plain = cipher.update(ascii_str) + cipher.final
end
