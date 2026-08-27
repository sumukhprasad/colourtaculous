module Versioning
	VERSION_MAJOR = 0
	VERSION_MINOR = 0
	VERSION_BUGFIX = 1
	
	def self.current_version
		return self.assemble_semantic_version
	end
	
	def self.check_version(v)
		return self.assemble_semantic_version == v
	end
	
	private
	def self.assemble_semantic_version
		return "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_BUGFIX}"
	end
end