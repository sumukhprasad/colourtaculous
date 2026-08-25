require 'yaml'


class ColourAssembler
	attr_reader :colours
	attr_reader :version
	
	def initialize
		@colours = {}
		@version = "0.0.1"
	end
	
	def get_colour_group_info_from_file(f_relative_path)
		puts "Reading defs/#{f_relative_path}.yml..."
		fcontents = File.read("./defs/#{f_relative_path}.yml")
		raw_obj = YAML.load(fcontents)
		
		if raw_obj["version"] != @version
			raise "Error! Version mismatch, current #{@version} but found #{raw_obj["version"]} in defs/#{f_relative_path}.yml."
		end
	
		puts "Read `#{raw_obj["name"]}`, with #{raw_obj["swatches"].keys.length} entries."
		
		colour_group_obj = {
			raw_obj["name"] => {
				"decoration" => [raw_obj["prefix"], raw_obj["postfix"]],
				"swatches" => raw_obj["swatches"]
			}
		}
	
		@colours.merge!(colour_group_obj)
		
		puts "Added group."
	end
end


assembler = ColourAssembler.new

assembler.get_colour_group_info_from_file("claret")
puts assembler.colours