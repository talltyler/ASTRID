ASTRID
===
It's goal is to make the ActionScript application development process more efficient. Applications built with it can be compiled from Flash Pro, Flash Builder, or strait from the command line. They can run in all runtimes ( web, mobile, and desktop applications ). The framework is filled with tools to help limit duplication of effort by providing a huge utility package. All of this is done while still keeping a reasonable compiled size (~30kb base) and the runs efficiently.
Many of it's ideas are based on the concepts behind the back-end frameworks like Rails and Django. These ideas will be different to anyone that hasn't worked within these types of systems and you will need to learn a few things before you get started. Here are a few of ASTRID's key features.

ActiveRecord based models
---
Active record is a design pattern that defines a relationship between objects where the model is representative of a single row of data. These model objects are then saved internally and are able to be accessed through utility functions to find, show, create, update or delete on individual or groups of data. ASTRID provides adapters for all major data types allowing easy import and export of all kinds of data without writing any logic into your model. To enable logic on before or after the models data has changed ASTRID provides before and after task for validation or any other data manipulation. ASTRID's models also support associations between different model types to build more complex data relationships.

Modern controller logic
---
Every back-end framework I have looked into lately supports a way of dealing with what they normally call routes. Routes are a way of mapping all of the locations that can be navigated to within your application. As far as I know ASTRID is the first public framework to support this functionality. ASTRID also ties in optional SWFAddress support for deep linking and event and page tracking analytics.

View renderers
---
Most developers are used to either having designs done within an interface like Flash Pro or in pure code (ActionScript/MXML). You can use both of these methods in ASTRID but we also provide a new way to visualize your pages. ASTRID has multiple built in rendering engines. The most powerful ones render HTML and CSS like a browser but with access to everything that ActionScript can do. If you don't use them they are not compiled into your project but I suggest trying it out, it is far faster than what you are used to.

Modular design
---
If you don't like one of my libraries I have provided use your own. Everything that I am using can be swapped out for any other standard library of code with little to no changes to the core of the framework. This also means that the libraries that I have included within this framework don't have to be used only within my framework. Four sub-projects have been created from libraries within ASTRID but there are many other utilities or chunks of useful code that any project could make use of.

More info
---
[Documentation](http://motionandcolor.com/projects/ASTRID).