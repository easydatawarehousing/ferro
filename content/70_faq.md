---
lang:     EN
page:     faq
title:    F.A.Q.
subtitle: 
---

__What does Ferro stand for?__  
Front End Ruby ROcks

__Are we ready to ditch Html completely?__  
Let\'s first examine the purpose of html.
A webbrowser keeps an internal memory structure of a webpage, usually referred to as the
Document Object Model (DOM). The webbrowser knows how to display this DOM
in combination with styling rules defined in style sheets (CSS).

Html is one way of describing the desired memory state of the webbrowsers DOM.
Originally html was just meant to describe content and markup (styling).
Later focus shifted towards describing structure (semantics) and content.  
Html is a very flexible and forgiving language, so technically this is not a problem.
But as web developers we need to combine structure, content and styling cues into one document.
That is why we split up the creation of html over separate
files (views). Ideally one view for every structural element of the webpage,
header, menu, footer, sidebars, article, etcetera.

There is an alternative approach to describing the webbrowsers desired DOM state.
The DOM can be manipulated programatically via Javascipt.
This is what front-end frameworks like angular and react do.
These frameworks modify the DOM state directly.
Strangely they often contain some html. In order to modify this html at run-time
they have found a way to make html even more complex than it already is.
This modified html is passed on to the webbrowser to let that add it to the DOM.

Ferro does not use any html for modifying the DOM state.
You just define a desired memory state in Ruby,
called the Master Object Model (MOM), which modifies the DOM for you.

For the non-structural parts of an application, i.e. the (textual) content,
a language that describes content and its markup is still very useful.
This is what html was originally intended for and is a valid option
for transferring content from the webserver to the front-end.

However alternatives are available.
Specifically _markdown_, which has gained a lot of traction in recent years
but is sadly not an internet standard yet. In an ideal world webbrowsers
would have an API to parse markdown.

The content for the page you are reading now was written in markdown
and converted into pre-rendered html.
As soon as Ferro contains its own markdown parser this conversion will
no longer be necessary. Ferro will then parse markdown and manipulate
the DOM accordingly.

__MVC?__  
Using Ferro means that there is little separation between logic (controller)
and display (view).
Ferro is best suited for a component based coding style.
This is not uncommon in front-end frameworks (React, Vue).
A component describes a small self contained part of a webapplication,
like a menu, a search box or a footer.
A lot of components together define the whole webapplication.

So as long as MVC is short for Model-ViewComponent you can use MVC.

__File size__  
Total size (Html+JS+CSS+AJAX) for a full application should be similar to
a traditional application.  
All javascript for this website, including Opal, minified and gzipped is 89Kb.  
Compare that to jQuery: 73Kb, Ember: 111Kb, Angular: 111Kb, React: 35Kb.

__This is a static Ruby-on-Rails website, how is that even possible?__  
In the development environment this is a normal Rails application.
When setting the environment to production a task is available that
builds all the necessary files (html header, js, css, json) and puts these
in the appropriate folders. The AJAX calls that your browser makes just
read static json files.

__Navigating the Master Object Model__  
There are two ways to navigate around the MOM: upward and downward.
Every object in the MOM knows its parent. If an event is received by an
object like a button, the parent of that object usually can handle the
event.  
Searching upward further than one parent quickly becomes difficult to
follow. So you can always search downward starting from the top.
Every object in the MOM can access the root object.
From the root you can access all MOM objects.  
There is a shortcut to find an object starting from the nearest element
in the hierarchy that is a component. All semantical elements
(like header and section) are components. All objects that are children
of a component have immediate access to that component.

__Where are the markup html elements?__  
I can\'t find Ferro elements corresponding with: \<b\> \<i\> \<u\> etcetera!

That is correct, Ferro only knows about structural (semantic, inline, form, etc)
DOM elements.
Ferro does have a class for \'Text\' elements, but nothing for styling its content.
See discussion above about html.

__Why is there no support for older webbrowsers ?__  
This website is a technical demo of the ferro library and gives some
background information about how it works. The intended target audience of
this website are webdevelopers. I didn't invest a lot of time
in browser compatibility since webdevelopers tend to use modern browsers.
Edge 15 is excluded because it doesn't fully support CSS grid.