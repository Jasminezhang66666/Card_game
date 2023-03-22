randomise();
globalvar cards;
cards = ds_list_create();
globalvar cards_discard;
cards_discard = ds_list_create();

globalvar hand_enemy;
hand_enemy = ds_list_create();
globalvar hand_player;
hand_player = ds_list_create();


globalvar timer;
timer = 60;

//different phases of the game:
globalvar phase_shuffle;
phase_shuffle = true;
globalvar phase_dealing;
phase_dealing = false;
globalvar phase_decision;
phase_decision = false;
globalvar phase_scoring;
phase_scoring = false;
globalvar phase_discard;
phase_discard = false;
globalvar phase_transfer;
phase_transfer = false;