__module_name__ = "xstream" 
__module_version__ = "0.3" 
__module_description__ = "Livestreamer bridge for He/xChat 2 written in Python" 

import xchat
import platform

quality = "best"
defaultserver = "twitch.tv"
stopcommands = ["forcestop","kill"]

def main(word, word_eol, userdata):
	channel = xchat.get_info("channel")[1:]
	if xchat.get_info("server") == "tmi.twitch.tv":
		server = "twitch.tv"
	else:
		server = defaultserver
	if len(word) == 1:
		connect(channel,quality,server)
	elif len(word) == 2:
		if word[1] == "stop":
			xchat.command("execkill")
		elif any(word[1] == stopcmd for stopcmd in stopcommands):
			if platform.system() == "Windows":
				xchat.command("exec taskkill /im livestreamer.exe /f")
			elif platform.system() == "Linux":
				xchat.command("exec pkill livestreamer")
			else:
				print "Sorry, I don't recognize your operating system"
		else:
			connect(word[1],quality,server)
	elif len(word) == 3:
		connect(word[1],word[2],server)
	elif len(word) == 4:
		connect(word[1],word[2],word[3])
	else:
		print "Usage: /xstream (<channel>) (<quality>) (<server>)"
	return xchat.EAT_ALL

def connect(channel,quality,server):
	xchat.command("exec livestreamer --loglevel info {0}/{1} {2}".format(server,channel,quality))

#def xstreamHelp()
	
def unload_xstream(userdata):
	print __module_name__, "unloaded"
	
xchat.hook_unload(unload_xstream)
xchat.hook_command("xstream", main, help="Usage: /xstream (<channel>) (<quality>) (<server>)")
xchat.hook_command("livestreamer", main, help="Usage: /livestreamer (<channel>) (<quality>) (<server>)")

print __module_name__, __module_version__, "loaded"
