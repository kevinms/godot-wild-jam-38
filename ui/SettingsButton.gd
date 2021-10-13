extends Node2D

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_SettingsButton_pressed():
	$SettingsPanel.toggle()
