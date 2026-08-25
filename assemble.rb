require 'yaml'


class ColourAssembler
	attr_reader :colours
	attr_reader :version
	
	def initialize(variable_prefix: "$", colour_prefix: "color-", colour_postfix: "", comment_prefix: "/* ", comment_newline_prefix: " * ", comment_postfix: " */", output_file: "_vars.sass")
		@colours = {}
		@version = "0.0.1"

		@variable_prefix = variable_prefix
		@colour_prefix = colour_prefix
		@colour_postfix = colour_postfix
		@comment_prefix = comment_prefix
		@comment_newline_prefix = comment_newline_prefix
		@comment_postfix = comment_postfix
		@output_file = output_file
		
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
	
	def generate_stylesheet
		file = File.join(File.dirname(__FILE__), @output_file)
		File.open(file, 'w') { |f| 
			write_header(f)
		}
	end
	
	
	private
	def write_header(fo)
		header = <<~EOS
		#{@comment_prefix}
		#{@comment_newline_prefix} Colourtaculous!
		#{@comment_newline_prefix} (version #{@version})
		#{@comment_newline_prefix}
		#{@comment_newline_prefix} Colour palatte generated from #{auto_pluralise(@colours.keys.length, "group")}.
		#{@comment_postfix}
		EOS
		fo.puts header
	end
	
	def auto_pluralise(n, singular, plural=nil)
		if n == 1
			"1 #{singular}"
		elsif plural
			"#{n} #{plural}"
		else
			"#{n} #{singular}s"
		end
	end
end


assembler = ColourAssembler.new

assembler.get_colour_group_info_from_file("claret")
assembler.generate_stylesheet
