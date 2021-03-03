extends Control

onready var cipher_text = $TranslationContainer/VBoxContainer/CipherBox
onready var normal_text = $TranslationContainer/VBoxContainer/EnglishBox

var translation = ""
var translate_key = 0

func _ready():
	normal_text.text = ""
	cipher_text.text = ""
	$TranslationContainer.show()
	$DecodeContainer.hide()

	

func _on_EnglishBox_text_changed():
	decode(normal_text.text)
	update_boxes(true)


func _on_CipherBox_text_changed():
	encode(cipher_text.text)
	update_boxes(false)

func update_boxes(if_english):
	if translate_key > 0:
		cipher_text.text = translation
	elif translate_key < 0:
		normal_text.text = translation
	else:
		if if_english:
			cipher_text.text = normal_text.text
		else:
			normal_text.text = cipher_text.text
		

func decode(message):
	translation = ""
	translate_key = abs(translate_key)
	translate(message, translate_key)
	

func encode(message):
	translation = ""
	translate_key = abs(translate_key) * -1
	translate(message, translate_key)

func translate(message, key):
	for letter in message:
		if (ord(letter) >= ord("A") and ord(letter) <= ord("Z")) or (ord(letter) <= ord("z") and ord(letter) >= ord("a")):#checks to make sure it is a letter
			var num = ord(letter)
			num += key
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
			$TranslationContainer/CenterContainer/VBoxContainer2/HBoxContainer/CenterContainer2/KeyEdit.clear()
		else:
			translate_key = int($TranslationContainer/CenterContainer/VBoxContainer2/HBoxContainer/CenterContainer2/KeyEdit.text)
			if translate_key > 26:
				translate_key = 26
				$TranslationContainer/CenterContainer/VBoxContainer2/HBoxContainer/CenterContainer2/KeyEdit.text = "26"



func _on_ModeButton_item_selected(index):
	match index:
		0:
			$TranslationContainer.show()
			$DecodeContainer.hide()
		1:
			$TranslationContainer.hide()
			$DecodeContainer.show()

#code for the decoder is below

var translated_list = ""

func _on_CipherInput_text_changed():
	$DecodeContainer/VBoxContainer2/CipherOutput.text = ""
	for i in range (26):
		translation = ""
		var decode_key = i
		translate($DecodeContainer/VBoxContainer/CipherInput.text, decode_key)
		translated_list += "Key " + str(i) + ": " + translation + "\n"
	$DecodeContainer/VBoxContainer2/CipherOutput.text = "Translations by key: \n"
	for j in translated_list:
		$DecodeContainer/VBoxContainer2/CipherOutput.text += j
		
