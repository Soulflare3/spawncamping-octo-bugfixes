__module_name__ = "xstream" 
__module_version__ = "0.1" 
__module_description__ = "Livestreamer bridge for He/xChat 2 written in Python" 

import xchat
import os

def main(word, word_eol, userdata):
	if len(word) == 2:
		os.system("start \"xstream\" cmd /c livestreamer twitch.tv/%s best" % word[1]) #Quick fix
	else:
		print "Usage: /xstream <channel>"	
	#if xchat.get_list
	return xchat.EAT_ALL

def unload_xstream(userdata):
	print __module_name__, "unloaded"
	
xchat.hook_unload(unload_xstream)
xchat.hook_command("xstream", main, help="Usage: /xstream <channel>")
xchat.hook_command("livestreamer", main, help="Usage: /livestreamer <channel>")

print __module_name__, __module_version__, "loaded"
