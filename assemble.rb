require 'yaml'


class ColourAssembler
	def initialize(args)
		
	end
	
	
end

def get_colorinfo_from_file(fname)
	puts "Reading defs/"+fname+".yml..."
	fcontents = File.read("./defs/"+fname+".yml")
	obj = YAML.load(fcontents)
	
	puts "Read `#{obj["name"]}`, with #{obj["swatches"].keys.length} entries."
	
	puts obj.inspect
	
	return obj
end


get_colorinfo_from_file("claret")