module game_state(
    input clk, reset, load,
    input [4:0] load_x,
    input [25:0] mask,

    output lost_game, start_game);

    
