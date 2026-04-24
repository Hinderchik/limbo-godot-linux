extends Control

@onready var text_display = $Panel/CenterContainer/TerminalPanel/MarginContainer/RichTextLabel
@onready var reboot_timer = $Timer

var lines = []
var current_line = 0
var char_index = 0
var typing_timer = null

func _ready():
	visible = false
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
		"[ERROR] Critical system files corrupted!",
		"\x1b[31m[ERROR] Security breach detected!\x1b[0m",
		"",
		"System integrity check: \x1b[31mFAILED\x1b[0m",
		"Forcing reboot in 5 seconds...",
		"",
		"Broadcast message from root@linux (pts/0):",
		"",
		"\x1b[31m>>> The system will reboot NOW! <<<\x1b[0m"
	]

func _start_typing():
	current_line = 0
	char_index = 0
	_type_next_character()

func _type_next_character():
	if current_line >= lines.size():
		reboot_timer.start(5)
		reboot_timer.timeout.connect(_on_reboot_timer_timeout)
		return
		
	var line = lines[current_line]
	if char_index < line.length():
		# Обработка escape-последовательностей ANSI для цвета
		if line[char_index] == '\x1b':
			# Пропускаем ANSI коды, но сохраняем их в текст
			while char_index < line.length() and line[char_index] != 'm':
				text_display.text += line[char_index]
				char_index += 1
			if char_index < line.length():
				text_display.text += line[char_index]
				char_index += 1
		else:
			text_display.text += line[char_index]
			char_index += 1
		
		await get_tree().create_timer(0.03).timeout
		_type_next_character()
	else:
		text_display.text += "\n"
		current_line += 1
		char_index = 0
		await get_tree().create_timer(0.2).timeout
		_type_next_character()

func _on_reboot_timer_timeout():
	reboot_timer.timeout.disconnect(_on_reboot_timer_timeout)
	_reboot_system()

func _reboot_system():
	var os_name = OS.get_name()
	match os_name:
		"Linux":
			# Реальная перезагрузка (требует прав)
			var output = []
			var exit_code = OS.execute("shutdown", ["-r", "now"], output, true)
			if exit_code != 0:
				# Если не получилось, имитируем
				OS.alert("System would reboot now (shutdown command failed)\nExit code: " + str(exit_code), "Fake Terminal")
				get_tree().quit()
		"Windows":
			OS.alert("System would reboot now (simulated)", "Fake Terminal")
			get_tree().quit()
		_:
			OS.alert("System would reboot now (simulated)", "Fake Terminal")
			get_tree().quit()

func show_terminal():
	visible = true
	$AudioStreamPlayer.play()  # Если есть звук

func hide_terminal():
	visible = false