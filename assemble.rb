require_relative "versioning"
require 'yaml'


class ColourAssembler
	attr_reader :colours
	attr_reader :version
	
	def initialize(variable_prefix: "$", colour_prefix: "color-", colour_postfix: "", comment_prefix: "/* ", comment_newline_prefix: " * ", comment_postfix: " */", output_file: "_vars.sass")
		@colours = {}

		@variable_prefix = variable_prefix
		@colour_prefix = colour_prefix
		@colour_postfix = colour_postfix
		@comment_prefix = comment_prefix
		@comment_newline_prefix = comment_newline_prefix
		@comment_postfix = comment_postfix
		@output_file = output_file
		
	end
	
	def get_colour_group_info_from_file(f_relative_path)
		puts "Reading #{f_relative_path}.yml..."
		fcontents = File.read("./#{f_relative_path}.yml")
		raw_obj = YAML.load(fcontents)
		
		if Versioning.check_version(raw_obj["version"])
			raise "Error! Version mismatch, current #{@version} but found #{raw_obj["version"]} in ./#{f_relative_path}.yml."
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
		puts "Writing stylesheet..."
		file = File.join(File.dirname(__FILE__), @output_file)
		File.open(file, 'w') { |f| 
			write_header(f)
			
			@colours.each do |key,group|
				write_group(f, key, group)
			end
		}
		puts "Finished writing stylesheet!"
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
		sep(fo)
		
		puts "Written header."
	end
	
	def write_group(fo, group_name, group)
		group_header = <<~EOS
		#{@comment_prefix}
		#{@comment_newline_prefix} Group name: #{group_name}
		#{@comment_newline_prefix} #{auto_pluralise(group["swatches"].keys.length, "variable")} generated.
		#{@comment_postfix}
		EOS
		fo.puts group_header
		group["swatches"].each do |k, v|
			var_assembled = "#{@variable_prefix}#{@colour_prefix}#{group_name}-#{k}: #{group["decoration"][0]}#{v}#{group["decoration"][1]}#{@colour_postfix}\n"
			fo.puts var_assembled
		end
		sep(fo)
		
		puts "Written group `#{group_name}`."
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
	
	def sep(fo)
		fo.puts @comment_prefix+("*"*(80-@comment_prefix.length-@comment_postfix.length))+@comment_postfix
		fo.puts "\n\n\n"
	end
end
