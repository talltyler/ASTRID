Objects
===
Objects can take text that has data and logic defined within it and 
evaluate it down to the converted objects value. 

This started with a class that could load a String of data and runtime and be able to 
simple pick out Objects defined within the String of data and replace these String with 
the ActionScript Object value. This idea grew after I needed a way to loop over data
that was loaded from a server. I realized it would be nice to have conditionals and all
of the other parts of a basic logic.

This type of thing is often called a templating language and can be found in many 
server side languages. This language is modeled in a very similar way to things like 
Liquid in Ruby or Smarty in PHP but skips out on a few of the more complicated features 
to make sure that this class doesn't become a beast of a script.

Currently it supports
---
Loops:
---
For in loops, for each in loops are both implemented with limit and offset properties for 
Arrays. You can also use numeric ranges like in Ruby with ... and .. 
example; 3...5 would return and Array with [3,4,5]. The difference between two dots and three
is if you would like to include the last value. 

Conditionals:
---
If statements with if, if else and else all work with the following operators, 
==, !=, <=, and >=. You can also string conditions together with the && and || 
operators. Conditionals don't currently support parenthesis which would allow for even more 
complicated conditionals but this is rairly used. Tell me if you need them. 

Math:
---
Math operations like +, -, /, * and % are all supported. I've left out the binary operators 
but it is easy to add them if you need them.

Variables:
---
Some times you need a variable to store things while looping over objects, simple variable 
assignment can be used just like ActionScript.

Dot syntax:
---
Everything is created with nested objects, just like ActionScript you can drill into any 
deeply nested object. This is notable if you remember tellTarget in AS1

Methods:
---
You can't define new methods but you can call any public function or property contained 
within your data object. Feel free to pass in scope to other methods if you would like
the language to be more powerful.

Think of all of this as a way to mold your loaded text into anything you would 
like in a secure way. It's great for APIs, injecting variables or simplifying CSS and
HTML content. If you come up with other uses I would love to hear about them.

	var source:String = "Hello <% name %>!";
	var data:Object = {name:"Tyler"};
	var objects:Objects = new Objects();
	var result:String = objects.parse( source, data, "<%", "%>" );
	trace( result );

One of the key features of it is that because I don't know what type of text this logic 
might be contained within, so the logic delimiters are variable. For instance a for loop can 
be written like this;

	<% for(prop in item) %>
		<% prop %><% item[prop] %>
	<% end %>


or like this, if you change the delimiters;

	{{ for(prop in item) }}
		{{ prop }}{{ item[prop] }}
	{{ end }}


Here is a larger example:

	<h2>Images</h2>
	<div>
		<% for each(image in images.data) %>
			<div class="image">
				<% image %>
			</div>
		<% end %>
	</div>

	<div id="pages">
		<% if images.prevPage != 1 %>
			<a href="#/game/index/?page=<% images.prevPage %>">Previous</a>
		<% end %>
		<% if images.nextPage != images.currentPage %>
			<a href="#/game/index/?page=<% images.nextPage %>">Next</a>
		<% end %>
	</div>



This gets converted to something like this;

	<h2>Images</h2>
	<div id="images">
		<div class="image">
			<img src="image1.jpg" />
			<img src="image2.jpg" />
			<img src="image3.jpg" />
			<img src="image4.jpg" />
			<img src="image5.jpg" />
			<img src="image6.jpg" />
		</div>
	</div>

	<div id="pages">
		<a href="#/game/index/?page=2">Next</a>
	</div>

