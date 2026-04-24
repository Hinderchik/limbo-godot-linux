extends Control

@onready var text_display = $RichTextLabel

var lines = []
var current_line = 0
var char_index = 0

func _ready():
	text_display.clear()
	_setup_terminal_lines()
	_start_typing()

func _setup_terminal_lines():
	lines = [
		"[user@linux ~]$ sudo rm -rf ./",
		"[sudo] password for user: ********",
		"",
		"rm: cannot remove '.': Permission denied",
		"rm: cannot remove './important_file': Operation not permitted",
		"rm: cannot remove './system': Device or resource busy",
		"",
		"\x1b[31m[FATAL] Kernel panic - not syncing: VFS: Unable to mount root fs\x1b[0m",
		"\x1b[31m[FATAL] CPU: 0 PID: 1 Comm: swapper/0 Not tainted\x1b[0m",
		"",
		"[ERROR] Critical system files corrupted!",
		"[ERROR] Security breach detected!",
		"[WARNING] Unauthorized access attempt logged",
		"[WARNING] Your IP has been recorded",
		"",
		"System integrity check: \x1b[31mFAILED\x1b[0m",
		"",
		"\x1b[31m>>> WARNING: System compromised <<<\x1b[0m",
		"\x1b[31m>>> All your files are being encrypted <<<\x1b[0m",
		"",
		"Scanning /home/user/Documents...",
		"Scanning /home/user/Downloads...",
		"Scanning /home/user/Desktop...",
		"",
		"[OK] 0 files recovered",
		"[FAIL] 1337 files corrupted",
		"",
		"\x1b[31m>>> YOUR SYSTEM IS FUCKED <<<\x1b[0m",
		"",
		"Broadcast message from root@linux (pts/0):",
		"",
		"\x1b[31m>>> The NSA is watching you <<<\x1b[0m",
		"",
		"Press Ctrl+C to exit..."
	]

func _start_typing():
	current_line = 0
	char_index = 0
	_type_next_character()

func _type_next_character():
	if current_line >= lines.size():
		return
		
	var line = lines[current_line]
	if char_index < line.length():
		text_display.text += line[char_index]
		char_index += 1
		await get_tree().create_timer(0.03).timeout
		_type_next_character()
	else:
		text_display.text += "\n"
		current_line += 1
		char_index = 0
		await get_tree().create_timer(0.15).timeout
		_type_next_character()

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_tree().quit()