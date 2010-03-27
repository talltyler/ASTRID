TODO Notes
Simple Example
Advanced Example
Full Testing Suite
Generaters

Notes on presentation of ASTRID.

Show them don't tell them
How to make a simple application.


Separation of powers
	Most projects are developed by groups of people with different skills, rather than everything needing to be managed in ActionScript ASTRID enables people with different skill set to all have there place to work. 

Data
	ActiveRecord
	Associations
	Common data format adapters
	Utility methods

View types
Web standards 
	HTML and CSS are all supported in ActionScript, just badly. ASTRID enables an experience closer to what someone might expect from these technologies. We are still working with a subset but we are about about 75% feature complete instead of less than 5 with the built in stuff. 

Routes 
	How routes work
	What they are good for, tracking, seo, deeplinking

A new programming language 
	How this came about, (for loop tag)
	What it can work with (delimiters, different files that it scans)
	What it can do (specifics of the language)

Putting it all together what do we have
	flexible, scalable, standards based development
	it include a growing testing sweet, dev environments for each IDE
	Looking into ways of auto generat




Goal:
I want a standardized way to develop applications within any IDE. Be able to compile these apps for any environment and deploy them every runtime. The projects source has to be clean and simple but have tool that help me out with not needing writing the same code over and over for every project. The code base has to compile to a reasonable size and the run efficiently.  

Problems with alternatives:
	Flex compiles to large and runs to slow, because of this any framework that depends on the Flex code base is out. 

	PureMVC structures are an abstraction of an abstraction, applications that are built in it have to pass objects around so many times to get anything done that projects compile much large because of all the code duplication that is purely for structure sake. Other frameworks like RobotLegs are simply improvements on the same questionable ideas. 

	Gaia has to be compiled in the Flash IDE and forces sections of your site to be contained in different swfs, this mean that if you want to use a tween engine in two sections you have to compile this library in both swfs potentially exponentially expanding the size of your project every time you add a page.
	
	There are other options out there but these seem to be the most used options, none of them seem to fit the description I described above. 	

Taking it a few steps further	
	Enabling multitiered architecture
		DataBase
		Server side logic
		Client side HTML/CSS
		Client side ActionScript
		User and search engine accessibility to content
		
		
How do we give all layers within a project exposure to the APIs that they need access to?
How do we destroy the notion of flash files being black boxes?
How do we create content quickly and stably in a easily understandable format?		


ActiveRecord models with full find commands
Pagination classes for management of data sets
Before and after tasks for validation and other data manipulation and management

Routes based controller mapping
SWFAddress deeplinking

multiple renderer types, text, multiple HTML/CSS renderers and examples of custom renderers for games
flash.text.engine Text support within HTML
video and audio tags
all display objects created within HTMLRenderer are pooled for proformance 
style and graphics classes that simplify the drawing API

Asset management classes for uploading, downloading, and caching.
Logging class with connection to DeMonsterDebugger, FireBug, JavaScript, and standard flash tracing.
Testing suite based on ASUnit, looking into porting Cucumber to ActionScript
Plugin manager for when you need to load external swfs into your application.
built in application preloaders


