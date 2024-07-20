extends Button

# Out of the nature of the game, we do not do any saving or similar
# Hence not notifications, that is using 
#	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
# is made which might be used to delay the quitting while also saving information to the FileSystem
func _on_pressed():
	get_tree().quit(0)
