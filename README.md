# Breakpoint
A macro to help with action breakpoint issues in Path of Exile. It works by disabling the OS's built-in key-repeat and using it's own.

# Releases
https://github.com/rogueyoshi/Breakpoint/releases

# Usage
Open settings.ini and do the following":

1. Set "Keys=" to a Comma Separated Values list of the Keys you wish to use.

Example: "Keys=q,w,e" for "Q", "W", and "E".

2. Set "PressDuration=" to a value that allows it to deterministically activate your skill key.

3. Set "WaitDuration=" to value that is around the total milliseconds of your Breakpoint, minus the PressDuration (plus a leeway of about 25ms for server ticks).


Then simply run the script (.exe or .ahk).

NOTE: The values in settings.ini assume a 4APS breakpoint, or 250ms.
