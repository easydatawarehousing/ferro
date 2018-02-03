---
lang:     EN
page:     introduction
root:     true
title:    Introduction
subtitle: Simplifying web-development with Ferro
---

Since the dawn of the world wide web, web developers have been writing HTML.
Later to be followed by writing CSS and Javascript.
Next we needed Javascript libraries and frameworks to interact with our HTML.

But no more! It is easily possible to create websites and -applications without using HTML.
This website is living proof of that. Type Ctrl+U to see for yourself.  
Next, we can replace Javascript with Ruby.
Combine Ruby with a small library called Ferro and we can transform web development.
Web developers can focus all their attention to the structure of the code.
No more distractions like HTML, naming elements and searching for elements.
Just beautiful and simple Ruby code.

__An example__  
Imagine a webpage that displays a form with a checkbox and an input field. The input
should only be enabled when the checkbox is checked. This kind of logic is best handled
by the webbrowser, not the webserver. So we would write or generate an HTML page with the
two inputs and some javascript. The javascript runs when the page is loaded, it runs a (jQuery)
selector to find the checkbox and adds an eventlistener to the click event. When the checkbox is
clicked the javascript event-handler function is executed. This runs a selector to find the input
field and modifies its _disabled_ attribute.
Ironically we need some code to look for the elements that we know are there.
We just created them in html!

If we look at this example from a functional perspective we only need two things:
(1) a form with a checkbox and an input and (2) an action that should run when the checkbox value changes.
Wouldn\'t it be nice if we could translate these functional requirements into some Ruby classes
and be done. Well, and this should come as no surprise, we can!

__Opal-Ferro gem__  
Let me introduce the Opal-Ferro gem. [Opal](http://opalrb.com/) is that wonderful piece of kit
that allows us to run Ruby in the webbrowser. [Ferro](https://github.com/easydatawarehousing/opal-ferro)
is a small Ruby library that manages the webbrowsers DOM, erradicates the need for searching
for elements and introduces some handy naming conventions to simplify CSS design.

But most importantly, using Ferro the webdeveloper only needs to think about the structure of the code,
not about all the things that are needed to make the code work in a webbrowser.