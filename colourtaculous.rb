#!/usr/bin/env ruby

require_relative "assemble"
require 'yaml'
require 'optparse'

puts "Colourtaculous! (version 0.0.1)"


options = {:input => "colourtaculous.yml"}
OptionParser.new do |opts|
	opts.banner = <<~EOS
	Usage: colourtaculous [options]
	EOS
	
	opts.on('-i', '--input INPUTFILE', 'YAML file with colourtaculous spec (default: colourtaculous.yml).') { |v| options[:input] = v }
end.parse!


puts "Using input file: #{options[:input]}."

if !File.file?(options[:input])
	abort("Input file `#{options[:input]}` not available!")
end

config_contents = File.read("#{options[:input]}")
config_obj = YAML.load(config_contents)

puts "Input files:"
puts config_obj["inputfiles"]


colourtaculous_assembler = ColourAssembler.new(output_file: config_obj["outputfile"])

puts "---"
config_obj["inputfiles"].each do |group_name|
	colourtaculous_assembler.get_colour_group_info_from_file(group_name)
end
puts "---"


puts "Writing output to #{config_obj["outputfile"]}..."
colourtaculous_assembler.generate_stylesheet
puts "Finished writing stylesheet."



puts "---"
puts "Bye!"