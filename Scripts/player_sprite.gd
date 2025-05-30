extends AnimatedSprite2D

func _on_player_on_player_damage_taken(damage_taken: int, attack_type: EnemyAttack.EnemyAttackType) -> void:
	if damage_taken > 0:
		$AnimationPlayer.play("PlayerHurt")
		frame = 1
		await get_tree().create_timer(0.5).timeout
		frame = 0
