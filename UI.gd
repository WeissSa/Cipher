extends Control

onready var cipher_text = $HBoxContainer/VBoxContainer/CipherBox
onready var normal_text = $HBoxContainer/VBoxContainer/EnglishBox

var translation = ""
var key = 0

func _ready():
	normal_text.text = ""
	cipher_text.text = ""

	

func _on_EnglishBox_text_changed():
	decode(normal_text.text)
	update_boxes(true)


func _on_CipherBox_text_changed():
	encode(cipher_text.text)
	update_boxes(false)

func update_boxes(if_english):
	if key > 0:
		cipher_text.text = translation
	elif key < 0:
		normal_text.text = translation
	else:
		if if_english:
			cipher_text.text = normal_text.text
		else:
			normal_text.text = cipher_text.text
		

func decode(message):
	translation = ""
	key = abs(key)
	translate(message)
	

func encode(message):
	translation = ""
	key = abs(key) * -1
	translate(message)

func translate(message):
	for letter in message:
		if (ord(letter) >= ord("A") and ord(letter) <= ord("Z")) or (ord(letter) <= ord("z") and ord(letter) >= ord("a")):#checks to make sure it is a letter
			var num = ord(letter)
			print (str(num))
			num += key
			print(str(num))
			if ord(letter) >= ord("A") and ord(letter) <= ord("Z"):#checks for capital
				if num > ord("Z"):
					num -= 26
				elif num < ord("A"):
					num += 26
			else:#condition for if it is lower case
				if num > ord("z"):
					num -= 26
				elif num < ord("a"):
					num += 26
			translation += char(num)
		else:
			translation += letter
			

func _on_LineEdit_text_changed(new_text):
	for i in range (len(new_text)): #checks to make sure int is input
		if not (ord(new_text[i]) < 58 and ord(new_text[i]) > 47):
			$HBoxContainer/CenterContainer/VBoxContainer2/HBoxContainer/CenterContainer2/KeyEdit.clear()
		else:
			key = int($HBoxContainer/CenterContainer/VBoxContainer2/HBoxContainer/CenterContainer2/KeyEdit.text)
			if key > 26:
				key = 26
				$HBoxContainer/CenterContainer/VBoxContainer2/HBoxContainer/CenterContainer2/KeyEdit.text = "26"

