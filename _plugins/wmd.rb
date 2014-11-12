# make sure this is set to the path where wmd/wmd.php can be found
WW_DIR = '/usr/local/src/workingwiki'

# make sure this is the path to a directory where working files are to
# be created.  It should be in the Jekyll source directory, because working
# files need to be published along with the site's html.
# If set to nil, it will be set to wmd_files/ within the site's base 
# source directory.
WMD_CACHE_DIR = nil

require 'shellwords'

def pipe_text_through( text, command )
	puts command
	open('|'+command, 'w+') do |subprocess|
		subprocess.write( text )
		subprocess.close_write
		return subprocess.read
	end
end

module Jekyll
	class WMDGenerator < Jekyll::Generator
		safe true
		priority :low
		@project_lookup = Hash.new
		@wmdCacheDir = ::WMD_CACHE_DIR
		@sourceDir = nil
		
		def self.record_project( title, value )
			@project_lookup[title] = value
		end

		def self.lookup_project( title )
			@project_lookup[title]
		end

		def self.setSourceDir( dir )
			@sourceDir = dir
		end

		def self.sourceDir
			@sourceDir
		end

		def self.setCacheDir( dir )
			@wmdCacheDir = dir
		end

		def self.cacheDir
			@wmdCacheDir
		end

		def initialize(config)
			config['convert_wmd'] ||= true
		end

		def generate(site)
			@site = site
			if ( WMDGenerator.sourceDir() == nil )
				WMDGenerator.setSourceDir( site.source )
			end
			if ( WMDGenerator.cacheDir() == nil )
				WMDGenerator.setCacheDir( "#{site.source}/wmd_files" )
			end
			FileUtils.rm_f( WMDGenerator.cacheDir() + '/.workingwiki/.wmd.data' )
			site.posts.each do |post|
				if post.name.match(/\.wmd$/)
					convertPost post
				end
			end
			site.pages.each do |page|
				if page.name.match(/\.wmd$/)
					convertPage page
				end
			end
		end

		def convertPost(post)
			post.name.gsub!(/\.wmd$/, '')
			post.slug.gsub!(/\.wmd$/, '')
			post.ext = post.slug.match(/\..*?$/)[0]
			post.slug.gsub!(/\..*?$/, '')
			puts "Calling wmd.php --pre on #{post.slug}"
			project = (page['wmd_project'].nil? ? page['wmd_project'] : page.name)
			WMDGenerator.record_project(post.title, project)
			cacheDir = WMDGenerator.cacheDir()
			# TODO: modification time of post's source file
			post.content = pipe_text_through( post.content, "php #{::WW_DIR}/wmd/wmd.php --pre --title='#{post.title}' --default-project-name=#{project} --cache-dir=#{cacheDir} --data-store=.wmd.data --process-inline-math" )
		end
	
		def convertPage(page)
			# path is apparently modified by changing page.name,
			# so capture it before
			path = WMDGenerator.sourceDir() + '/' + page['path']
			page.name.gsub!(/\.wmd$/, '')
			page.ext = page.basename.match(/\..*?$/)[0]
			page.basename.gsub!(/\..*?$/, '')
			project = (page.data.has_key?('wmd_project') ? page['wmd_project'] : page.basename)
			WMDGenerator.record_project(page['title'], project)
			puts( "mtime for path?" )
			puts( "Path = #{Shellwords.shellescape(path)}" )
			mtime = File.mtime( path )
			puts( "got mtime" )
			prereq_str = (page.data.has_key?('wmd_prerequisite_projects') ? '--prerequisite-projects=' + JSON.generate(page['wmd_prerequisite_projects']).shellescape + ' ': '')
			cacheDir = WMDGenerator.cacheDir()
			puts "Calling wmd.php --pre on '#{page['title']}'"
			page.content = pipe_text_through( page.content, "php #{::WW_DIR}/wmd/wmd.php --pre --title='#{page['title']}' --modification-time=#{mtime.to_i} --default-project-name=#{project} #{prereq_str}--cache-dir=#{cacheDir} --data-store=.wmd.data --process-inline-math" )
		end
	end

	module WMDFilter
		def wmd_postprocess(text)
			if ! text.match(/UNIQ/)
				return text
			end
			title = @context.registers[:page]['title']
			project = WMDGenerator.lookup_project(title)
			puts "Calling wmd.php --post on '#{title}'"
			baseurl = @context.registers[:site].baseurl
			wmdCacheDir = WMDGenerator.cacheDir()
			text = pipe_text_through( text, "php #{::WW_DIR}/wmd/wmd.php --post --title='#{title}' --default-project-name=#{project} --cache-dir=#{wmdCacheDir} --data-store=.wmd.data --project-file-base-url=#{baseurl}/wmd_files" )
			if Dir.exists?( "wmd_files/#{project}" )
				@context.registers[:site].read_directories( "wmd_files/#{project}" )
			end
			return text
		end
	end
end

Liquid::Template.register_filter(Jekyll::WMDFilter)
