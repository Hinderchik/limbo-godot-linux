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
		"C:\\Users\\user> del /F /Q C:\\*",
		"",
		"Access denied - C:\\Windows\\System32",
		"Access denied - C:\\Program Files",
		"Deleting C:\\Users\\user\\Documents...",
		"Deleting C:\\Users\\user\\Downloads...",
		"Deleting C:\\Users\\user\\Desktop...",
		"",
		"[ERROR] Critical system files corrupted!",
		"[ERROR] Security breach detected!",
		"[WARNING] Your IP has been logged: 127.0.0.1",
		"",
		"System integrity check: FAILED",
		"",
		"[CRITICAL] Windows registry corrupted",
		"[CRITICAL] Boot sector damaged",
		"[CRITICAL] Master Boot Record overwritten",
		"",
		"Scanning for recoverable files...",
		"[FAIL] 0 files recovered",
		"[FAIL] 1337 sectors corrupted",
		"",
		"########################################",
		"#                                      #",
		"#         SYSTEM FAILURE IMMINENT      #",
		"#                                      #",
		"########################################",
		"",
		"Press any key to continue..."
	]

func _start_typing():
	current_line = 0
	char_index = 0
	_type_next_character()

func _type_next_character():
	if current_line >= lines.size():
		# После окончания терминала показываем синий экран
		_show_bsod()
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
		await get_tree().create_timer(0.1).timeout
		_type_next_character()

func _show_bsod():
	# Очищаем экран и показываем синий экран
	text_display.clear()
	text_display.bbcode_enabled = true
	text_display.text = "[center][color=white][font_size=48]:( [/font_size][/color][/center]\n\n"
	text_display.text += "[center][color=white][font_size=32]Your PC ran into a problem[/font_size][/color][/center]\n\n"
	text_display.text += "[center][color=white]Windows NT Kernel Panic[/color][/center]\n\n"
	text_display.text += "[color=white]Error: SYSTEM_SERVICE_EXCEPTION[/color]\n"
	text_display.text += "[color=white]What failed: win32k.sys[/color]\n\n"
	text_display.text += "[color=white]Dumping physical memory to disk: 100%%[/color]\n\n"
	text_display.text += "[color=white]Contact your system administrator.[/color]\n\n"
	text_display.text += "[center][color=white]Press ESC to restart[/color][/center]"
	
	# Меняем фон на синий
	modulate = Color(0, 0, 1, 1)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()