// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
var chao = place_meeting(x, y +1, obj_block);

if (!chao)
{
	velv += GRAVIDADE * massa * global.vel_mult;
}
 
 //if (mouse_check_button_pressed(mb_right))
 //{
 //   estado = "attack";
 //}
 
 switch(estado)
 {
    case "parado":
      {
		  velh = 0;
		  timer_estado++;
        if(sprite_index != spr_inimigo_esqueleto_idle)
			{
			    image_index = 0;
			}
		  sprite_index = spr_inimigo_esqueleto_idle;
		//trocadeestado
		if (position_meeting(mouse_x, mouse_y, self))
		{
			if (mouse_check_button_pressed(mb_right))
			{
			 estado = "hit";
			}
		}
		
		    if (irandom(timer_estado) > 200)
			{
				estado = choose("walk", "parado", "walk");
				timer_estado = 0;
		
		}
		scr_ataca_player_melee(Obj_player, dist, xscale);

 
			break;
		}
			case "walk":
			{
				
				timer_estado++;
				if (sprite_index != spr_inimigo_esqueleto_walk)
			{
			    image_index = 0;
				velh = choose(1, -1) * global.vel_mult;
			}
			 sprite_index = spr_inimigo_esqueleto_walk;
			 
			 //saiuoestado
		    if (irandom(timer_estado) > 200)
			{
			   estado =choose("parado", "parado", "walk");
			   timer_estado = 0;
			}
			scr_ataca_player_melee(Obj_player, dist, xscale);

			 
		 break;
		}
		case "attack": 
		{
			 velh = 0;
			if (sprite_index != spr_inimigo_esqueleto_attack)
			{
				 image_index = 0;
				 posso = true;
				 dano = noone;
		}
		sprite_index = spr_inimigo_esqueleto_attack;
		
		if (image_index > image_number-1)
		{
		    estado = "parado";
		}
		
		//saindoestado
		if (image_index >= 4 && dano == noone && image_index < 5 && posso)
		{
		     dano = instance_create_layer(x +sprite_width/2, y - sprite_height/3, layer, obj_dano); 
			 dano.dano = ataque;
			 dano.pai = id;
			 posso = false; 
		}
		//destruirdano
		if (dano != noone && image_index >= 5)
		{
		      instance_destroy(dano);
			  dano = noone; 
		}
		
		break;
		
		}
		  case "hit":
	  {
		  if(sprite_index != spr_inimigo_esqueleto)
		  {
			  image_index = 0;
			 //ida_atual--;
		  }
		   sprite_index = spr_inimigo_esqueleto;
		//sair do estado
		if (vida_atual > 0)
		{
		   if (image_index > image_number-1)
		{
			  estado = "parado";
	    	}
		}
			else
		{
		   if (image_index >= 4)
		   {
		       estado = "dead";
		   }
		}
        break;
    }
	  case "dead":
	  {
		  velh = 0;
		  	  if(sprite_index !=  spr_esqueleto_morrendo)
		  {
			  image_index = 0;
		  }
		  //morrendodeverdade
	      sprite_index = spr_esqueleto_morrendo; 
		  
		  if (image_index > image_number-1)
		  {
			  image_speed = 0;
			  image_alpha -= .01;
			  
			  if (image_alpha <=0) instance_destroy();
		  }
	  }
 } 