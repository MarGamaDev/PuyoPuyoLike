extends Node2D
class_name DefenseVisualsManager

func update_shield_visuals(new_shield : int):
	$UIElements/ShieldMeter/ShieldLabel.text = str(new_shield)
	if  new_shield == 0:
		$UIElements/ShieldMeter/ShieldIcon.set_modulate(Color(0.5,0.5,0.5))
	else:
		$UIElements/ShieldMeter/ShieldIcon.set_modulate(Color(1,1,1))

func update_counter_visuals(new_counter : int):
	$UIElements/CounterMeter/CounterLabel.text = str(new_counter)
	if new_counter == 0:
		$UIElements/CounterMeter/CounterIcon.set_modulate(Color(0.5,0.5,0.5))
	else:
		$UIElements/CounterMeter/CounterIcon.set_modulate(Color(1,1,1))
