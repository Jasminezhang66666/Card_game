if (phase_shuffle) {
	if (timer == shuffle_time) {	
		audio_play_sound(snd_shuffle,0,false);
		randomise();
		ds_list_shuffle(cards);
		//shuffle the cards and display the card pile on the left
		for (var u = 0; u < ds_list_size(cards); u ++) {
			cards[|u].x = 130;	
			cards[|u].y = 450 + (8*u);
			cards[|u].depth = u;
		}
	} else if (timer <= 0) {
		phase_dealing = true;
		phase_shuffle = false;
		target_position = [400,100];
	}
}

if (phase_dealing) {
	
	cards[|0].x+=(target_position[0]-cards[|0].x)*lerp_speed;
	cards[|0].y+=(target_position[1]-cards[|0].y)*lerp_speed;

	if (abs(cards[|0].x-(target_position[0]))<0.2) {
		audio_play_sound(snd_transfer,0,false);
		
		if (ds_list_size(hand_enemy)<3) {
			ds_list_add(hand_enemy,cards[|0]);
			target_position[0] += 200;
			if (ds_list_size(hand_enemy)==3) {
				//new positions for player's hands
				target_position[1] = 900;
				target_position[0] = 400;
			}
			ds_list_delete(cards,0);	
		} else if (ds_list_size(hand_player)<3) {
			ds_list_add(hand_player,cards[|0]);
			ds_list_delete(cards,0);	
			target_position[0] += 200;
		} 
	}
	
	if (ds_list_size(hand_player) == 3) {
			//player hands visible
			hand_player[|0].back = false;
			hand_player[|1].back = false;
			hand_player[|2].back = false;
			//target positions for enemy:
			target_position[0] = 600;
			target_position[1] = 375;
			ene = irandom_range(0,2); //random card, and will be put into the center
			phase_decision = true;
			phase_dealing = false;
	}
}

if (phase_decision) {
	if (!enemy_decision_finished) {
		hand_enemy[|ene].x+=(target_position[0]-hand_enemy[|ene].x)*lerp_speed;
		hand_enemy[|ene].y+=(target_position[1]-hand_enemy[|ene].y)*lerp_speed;
		
		if (abs(hand_enemy[|ene].y-target_position[1])<0.2) {
			enemy_decision_finished = true;
		}
	}	
	
	//the juicy indication of decision:
	for (var i = 0; i < ds_list_size(hand_player); i++) {
		var c = hand_player[|i];
		if (!player_selected && mouse_x > c.x && mouse_x < (c.x+c.sprite_width) && mouse_y > c.y && mouse_y < (900+c.sprite_height)) {
			c.y = 865;
			if (mouse_check_button_pressed(mb_left)) { //and player selected the card
				ply = i;
				player_selected = true;
				hand_enemy[|ene].back = false;
				audio_play_sound(snd_flip,0,false);
			}
		} else if (!player_selected) {
			c.y = 900;
		}
	}
	
	if (player_selected) {
		hand_player[|ply].x+=(600-hand_player[|ply].x)*lerp_speed;
		hand_player[|ply].y+=(625-hand_player[|ply].y)*lerp_speed;
	}
	
	if (abs(hand_player[|ply].y-625)<0.2 && enemy_decision_finished) {
		phase_scoring = true;
		phase_decision = false;
		timer = scoring_time;
		player_selected = false;
		enemy_decision_finished = false;
	}
}

if (phase_scoring) {
	if (timer == scoring_time) {		
		//see who wins and adds score
		var ene_car = object_get_name(hand_enemy[|ene].object_index);
		var ply_car = object_get_name(hand_player[|ply].object_index);
		
		if (ene_car == ply_car) { //tie
		} else if ((ene_car=="obj_rock" && ply_car=="obj_scissor") || (ene_car=="obj_scissor" && ply_car=="obj_paper") || (ene_car=="obj_paper" && ply_car=="obj_rock")) { //enemy win
			score_enemy ++;
			audio_play_sound(snd_lost,0,false);
		} else { //player win
			score_player ++;
			audio_play_sound(snd_win,0,false);
		}
		
	} else if (timer <= 0) {
		phase_discard = true;
		phase_scoring = false;
		target_position = [1000,650 - ds_list_size(cards_discard)*8];
		target_depth = -ds_list_size(cards_discard);
	}
}

if (phase_discard) {
	var current;
	var enemy = true;
	
	if (ds_list_size(hand_enemy) == 3) {
		current = hand_enemy[|ene];
	} else if (ds_list_size(hand_player) == 3) {
		current = hand_player[|ply];
		enemy = false;
	} else if (ds_list_size(hand_enemy) == 2) {
		current = hand_enemy[|1];
		current.back = false;
		enemy = true;
	} else if (ds_list_size(hand_enemy) == 1) {
		current = hand_enemy[|0];
		current.back = false;
		enemy = true;
	} else if (ds_list_size(hand_player) == 2) {
		current = hand_player[|1];
		enemy = false;
	} else if (ds_list_size(hand_player) == 1) {
		current = hand_player[|0];
		enemy = false;
	} 
	
	current.x+=(target_position[0]-current.x)*lerp_speed;
	current.y+=(target_position[1]-current.y)*lerp_speed;
	current.depth = target_depth;
	
	if (abs(current.x-(target_position[0]))<0.2) {
		audio_play_sound(snd_transfer,0,false);
		target_position[1] -= 8;
		target_depth -= 1;
		ds_list_add(cards_discard, current);
		if (enemy) {
			var ind = ds_list_find_index(hand_enemy,current);
			ds_list_delete(hand_enemy,ind);
		} else {
			var ind = ds_list_find_index(hand_player,current);
			ds_list_delete(hand_player,ind);
		}
		
		if (ds_list_size(cards_discard)%6 == 0) { //change phase
			if (ds_list_size(cards) == 0) { //a new round
				phase_transfer = true;
				target_position = [130,642];
				target_depth = 0;
			} else {
				phase_dealing = true;		
				target_position = [400,100];
			}
			phase_discard = false;
			timer = shuffle_time + 1;
		}
	}
}

if (phase_transfer) {
	var loc = ds_list_size(cards_discard) - 1;
	cards_discard[|loc].x+= (target_position[0]-cards_discard[|loc].x)*0.7;
	cards_discard[|loc].y+= (target_position[1]-cards_discard[|loc].y)*0.7;
	cards_discard[|loc].back = true;
	cards_discard[|loc].depth = target_depth;
	
	if (abs(cards_discard[|loc].x-(target_position[0]))<0.2) {
		//SOUND: pupu
		audio_play_sound(snd_transfer,0,false);
		target_depth -= 1;
		ds_list_add(cards,cards_discard[|loc]);
		ds_list_delete(cards_discard,loc);
		if (ds_list_size(cards_discard) == 0) {
			phase_shuffle = true;
			phase_transfer = false;
			timer = shuffle_time + 1;
		}
	}
}

timer --;