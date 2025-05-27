extends Node2D
class_name DefenseVisualsManager

var junk_in_queue = 0

func update_shield_visuals(new_shield : int):
	$UIElements/ShieldMeter/ShieldLabel.text = str(new_shield)
	if  new_shield == 0:
		$UIElements/ShieldMeter/ShieldBackgroundMask/ShieldBackground.set_modulate(Color(0.5,0.5,0.5))
		$UIElements/ShieldMeter/ShieldFrame.set_modulate(Color(0.5,0.5,0.5))
	else:
		$UIElements/ShieldMeter/ShieldBackgroundMask/ShieldBackground.set_modulate(Color(1,1,1))
		$UIElements/ShieldMeter/ShieldFrame.set_modulate(Color(1,1,1))

func update_counter_visuals(new_counter : int):
	$UIElements/CounterMeter/CounterLabel.text = str(new_counter)
	if new_counter == 0:
		$UIElements/CounterMeter/CounterBackgroundMask/CounterBackground.set_modulate(Color(0.5,0.5,0.5))
		$UIElements/CounterMeter/CounterFrame.set_modulate(Color(0.5,0.5,0.5))
	else:
		$UIElements/CounterMeter/CounterBackgroundMask/CounterBackground.set_modulate(Color(1,1,1))
		$UIElements/CounterMeter/CounterFrame.set_modulate(Color(1,1,1))

func add_junk_in_queue(junk_amount: int, attack_type : EnemyAttack.EnemyAttackType ):
	junk_in_queue = junk_in_queue + junk_amount
	if junk_in_queue > 0:
		$UIElements/JunkIndicator.show()
		$UIElements/JunkIndicator/JunkText.text = "x %s" % (junk_in_queue)

func remove_junk_in_queue(junk_amount : int):
	junk_in_queue -= junk_amount
	if junk_in_queue <= 0:
		$UIElements/JunkIndicator.hide()
		junk_in_queue = 0
	else:
		$UIElements/JunkIndicator/JunkText.text = "x %s" % (junk_in_queue)
