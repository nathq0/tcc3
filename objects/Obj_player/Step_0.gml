var right, left, jump, attack, dash;
var chao = place_meeting(x, y + 1, obj_block);

right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
jump = keyboard_check_pressed(ord("S"));
attack = keyboard_check_pressed(ord("J"));
dash = keyboard_check_pressed(ord("L"));

if (ataque_buff > 0) ataque_buff -= 1;

// Código de movimentação
velh = (right - left) * max_velh * global.vel_mult;

// Gravidade
if (!chao)
{
    if (velv < max_velv * 2)
    {
        velv += GRAVIDADE * massa * global.vel_mult;
    }
}

// Estados início
switch(estado)
{
    // PARADO
    case "parado":
    {
        sprite_index = spr_player_parado;

        if (right or left)
        {
            estado = "movendo";
        }
        else if (jump or velv != 0)
        {
            estado = "pulando";
            velv = -max_velv; 
            image_index = 0;
        }
        else if (attack)
        {
            estado = "ataque";
            velh = 0;
            image_index = 0;
        }
        else if (dash)
        {
            estado = "dash";
            image_index = 0;
        }
        break;
    }

    // MOVENDO
    case "movendo":
    {
        sprite_index = spr_player_run;

        if (abs(velh) < .1)
        {
            estado = "parado";
            velh = 0;
        }
        else if (jump)
        {
            estado = "pulando";
            image_index = 0;
            velv = -max_velv; 
        }
        else if (attack)
        {
            estado = "ataque";
            velh = 0;
            image_index = 0;
        }
        else if (dash)
        {
            estado = "dash";
            image_index = 0;
        }
        break; 
    }

    // PULANDO
    case "pulando":
    {
        if (velv > 0)
        {
            sprite_index = spr_player_fall;
        }
        else
        {
            sprite_index = spr_player_pulo;
            if (image_index >= image_number - 1)
            {
                image_index = image_number - 1;
            }
        }

        if (chao)
        {
            estado = "parado";
            velh = 0;
        }
        break; 
    }

    // ATAQUE
    case "ataque":
    {
        velh = 0;

        if (combo == 0)
        {
            sprite_index = spr_player_ataque1;
        }
        else if (combo == 2)
        {
            sprite_index = spr_player_ataque3;
        }

        if (image_index >= 2 && dano == noone && posso)
        {
            dano = instance_create_layer(x + sprite_width / 3, y - sprite_height / 3, layer, obj_dano);
            dano.dano = ataque * ataque_mult;
            dano.pai = id;
            posso = false; 
        }

        if (attack && combo < 2)
        {
            ataque_buff = room_speed;
        }

        if (ataque_buff && combo < 2 && image_index >= image_number - 40)
        {
            combo++;
            image_index = 0;
            posso = true;
            ataque_mult += .7;

            if (dano)
            {
                instance_destroy(dano, false);
                dano = noone;
            }

            ataque_buff = 0;
        }

        if (image_index > image_number - 1)
        {
            estado = "parado";
            velh = 0;
            combo = 0;
            posso = true;

            if (dano)
            {
                instance_destroy(dano, false);
                dano = noone;
            }
        }
        break;
    }

    // DASH
    case "dash":
    {
        if (sprite_index != spr_player_dash)
        {
            sprite_index = spr_player_dash;
            image_index = 0;
        }

        velh = image_xscale * dash_vel;

        if (image_index >= image_number - 1)
        {
            estado = "parado";
        }
        break;
    }

    // HIT
    case "hit":
    {
        if (sprite_index != spr_player_hit)
        {
            sprite_index = spr_player_hit;
            image_index = 0;
        }

        velh = 0;
        velv = 0;

        if (vida_atual > 0)
        {
            if (image_index >= image_number - 1)
            {
                estado = "parado";
            }
        }
        else
        {
            if (image_index >= image_number - 1)
            {
                estado = "dead";
            }
        }
        break;
    }

    // DEAD
    case "dead":
    {
		//checando_controlador
		if (instance_exists(obj_game_controller))
		{
		    with(obj_game_controller)
			{
				game_over = true;
			}
		
		}
		
		
        velh = 0;

        if (sprite_index != spr_player_dead)
        {
            image_index = 0;
            sprite_index = spr_player_dead;
            image_speed = 1; // ou a velocidade normal
        }

        // Quando chegar no último frame, para
        if (image_index >= image_number - 1)
        {
            image_index = image_number - 1;
            image_speed = 0; // trava no último frame
        }
        break;
    }

    // DEFAULT
    default:
    {
        estado = "parado";
    }
}

// Reiniciar a room com ENTER
if (keyboard_check(vk_enter)) game_restart();
