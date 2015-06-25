import xchat
import platform

__module_name__ = "xstream"
__module_version__ = "0.3dev"
__module_description__ = "Livestreamer bridge for He/xChat 2 written in Python"

quality = "best"
defaultserver = "twitch.tv"
stopcommands = ["forcestop", "kill"]

# TODO: Capture and store names and process IDs of livestreamer for each stream launched
# May have to pull some OS. or platform. functions to get it to work in Win/Lin
#
# TODO: Maybe have platform.system() check run onload and save to a variable to save system calls?
#
# TODO: Add selector functions to list proper command name instead of just /xstreamer every time

def main(word, word_eol, userdata):
	channel = xchat.get_info("channel")[1:]
	if xchat.get_info("server") == "tmi.twitch.tv":
		server = "twitch.tv"
	else:
		server = defaultserver
	if len(word) == 1:
		connect(channel, quality, server)
	elif word[1] == "raw" and len(word) >= 3:
		xchat.command("exec livestreamer {0}".format(word_eol[2]))
	elif word[1] == "help" and len(word) >= 2:
			xstreamHelp(word, word_eol)
	elif any(word[1] == stopcmd for stopcmd in stopcommands) and len(word) == 2:
		if platform.system() == "Windows":
			xchat.command("exec taskkill /im livestreamer.exe /f")
		elif platform.system() == "Linux":
			xchat.command("exec pkill livestreamer")
		else:
			print("Sorry, I don't recognize your operating system")
	elif len(word) == 2:
		if word[1] == "stop":
			xchat.command("execkill")
		elif word[1] == "raw":
			print("syntax: /xstream raw <command>")
		else:
				connect(word[1], quality, server)
	elif len(word) == 3:
		connect(word[1], word[2], server)
	elif len(word) == 4:
		connect(word[1], word[2], word[3])
	else:
		print("Usage: /xstream (<channel>) (<quality>) (<server>)")
	return xchat.EAT_ALL

def connect(channel, quality, server):
	xchat.command("exec livestreamer --loglevel info {0}/{1} {2}".format(server, channel, quality))

def xstreamHelp(word, word_eol):
	moreInfoLines = []
	mySyntax = ""
	if len(word) == 2 and word[1] == "help":
		print("Usage: /xstream help <command>")
	elif word[2] == "raw":
		mySyntax = "<command>"
	elif word[2] == "stop":
		pass
	elif any(word[2] == stopcmd for stopcmd in stopcommands):
		mySyntax = " "
		moreInfoLines = ["Terminates all livestreamer processes"]
	if len(mySyntax) > 0:
		haveTopic = True
	else:
		haveTopic = False
	if len(moreInfoLines) > 0:
		haveMoreInfo = True
	else:
		haveMoreInfo = False
	if haveTopic:
		print("Usage: /xstream {0} {1}".format(word[2], mySyntax))
	if haveMoreInfo:
		for nextLine in moreInfoLines:
			print("{0}".format(nextLine))
	if not haveTopic and len(word) >= 3:
		print("Sorry, I don't have any help topics for {0}".format(word_eol[2]))
	return xchat.EAT_ALL

def unload_xstream(userdata):
	print("{0} unloaded".format(__module_name__))

xchat.hook_unload(unload_xstream)
xchat.hook_command("xstream", main, help="Usage: /xstream (<channel>) (<quality>) (<server>)")
xchat.hook_command("livestreamer", main, help="Usage: /livestreamer (<channel>) (<quality>) (<server>)")

print("{0} {1} loaded".format(__module_name__, __module_version__))
