extends Sprite2D


func _on_player_on_player_damage_taken(damage_taken: int, attack_type: EnemyAttack.EnemyAttackType) -> void:
	if damage_taken > 0:
		$AnimationPlayer.play("PlayerHurt")
