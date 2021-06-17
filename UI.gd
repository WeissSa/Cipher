extends Control

onready var cipher_text = $TranslationContainer/VBoxContainer/CipherBox
onready var normal_text = $TranslationContainer/VBoxContainer/EnglishBox

var translation = ""
var translate_key = 0
var mono_key = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var mono_cipher = {}
var modes = ["sub", "mono"]
var mode = modes[0]

func _ready():
	normal_text.text = ""
	cipher_text.text = ""
	modify_cipher()
	$TranslationContainer.show()
	$DecodeContainer.hide()

func _on_CypherOptions_item_selected(index):
	mode = modes[index]
	match mode:
		"sub":
			$TranslationContainer/CenterContainer/VBoxContainer2/mono_key_container.hide()
			$TranslationContainer/CenterContainer/VBoxContainer2/Sub_key_container.show()
		"mono":
			$TranslationContainer/CenterContainer/VBoxContainer2/mono_key_container.show()
			$TranslationContainer/CenterContainer/VBoxContainer2/Sub_key_container.hide()
	

func _on_EnglishBox_text_changed():
	translation = ""
	if mode == "sub":
		encode(normal_text.text)
	elif mode == "mono":
		translate_key = 1
		mono_encode(normal_text.text)
	update_boxes(true)


func _on_CipherBox_text_changed():
	translation = ""
	if mode == "sub":
		decode(cipher_text.text)
	elif mode == "mono":
		translate_key = -1
		mono_decode(cipher_text.text)
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
		

func encode(message):
	translate_key = abs(translate_key)
	translate(message, translate_key)
	

func decode(message):
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
	if mode == "sub":
		for i in range (len(new_text)): #checks to make sure int is input
			if not (ord(new_text[i]) < 58 and ord(new_text[i]) > 47):
				$TranslationContainer/CenterContainer/VBoxContainer2/Sub_key_container/CenterContainer2/KeyEdit.clear()
			else:
				translate_key = int($TranslationContainer/CenterContainer/VBoxContainer2/Sub_key_container/CenterContainer2/KeyEdit.text)
				if translate_key > 26:
					translate_key = 26
					$TranslationContainer/CenterContainer/VBoxContainer2/Sub_key_container/CenterContainer2/KeyEdit.text = "26"
	elif mode == "mono":
		mono_key = new_text.to_upper()
		modify_cipher()



func _on_ModeButton_item_selected(index):
	match index:
		0:
			$TranslationContainer.show()
			$DecodeContainer.hide()
		1:
			$TranslationContainer.hide()
			$DecodeContainer.show()

#code for monoalphabetic is below

func mono_encode(message):
	message = message.to_upper()
	for letter in message:
		if ord(letter) >= ord("A") and ord(letter) <= ord("Z"):
			translation += mono_cipher[letter]
		else:
			translation += letter
		
func mono_decode(message):
	message = message.to_upper()
	var keys = mono_cipher.keys()
	var values = mono_cipher.values()
	for letter in message:
		if ord(letter) >= ord("A") and ord(letter) <= ord("Z"):
			var index = values.find(letter)
			translation += keys[index]
		else:
			translation += letter

func modify_cipher():
	mono_cipher = {}
	var num = ord("A")
	for letter in mono_key:
		mono_cipher[char(num)] = letter
		num += 1
	print (mono_cipher)

#code for the decoder is below

var translated_list = ""

func _on_CipherInput_text_changed():
	$DecodeContainer/VBoxContainer2/CipherOutput.text = ""
	translated_list = ""
	for i in range (26):
		translation = ""
		var decode_key = i
		translate($DecodeContainer/VBoxContainer/CipherInput.text, decode_key)
		translated_list += "Key " + str(26-i) + ": " + translation + "\n"
	$DecodeContainer/VBoxContainer2/CipherOutput.text = "Translations by key: \n"
	for j in translated_list:
		$DecodeContainer/VBoxContainer2/CipherOutput.text += j
		

