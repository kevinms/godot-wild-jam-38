extends GridContainer

func _process(delta):
	$Distance.text = str(int((Global.distance - Global.playerStartingPosition)/12))+ " ft"
	$Clean.text = str(Global.clean)
