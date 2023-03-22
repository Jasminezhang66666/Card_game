lerp_speed = 0.3;

score_enemy = 0;
score_player = 0;

ene = 0;
ply = 0;

shuffle_time = 60;
enemy_decision_finished = false;
scoring_time = 90;
player_selected = false;

if (!instance_exists(obj_rock)) {
	for (var n = 0; n < 8; n++) {
		instance_create_layer(130,642,"cards",obj_rock);
	}
	for (var n = 0; n < 8; n++) {
		instance_create_layer(130,642,"cards",obj_paper);
	}
	for (var n = 0; n < 8; n++) {
		instance_create_layer(130,642,"cards",obj_scissor);
	}
}