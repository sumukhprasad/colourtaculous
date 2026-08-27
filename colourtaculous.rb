#!/usr/bin/env ruby

require_relative "assemble"
require_relative "versioning"
require 'yaml'
require 'optparse'

puts "Colourtaculous! (version #{Versioning.current_version})"






options = {
	:input => "colourtaculous.yml",
	:variable_prefix => nil,
	:colour_prefix => nil,
	:colour_postfix => nil,
	:comment_prefix => nil,
	:comment_newline_prefix => nil,
	:comment_postfix => nil,
	:output_file => nil
}


OptionParser.new do |opts|
	opts.banner = <<~EOS
		Usage: colourtaculous [options]
		
		Options passed through the input take precedence over ones defined in the input file.
		
		Defaults: 
		variable_prefix: "$"
		colour_prefix: "color-"
		colour_postfix: ""
		comment_prefix: "/* "
		comment_newline_prefix: " * "
		comment_postfix: " */"
		output_file: "_vars.sass"
	EOS
	
	opts.on(
		"-i", "--input INPUTFILE",
		"YAML file with colourtaculous spec (default: colourtaculous.yml)."
	) { |v| options[:input] = v }

	opts.on(
		"--variable-prefix PREFIX",
		"Variable prefix."
	) { |v| options[:variable_prefix] = v }

	opts.on(
		"--colour-prefix PREFIX",
		"Colour prefix."
	) { |v| options[:colour_prefix] = v }

	opts.on(
		"--colour-postfix POSTFIX",
		"Colour postfix."
	) { |v| options[:colour_postfix] = v }

	opts.on(
		"--comment-prefix PREFIX",
		"Comment prefix."
	) { |v| options[:comment_prefix] = v }

	opts.on(
		"--comment-newline-prefix PREFIX",
		"Comment newline prefix."
	) { |v| options[:comment_newline_prefix] = v }

	opts.on(
		"--comment-postfix POSTFIX",
		"Comment postfix."
	) { |v| options[:comment_postfix] = v }

	opts.on(
		"--output-file FILE",
		"Output file."
	) { |v| options[:output_file] = v }
end.parse!


puts "Using input file: #{options[:input]}."
if !File.file?(options[:input])
	abort("Input file `#{options[:input]}` not available!")
end

config_contents = File.read("#{options[:input]}")
config_obj = YAML.load(config_contents)

puts "Input files:"
puts config_obj["inputfiles"]

assembler_options = {
	:variable_prefix => config_obj["variable_prefix"],
	:colour_prefix => config_obj["colour_prefix"],
	:colour_postfix => config_obj["colour_postfix"],
	:comment_prefix => config_obj["comment_prefix"],
	:comment_newline_prefix => config_obj["comment_newline_prefix"],
	:comment_postfix => config_obj["comment_postfix"],
	:output_file => config_obj["output_file"]
}

# command-line arguments override values from yaml
assembler_options.each_key do |key|
	assembler_options[key] = options[key] unless options[key].nil?
end

# remove options that weren't specified anywhere
assembler_options.compact!

colourtaculous_assembler = ColourAssembler.new(**assembler_options)

puts "---"
config_obj["inputfiles"].each do |group_name|
	colourtaculous_assembler.get_colour_group_info_from_file(group_name)
end
puts "---"


puts "Writing output to #{assembler_options[:output_file] || "_vars.sass"}..."
colourtaculous_assembler.generate_stylesheet



puts "---"
puts "Bye!"