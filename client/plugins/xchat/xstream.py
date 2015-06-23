__module_name__ = "xstream" 
__module_version__ = "0.2" 
__module_description__ = "Livestreamer bridge for He/xChat 2 written in Python" 

import xchat

quality = "best"
server = ""
channel = ""

def main(word, word_eol, userdata):	
	channel = xchat.get_info("channel")[1:]
	if xchat.get_info("server")=="tmi.twitch.tv":
		server = "twitch.tv"
	if len(word) == 1:
		connect(channel,server)
	elif len(word) == 2:
		connect(word[1],server)
	else:
		print "Usage: /xstream <channel>"
	return xchat.EAT_ALL

def connect(channel,server):
	xchat.command("exec livestreamer {0}/{1} {2}".format(server,channel,quality))
	
def unload_xstream(userdata):
	print __module_name__, "unloaded"
	
xchat.hook_unload(unload_xstream)
xchat.hook_command("xstream", main, help="Usage: /xstream <channel>")
xchat.hook_command("livestreamer", main, help="Usage: /livestreamer <channel>")

print __module_name__, __module_version__, "loaded"
