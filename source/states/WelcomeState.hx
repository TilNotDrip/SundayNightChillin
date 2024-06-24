package states;

import flixel.addons.transition.FlxTransitionableState;

class WelcomeState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var isCommunityGame:Bool = false;

	var bg:FlxSprite;
	var displayText:FlxText;

	override public function create():Void
	{
		#if sys
		isCommunityGame = Sys.environment()["COMPUTERNAME"] == 'DESKTOP-01HC5LO' ? true : false;
		#end

		super.create();

		bg = new FlxSprite(20);
		add(bg);

		displayText = new FlxText(0, 0, 0, '', 35);
		displayText.setFormat(Paths.font('DigitalDisco.ttf'), 35);
		add(displayText);

		changeText();
	}

	override public function update(elapsed:Float):Void
	{
		if(!leftState)
		{
			if (controls.ACCEPT)
			{
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTween.tween(bg, {y: bg.y + 1000, x: bg.x + 30, angle: bg.angle + 5}, 2.5, {ease: FlxEase.backIn});
				FlxTween.tween(displayText, {y: displayText.y + 1000, x: displayText.x - 30}, 3, { ease: FlxEase.backIn,
					onComplete: function (twn:FlxTween) {
						FlxG.save.data.sawWelcomeState = true;
						MusicBeatState.switchState(new TitleState());
					}
				});
			}
			#if debug
			else if(controls.RESET)
			{
				isCommunityGame = !isCommunityGame;
				changeText();
			}
			#end
		}

		super.update(elapsed);
	}

	function changeText():Void
	{
		if(!isCommunityGame)
		{
			displayText.text = "Thank you for downloading the demo for\n
			Sunday Night Chillin'\n\n
			This mod took longer than expected\n
			but here is the demo!\n\n
			Anyways, I'm not gonna waste more time...\n\n

			Hit ENTER to play!";
		}
		else
		{
			displayText.text = "Hey CommunityGame, thanks for playing\n
			this mod! Before the mod starts...\n 
			I'll just be letting you know, please do NOT add\n
			your own skins. We worked hard and don't\n
			want another \"problem\" like we had before.\n
			Please and thank you.\n
			From .json, the owner.\n
			Anyways,\n\n 

			Smash that ENTER to play.";			
		}

		displayText.screenCenter();
		displayText.x += 260;

		bg.loadGraphic(Paths.image(isCommunityGame ? 'welcome/community' : 'welcome/thx'));
		bg.screenCenter(Y);
	}
}