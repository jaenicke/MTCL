Multithreaded Component Library for Delphi
==========================================

MTCL is a library started to provide an easy way to build multithreaded visual applications.

It is started with code used internally by ADDIPOS GmbH in the hope that with the help of
other developers a greater library will emerge than if we continued on our own.

We needed not much so far, so at the moment there is only the dialog class itself and 
basic wrappers for a button, an edit and a memo.

To help reaching this goal the library is licensed under he MPL, so it can be used in any
commercial or freeware application without the need to publish the code of the application 
as well. Only changes and additions to this library have to be published.

Supported versions of Delphi
----------------------------
I recommend using Delphi 2010 or higher, because only with generics you do not need to cast
everywhere. And it is faster because TDictionary is used instead of simply searching in a
list for a control. Delphi 2009 does not work, because generics were not powerful enough there.

But the code works with Delphi 7 and later.

If you want to use a version prior to Delphi 7, you will need to rename all units to remove 
the dot and you will have to work around the missing MakeObjectInstance. And perhaps even more.

Todo
----
I'd like to add (partially done):
- ~~dynamic creation of the controls at runtime as alternative to the usage of resource~~
- ~~at least positioning and~~ a few other basic properties ~~like Font~~
- after this a few new controls ~~as a progressbar~~
- extended properties like pause state for the progressbar

You would like to contribute?
-----------------------------
You can send your commits as pull requests. This is the easiest way for you since I'll do
the merging if neccessary.

Contact
-------
This library was published by Sebastian Jänicke. I worked for ADDIPOS GmbH as a developer. 
During this time I got the permission to publish the source code as open source.

You can contact me as user jaenicke at http://www.delphipraxis.net/ or under:
jaenicke.github@outlook.com

Feel free to write, if you have any comments, feedback or the like.