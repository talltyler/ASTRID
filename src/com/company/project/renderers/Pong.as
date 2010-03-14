package com.company.project.renderers
{
import flash.display.*;
import flash.net.*;
import flash.events.*;
import flash.text.*;
import flash.net.*;

	dynamic public class Pong extends Sprite
	{

		private var sw:Number;
		private var sh:Number;
		private var frame:Sprite; //the frame
		private var p:Sprite; //the player
		private var e:Sprite; //the enemy
		private var b:Sprite; //the ball
		private var net:Sprite //the net
		private var racket_height:Number = 50;
		private var ball_size:Number = 6;
		private var ball_i:Number;
		private var ball_j:Number;
		private var player_score:TextField;
		private var enemy_score:TextField;
		private var pscore:Number = 0;
		private var escore:Number = 0;

		public function Pong(width:Number,height:Number)
		{
			super();
			sw = width;
			sh = height;
			init();
		}
		
		public function clear():void
		{
			removeChild(frame);
			removeChild(player_score);
			removeChild(enemy_score);
			removeChild(net);
			removeChild(e);
			e.removeEventListener(Event.ENTER_FRAME, e_ENTERFRAME);
			removeChild(b);
			b.removeEventListener(Event.ENTER_FRAME, b_ENTERFRAME);
			removeChild(p);
			p.removeEventListener(Event.ENTER_FRAME, p_ENTERFRAME);
		}
		
		public function resize(width:Number,height:Number):void
		{
			sw = width;
			sh = height;
			init();
		}

		private function init():void
		{
			//draw frame
			frame = new Sprite();
			frame.graphics.lineStyle(2,0x000000,1);
			frame.graphics.drawRect(0,0,sw,sh);
			addChild(frame);

			//draw scoreboard
			player_score = new TextField();
			player_score.selectable = false;
			player_score.x = Math.round(sw - sw/4);
			player_score.y = 10;
			player_score.text = pscore.toString();
			addChild(player_score);

			enemy_score = new TextField();
			enemy_score.selectable = false;
			enemy_score.x = Math.round(sw/4);
			enemy_score.y = 10;
			enemy_score.text = escore.toString();
			addChild(enemy_score);

			//draw net
			net = new Sprite();
			net.graphics.beginFill(0x666666);
			net.graphics.drawRect(0,0,1,sh);
			net.graphics.endFill();
			net.x = sw/2;
			net.y = 0;
			addChild(net);
			
			//draw enemy
			e = new Sprite();
			e.graphics.beginFill(0x000000);
            e.graphics.drawRect(0,0,10,racket_height);
            e.graphics.endFill();
			e.x = 10;
			e.y = Math.round(sh/2-racket_height/2);
			addChild(e);
			e.addEventListener(Event.ENTER_FRAME, e_ENTERFRAME);

			//draw ball
			b = new Sprite();
			b.graphics.beginFill(0x000000);
            b.graphics.drawRect(0,0,ball_size,ball_size);
            b.graphics.endFill();
			b.x = sw/2;
			b.y = sh/2;
			addChild(b);
			b.addEventListener(Event.ENTER_FRAME, b_ENTERFRAME);

			//draw player
			p = new Sprite();
			p.graphics.beginFill(0x000000);
            p.graphics.drawRect(0,0,10,racket_height);
            p.graphics.endFill();
			p.x = sw-20;
			p.y = Math.round(sh/2-racket_height/2);
			addChild(p);
			p.addEventListener(Event.ENTER_FRAME, p_ENTERFRAME);

			start_ball();
		}

		private function e_ENTERFRAME(e:Event):void
		{
			if (b.y-34>e.currentTarget.y)
			{
				e.currentTarget.y += 3;
            }
			else if (b.y-30<e.currentTarget.y)
			{
				e.currentTarget.y -= 3;
			}
			if (b.x<e.currentTarget.x+10)
			{
				if (b.y>e.currentTarget.y && b.y<e.currentTarget.y+60)
				{
					ball_i *= -1;
					ball_j = (b.y-(e.currentTarget.y+30))/2;
					}
					else
					{
						pscore+=1;
						player_score.text=String(pscore);
						reset_pong();// reset
					}
                }
		}
		private function p_ENTERFRAME(e:Event):void
		{

			 e.currentTarget.y = mouseY-e.currentTarget.height/2;
			 if (b.x>e.currentTarget.x-10)
			 {
				 if (b.y>e.currentTarget.y && b.y<e.currentTarget.y+60)
				 {
					 ball_i *= -1;
					 ball_j = (b.y-(e.currentTarget.y+30))/2;
				 }
				 else
				 {
					escore+=1;
					enemy_score.text=String(escore);
					reset_pong();// reset
				 }
			}

		}
		private function b_ENTERFRAME(e:Event):void
		{

			e.currentTarget.x += ball_i;		// ball movement and speed
			e.currentTarget.y += ball_j;
			if (e.currentTarget.y>sh || e.currentTarget.y<0)
			{
				ball_j *= -1;
			}
		}
		private function reset_pong():void
		{

			e.x = 10;
			e.y = Math.round(sh/2-racket_height/2);
			b.x = sw/2;
			b.y = sh/2;
			p.x = sw-20;
			p.y = Math.round(sh/2-racket_height/2);
			start_ball();

		}
		private function start_ball():void
		{

			if (Math.random()*3>1)
			{
				ball_i = 8+Math.random()*3;
				}
				else
				{
					ball_i = -8-Math.random()*3;
               }

			ball_j = Math.random()*4;
		}

	}
}
