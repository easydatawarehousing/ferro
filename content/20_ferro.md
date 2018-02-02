---
lang:     EN
page:     ferro
title:    Ferro
subtitle: Opal-Ferro gem
---

__How does it work?__  
Ferro uses an object oriented programming style. You instantiate an object, that object
in turn instantiates more child objects and add these as instance variables to itself.
And so on, producing a hierarchy of object instances.
This is called the Ruby Object Model (ROM).

When an object is instanciated in the ROM, Ferro will add an element to the webbrowsers
Document Object Model (DOM). The ROM keeps a reference to every DOM element.
This erradicates the need for element lookups (jquery $ searches).
If you need an element you know where to find it in the ROM.
Getter methods are automatically added by Ferro for easy access to instance variables.

Each object in the ROM inherits from a Ferro class.
Which Ferro class you use determines what type of DOM element will be created.
All Ferro classes inherit from one base class: FerroElement.
For most DOM elements in the html specs there is a corresponding Ferro class.
For instance if you need a html5 \<header\> element you would create a class that inherits
from FerroElementHeader.  
Other html elements have a more abstract counterpart.
All text elements (\<p\>, \<h1\> .. \<h6\>) have one Ferro class: FerroElementText.
The size of the text element is an option when you instantiate the object.

Maybe it sounds difficult but it is quity easy to get the hang of,
as I hope the examples in this website will prove.
Besides, the source code of the Ferro library is so compact that it will take no more
than 30 minutes to read.

__What are some typical use cases?__  
Ferro is primarily meant for applications that heavily rely on front-end code.
Single-page apps and (progressive) web apps are prime use cases.

__What are the advantages?__  

- Only Ruby and CSS needed
- Easy naming conventions: CSS classnames match Ruby classnames
- Easy naming conventions: every DOM element has same ID as the corresponding Ruby object.
  Useful when attaching javascript libraries to elements
- Never lookup an element in the DOM. Ferro keeps a handle to each and every element
  which you can access from Ruby, object oriented style
- It is fast, browser javascript engines are highly optimized.
  The developer can control when to render components, only render what is needed
  when the application loads
- More secure: it is easy to embed scripts into html. As long as you stay away from
  using the innerHtml method, XSS attacks should be impossible
- Easy integration into serverside frameworks like Rails
- Ruby == Programmer happyness,  
  Javascript === confusion

__What are some disadvantages__  
Every solution to a problem has its pro\'s and con\'s.
Ferro is no exception.
Here are some of Ferro\'s disadvantages

- SEO results may suffer if the webcrawler only looks at html. Not really an issue
  when creating a webapp
- Separate content for screenreaders and javascript disabled browsers is needed
- Coding errors may disable (parts of) the webapp. A good set of (integration)tests
  is useful
- Somewhat higher browser memory usage to store the ROM
- No support for older browsers

__Is Ferro finished?__  
No, Ferro is not yet feature complete.
Most of the basic DOM components are done.
Navigation and routing are handled.
AJAX calls are wrapped.

Areas that need work are:

- Adding a service worker to catch all networktraffic when the browser is offline
- Adding support for storing and retrieving data (Object Relational Manager)
- A nice ActionCable / websockets client
- A markdown parser (that does not produce html but directly adds elements to the DOM)
- Localization (I18n)
- Many more ready made components, for instance a table component with sorting,
  filtering, etcetera. Preferably in separate gems
- Capture touch events and gestures
- Proper documentation and testset
- A utility to convert html to ferro code might be useful

__What we don\'t need when using Ferro__  

- HTML
- Javascript DOM finders (like jQuery, Zepto, \.\.\.)
- Javascript libraries/frameworks that extend html (like Ember, Angular, JSX, Vue, Stimulus)
- Shadow DOM Javascript frameworks (like React)

Enough with the introduction to Ferro. Let\'s look at some examples.