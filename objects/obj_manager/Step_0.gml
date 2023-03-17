if (phase_shuffle) {
	if (timer == shuffle_time) {		
		ds_list_shuffle(cards)
		//shuffle the cards and display the card pile on the left
		for (var i = 0; i < ds_list_size(cards); i ++) {
			cards[|i].x = 130;	
			cards[|i].y = 450 + (8*i);
			cards[|i].depth = i;
		}
	} else if (timer <= 0) {
		phase_dealing = true;
		phase_shuffle = false;
		timer = dealing_time;
	}
}

if (phase_dealing) {
	if (timer == dealing_time) {		
		//distribute the cards
		
		//enemy
		cards[|0].x = 400;
		cards[|0].y = 100;
		cards[|1].x = 600;
		cards[|1].y = 100;
		cards[|2].x = 800;
		cards[|2].y = 100;
		
		//player
		cards[|3].x = 400;
		cards[|3].y = 900;
		cards[|4].x = 600;
		cards[|4].y = 900;
		cards[|5].x = 800;
		cards[|5].y = 900;
		
		ds_list_add(hand_enemy,cards[|0]);
		ds_list_add(hand_enemy,cards[|1]);
		ds_list_add(hand_enemy,cards[|2]);
		ds_list_add(hand_player,cards[|3]);
		ds_list_add(hand_player,cards[|4]);
		ds_list_add(hand_player,cards[|5]);
		ds_list_delete(cards,0);
		ds_list_delete(cards,1);
		ds_list_delete(cards,2);
		ds_list_delete(cards,3);
		ds_list_delete(cards,4);
		ds_list_delete(cards,5);
		show_debug_message("The length is: " + string(ds_list_size(cards)));
	} else if (timer <= 0) {
		phase_decision = true;
		phase_dealing = false;
		timer = decision_time;
	}
}

if (phase_decision) {
	if (timer == decision_time) {	
		//enemy making decision
		var ene = irandom_range(0,2); //random card, and put it into the center
		hand_enemy[|ene].x = 600;
		hand_enemy[|ene].y = 375;
	}
	//the juicy indication of decision:
	for (var i = 0; i < ds_list_size(hand_player); i++) {
		var c = hand_player[|i];
		if (mouse_x > c.x && mouse_x < (c.x+c.sprite_width) && mouse_y > c.y && mouse_y < (c.y+c.sprite_height)) {
			c.y = 865;
			if (mouse_check_button_pressed(mb_left)) { //and player selected the card
				var ply = i;
				c.x = 600;
				c.y = 625;
				player_selected = true;
			}
		} else if (!player_selected) {
			c.y = 900;
		}
	}
	if (player_selected && timer <= 0) {
		phase_scoring = true;
		phase_decision = false;
		timer = scoring_time;
		player_selected = false;
	}
}

if (phase_scoring) {
	if (timer == scoring_time) {		
		//flip the card
		
		
		//see who wins and adds score
		
		
	} else if (timer <= 0) {
		phase_discard = true;
		phase_scoring = false;
		timer = discard_time;
	}
}

timer --;