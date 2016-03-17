%User ID: cs60-db
%Time spent: 20+ hours
%Did all the extra credit. Just read the instructions to see all the extra features (too 
%much to type here.
% some "nice" prolog settings...  see assignment 8's
% description for the details on what these do
% -- but it's not crucial to know the details of these Prolog internals
:- set_prolog_flag( prompt_alternatives_on, groundness ).
:- set_prolog_flag(toplevel_print_options, [quoted(true), 
     portray(true), attributes(portray), max_depth(999), priority(699)]).
:- discontiguous go/1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Dynamic Facts
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% thing_at(X, Y) will be true iff thing X is at location Y.
%% player_at(X) will be true iff player is at location X.
%% The use of dynamic should be at the beginning of the file when
%% we plan to mix static and dynamic facts with the same names.

:- dynamic thing_at/2, player_at/1, spell_rate/1,house/1,name/1,object_spellable/3, spells/1, friend/1,fly/1,fly_lesson/1,troll/1.

%Importing a package to generate random numbers. This will allow me to have
%players improve their spell casting abilities each time by improving the chance
%that their spell succeeds and doesn't backfire.
use_module(library(random)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Letter from Hogwarts
%%%%%%%%%%%%%%%%%%%%%%%%%%
instructions :-
write('You are a witch or wizard prepping to attend Hogwarts School of Witchcraft and Wizardry. The goal is to get to Hogwarts and learn enough to defeat the Troll, which you must find. Here are the functions:'),
nl,write('
go(Direction):				Changes your location.'),
nl,write('
pathOptions:				Lists all the locations and their corresponding 
					direction that are one space away from you.'),
nl,write('
name(Name):				Stores the users name for personalization.'),
nl,write('
inventory:				Lists all the items in your inventory.'),
nl,write('
spell_rate(X):				Shows your current spell proficiency, which 
					improves each time you cast a spell.'),
nl,write('
object_spellable(Object,Location,Spell): Shows objects which you can cast spells on and 
					 which spells work on it.'),
nl,write('
troll(X):				Keeps track of whether the user has defeated the 
					troll or not. The world remains open even after 
					defeating the troll.'),
nl,write('
fly(X):					Keeps track of whether the user is currently
					flying on a broomstick. The user must have a
					broomstick to use this dynamic fact.'),
nl,write('
thing_at(Object,Location):		Lists objects at locations.'),
nl,write('
spells(SpellList):			Gives a list of known spells.'),
nl,write('
house(X):				Lists the users spell. The user is only able to 
					enter the common room of their respective house.'),
nl,write('
friend(Name):				This keeps track of the users friend to
					personalize certain dialogue. The friend depends 
					on which cabin in the Hogwarts Express the user 
					chooses.'),
nl,write('
fly_lesson(X):				Keeps track of whether the user has taken the 
					flying lesson yet. If so, then the user will not 
					experience it again when typing look at the 
					quidditch fields.'),
nl,write('
General Info and Instructions:
After blocks of text terminal will prompt a user input. Simply type any character followed by a period and press enter. This just prevents all the text from popping up at once. For user inputs, if it asks for a string, put an apostrophe at the beginning and end of the input, followed by a period and then pressing enter. Certain inputs, like directions, do not need the apostrophes. The rule of thumb is if the input prompted is lower case, do not use apostrophes. If there is an upper case or it is two words, use apostrophes. Type restart at any point to erase all progress and begin from the beginning again.'),nl,
nl,write('Graders, there is not a simple path to the end. Here is the shortest approach, but please feel free to use your autonomy to explore a little. Note that the game DOES NOT END once you have defeated the troll because there is so much to explore in the world, but you can hit restart to go from the beginning. I put in too much work to create an open world to just end it with the troll. Some locations will not list possible paths or objects because they are storyline locations that are more like bridges to the locations you can interact with. You can hold a maximum of four items. The sorting hat chooses a random subset of 7 questions from 27 total, all taken from Pottermore, to accurately sort you into a house. I even added ASCII art for each crest. At Ollivanders you will also get a wand, which is randomly generated from all the possible wood types, core types, and wand lengths, though I only used integer lengths. All the descriptions are taken from J.K. Rowling. I also use lots of J.K. Rowlings text from the first book. Count this as my citation, though I suppose it is technically plagiarism.'),nl,nl,
write('Ollivanders, Kings Cross Station, any platform, choose a cabin, go from the Entrance Hall to the Great Hall, get sorted, Hallway, Second Stairwell, 2nd Floor Hallway, Charms Class to learn Wingardium Leviosa, 2nd Floor Hallway, Girls Bathroom, cast Wingardium Leviosa on the Troll club.').

restart :- retractall(thing_at(_,_)),
	retractall(troll(_)),
	retractall(fly(_)),
	retractall(spells(_)),
	retractall(player_at(_)),
	retractall(house(_)),
	retractall(spell_rate(_)),
	retractall(object_spellable(_,_,_)),
	retractall(name(_)),
	retractall(friend(_)),
	retractall(fly_lesson(_)),
	start.

%Reasserts dynamic facts
start :-
%There are certain objects that you can't take but that you can cast a spell on.
%object_spellable(object, location, spells that can be used on it)
assert(object_spellable('withered hand','Bourgin and Burkes','Repairo')),
assert(object_spellable(cauldron,'Potions Class','Incendio')),
assert(object_spellable('Porcupine Quills','Potions Class','Incendio')),
assert(object_spellable(quill,'Charms Class','Wingardium Leviosa')),
assert(object_spellable('Troll club','Girls Bathroom','Wingardium Leviosa')),
assert(object_spellable('Troll club','Girls Bathroom','Incendio')),
assert(fly(no)),
assert(troll(no)),

%The player's spell rate starts at 20, explained under cast(Spell),
assert(spell_rate(20)),
assert(fly_lesson(no)),
assert(thing_at('Fang','Hagrids Hut')),
assert(thing_at('evil mask','Bourgin and Burkes')),
assert(thing_at('Spell book','Potions Class')),
assert(thing_at('Dried Nettles','Potions Class')),
assert(thing_at(wand, 'Ollivanders')),
assert(thing_at(galleon,'Entrance Hall')),
assert(thing_at(cat,'Secret Corridor')),
assert(thing_at('Invisibility Cloak','Secret Corridor')),
assert(thing_at('Galleon','Diagon Alley')),
assert(thing_at('Galleon 2','Diagon Alley')),
assert(thing_at('Galleon 3','Diagon Alley')),
assert(thing_at('Galleon 4','Diagon Alley')),
assert(thing_at('Galleon 5','Diagon Alley')),
assert(player_at('Diagon Alley')),
assert(house(no)),
instructions,nl,nl,
write('Please enter your name as a string:  '),read(Name),assert(name(Name)),
write('Ms. or Mr.  :  '), read(Gender),

write('You find a letter on your doorstep. It reads: '),nl,nl,nl,
write('Dear '), write(Gender), write(' '),
write(Name),write(', '),nl,
write('We are pleased to inform you that you have been accepted at'),nl,
write('Hogwarts School of Witchcraft and Wizardry. Please find'),nl,
write('enclosed a list of all necessary books and equipment'),nl,nl,
write('Term begins on September 1. We await your owl by no later'),nl,
write('than July 31.'),nl,nl,
write('Yours sincerely,'),nl,nl,
write('Minerva McGonagall'),nl,
write('Deputy Headmistress'),nl,
read(_),
write('----------------------------------------------------------------------'),nl,
write('It is already July 30th! You do not have much time! Better head to Diagon
Alley to get your school supplies. . . unless, of course, you do not want to be a
wizard?'),nl,
read(_),
write('Well too bad, I worked too hard on this text-based RPG to let you give up that easily!'),nl,nl,
write('----------------------------------------------------------------------'),nl,nl,
player_at(Place), describe(Place),nl,nl,write('The sun is about to set on July 31st. You have just completed a long day
of shopping.You check your supply list:'),nl,
write('-The Standard Book of Spells
-A History of Magic
-Magical Theory
-1 Cauldron
-1 set of brass scales…'),
nl,read(_),nl,
write('Oh no, you have almost forgotten the most important item, your wand! Better head to
Ollivanders post-haste.'),nl,read(_),nl,look,nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Map of Locations
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% path(X, Y, Z) is true iff there is a path from X to Z via direction Y.
path('Diagon Alley','Inside Ollivanders','Ollivanders').
path('Diagon Alley', right, 'Knockturn Alley').
path('Knockturn Alley',behind, 'Diagon Alley').
path('Knockturn Alley', right,'Bourgin and Burkes').
path('Bourgin and Burkes',straight,'Knockturn Alley').
path('Kings Cross Station',left,'Platform 8 and 1/2').
path('Kings Cross Station',straight,'Platform 9 and 3/4').
path('Kings Cross Station',right,'Platform 10 and 3/4').
path('Platform 9 and 3/4',straight,'Cabin 1').
path('Cabin 1',straight,'Cabin 2').
path('Cabin 1',right,'Inside Cabin 1').
path('Cabin 2',straight,'Cabin 3').
path('Cabin 2',left,'Inside Cabin 2').
path('Cabin 3',straight,'Cabin 1').
path('Cabin 3',left,'Inside Cabin 3').
path('Entrance Hall',behind,'Secret Corridor').
path('Secret Corridor',behind,'Entrance Hall').
path('Entrance Hall',straight,'Great Hall').
path('Great Hall',behind,'Entrance Hall').
path('Great Hall','down the stairs','Basement Hallway').
path('Great Hall',left,'Kitchens').
path('Great Hall',right,'Quidditch Fields').
path('Great Hall',straight,'Hallway').
path('Kitchens',straight,'Hufflepuff Basement').
path('Kitchens',right,'Great Hall').
path('Basement Hallway','up the stairs','Great Hall').
path('Basement Hallway',right,'Potions Class').
path('Basement Hallway',straight,'Slytherin Dungeon').
path('Hallway','up the stairs','Gryffindor Tower').
path('Gryffindor Tower','down the stairs','Hallway').
path('Hallway',straight,'Second Stairwell').
path('Second Stairwell',behind,'Hallway').
path('Second Stairwell','up the stairs','2nd Floor Hallway').
path('2nd Floor Hallway','down the stairs','Second Stairwell').
path('2nd Floor Hallway',straight,'Charms Class').
path('2nd Floor Hallway',left,'Girls Bathroom').
path('2nd Floor Hallway',right,'Old Classroom').
path('2nd Floor Hallway','up the stairs','Ravenclaw Tower').
path('Ravenclaw Tower','down the stairs','2nd Floor Hallway').
path('Slytherin Dungeon',behind,'Basement Hallway').
path('Hufflepuff Basement',behind,'Kitchens').
path('Quidditch Fields',left,'Great Hall').
path('Quidditch Fields',straight,'Hagrids Hut').
path('Girls Bathroom',right,'2nd Floor Hallway').
path('Old Classroom',left,'2nd Floor Hallway').
path('Edge of Forbidden Forest',behind,'Hagrids Hut').
path('Potions Class',left,'Basement Hallway').
path('Hagrids Hut',straight,'Edge of Forbidden Forest').
path('Edge of Forbidden Forest',straight,'Forbidden Forest').
path('Forbidden Forest',back,'Edge of Forbidden Forest').
path('Charms Class',behind,'2nd Floor Hallway').
path('Inside Cabin 1',exit,'Hogwarts Platform').
path('Inside Cabin 2',exit,'Hogwarts Platform').
path('Inside Cabin 3',exit,'Hogwarts Platform').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Go Movement Function
%%%%%%%%%%%%%%%%%%%%%%%%%%
go(continue) :-
    entranceHall.

go('Inside Ollivanders') :-
    player_at(Here),
    retract(player_at(Here)),
    assert(player_at('Ollivanders')),
    describe('Ollivanders'),nl,
    ollivanders,
    retract(player_at('Ollivanders')),
    assert(player_at('Kings Cross Station')),
    describe('Kings Cross Station'),nl,write('Possible paths: '),nl,!,pathOptions.

go(Direction) :-
    player_at(Here),
    \+path(Here, Direction, _),
    write('You cannot go that way.'), nl.
    list(Place, List) :- thing_at(Items,Place), List = Items,nl,write('Possible paths: '),nl,!,pathOptions.

go(Direction) :-
    player_at(Here),
    path(Here, Direction, There),
    \+ falsePlatform(There),
    retract(player_at(Here)),
    assert(player_at(There)),
    look,fail.

go(Direction) :-
    player_at(Here),
    path(Here, Direction, There),
    falsePlatform(There),
    describe(There),nl,
    retract(player_at(Here)),
    assert(player_at('Cabin 1')),
    describe('Cabin 1'),nl,write('Possible paths: '),nl,!,pathOptions.


go(exit) :-
    write('The train slows right down and finally stops.'),nl,nl,
    entranceHall.

falsePlatform(There) :- There = 'Platform 8 and 1/2';
	There = 'Platform 10 and 3/4'.


%Exceptions for when I have special storyline things happening


go(Direction) :-
    (player_at('Kitchens'),
    path('Kitchens',Direction,'Hufflepuff Basement'),
    house(House),House=hufflepuff,retract(player_at('Kitchens')),
    assert(player_at('Hufflepuff Basement')),
    look,pathOptions);
    (player_at('Kitchens'),
    path('Kitchens',Direction,'Hufflepuff Basement'),
    house(House),\+ House=hufflepuff,nl,nl,write('Cannot enter another houses common room, that would just be rude.'),!,pathOptions).


pathOptions :- player_at(Here),\+ path(Here,_,_),
	write('No possible paths.').

pathOptions :-
	player_at(Here),path(Here,Dir,There),
	write(Dir),write(': '),write(There),nl.

spellObjects :-
	player_at(Here),\+ setof([Object, Spell], object_spellable(Object,Here,Spell),_),
	write('No Spell Susceptible Objects.').

spellObjects :-
	player_at(Here),setof([Object, Spell], object_spellable(Object,Here,Spell),Spells),
	write('Spell Susceptible Objects: '),write(Spells).

look :- player_at(Place),\+ thing_at(_, Place),describe(Place),nl,nl,
	write('No items at this location'),nl,spellObjects,nl,write('Possible paths: '),nl,!,pathOptions,nl.

look :- player_at(Place),describe(Place),nl,nl,setof(Item, thing_at(Item, Place), Items),write('Items you could take: '),
	write(Items),nl,spellObjects,nl,write('Possible paths: '),nl,!,pathOptions,nl,fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Location Descriptions
%%%%%%%%%%%%%%%%%%%%%%%%%%
describe('Kings Cross Station') :-
write('Muggles bustle around you everywhere in a constant flurry. The
high roof echoes thousands of voices while the large semi-circular
windows let in slanted rays of lights. You seem to recall that 
your platform lies in between those set aside for Muggles. Was it
Platform 8 and ½? Or maybe Platform 10 and ¾? Hmmm, Platform 9 and
¾. If only your head was not so fuzzy from all that Butterbeer last
night as you celebrated with your family.'),nl.

describe('Platform 9 and 3/4') :-
write('You run as fast as you can towards the cement barrier, hoping against hope that you remembered the correct name, but before you can finish your thought, you realize you are already through, and Platform 9 and ¾ opens up before you. The scarlet Hogwarts Express gleams on the tracks before you, letting off steam as it prepares to depart for Hogwarts. Children and teenagers are bustling all about, parents shedding tears and clinging to their children before they head off for the next years adventures. Many a luggage rack are filled with owls, wands, and cauldrons, a sign of the wizarding world indeed. You look up and see it is 10:55, the train departs in 5 minutes. Better find a seat.'),nl.

describe('Platform 8 and 1/2') :-
write('You run as fast as you can towards the barrier. At the last second you feel with dread that this is the wrong platform. Your luggage carts connects with the wall, sending you flying up and over your packages and smack into the wall. As the darkness closes in on you, you can see Muggles stopping and staring at you funnily.'),nl,read(_),nl,
write('You wake up to find yourself already on the Hogwarts Express, racing towards your magical adventure.'),nl.

describe('Platform 10 and 3/4') :-
write('You run as fast as you can towards the barrier. At the last second you feel with dread that this is the wrong platform. Your luggage carts connects with the wall, sending you flying up and over your packages and smack into the wall. As the darkness closes in on you, you can see Muggles stopping and staring at you funnily.'),nl,read(_),nl,
write('You wake up to find yourself already on the Hogwarts Express, racing towards your magical adventure.'),nl.

describe('Secret Corridor') :-
write('You see behind you a corridor hidden behind a large potted plant. You go and investigate. Cobwebs cover the passageway, this looks to be abandoned. A strong wind blows through the broke window, and you forgot your sweater.').

describe('Entrance Hall') :-
write('You stand atop a flight of stone steps and crowded around a huge, oak front door.').

describe('Cabin 1') :-
write('You look inside Cabin 1 on your right. A girl with mousy brown hair puffed up around her hair as if filled with static electricity sits on the right. On the left a freckled-red head plays with his mouse, pretending not to notice her.'),nl,nl.

describe('Inside Cabin 1') :-
write('You introduce yourself to the two students, who look up together when you start to speak.'),nl,nl,
write('Hermione:	You should be in your school robes already, we are almost there.'),nl,read(_),
write('Ron:		Do not listen to her, she is too up tight. Have a chocolate frog.'),nl,nl,
assert(thing_at('Chocolate Frog', in_hand)),write('Chocolate frog added to inventory'),read(_),nl,
write('Hermione:	You too, why are you not in your robes yet Ron?'),nl,read(_),nl,
write('Ron:		Well, my rat Scabbers. . .he tore a hole in them again.'),nl,read(_),nl,
write('Hermione:	Let me see. That is no problem. Repairo.'),nl,read(_),nl,
write('A glow surrounds Rons robes. When the light dissipates you see the robe good as new. You learn the spell Repairo from Hermione, then leave to get changed.'),nl,nl,
assert(spells('Repairo')),assert(friend('Ron')).

describe('Cabin 2') :-
write('You look inside Cabin 2 on your left. A startling blond boy dressed in black and green robes sits on one side of the cabin. He is staring malevolently at two young boys, who look more like goonies, on the other side of the cabin.'),nl,nl.

describe('Inside Cabin 2') :-
write('Before you can speak, all three boys glare in your direction.'),nl,nl,read(_),
write('Draco:	What are you looking at?'),nl,read(_),nl,
write('Goyle:	Yeah, what he said.'),nl,read(_),nl,
write('Crabbe:	*grunt*'),nl,read(_),nl,
write('You gulp, and put on a tentative smile.'),nl,read(_),nl,
write('Draco:	You obviously do not know who I am, Mudblood. The name is Malfoy. Your ignorance is astounding. If 
		you want to keep up at all, you would best listen to us.'),nl,read(_),nl,
write('You take that as an invitation to be friends, though an interesting friendship at that.'),nl,nl,assert(friend('Draco')).

describe('Cabin 3') :-
write('You look inside Cabin 3 on your right. A sparkling vampire…uh, I mean, a young gentleman clad in a yellow sweater with a chiseled chin sits alone in a cabin, staring out the window with smoldering eyes. You feel drawn to him. His beauty is so compelling.'),nl,nl.

describe('Inside Cabin 3') :-
write('You introduce yourself to the brooding youth, who merely glances in your direction. You try to get his attention again.'),nl,read(_),nl,
write('Edw--Cedric:	I am going to be all broody and like I do not want you to look at me because I think I am 
		so sexy and chauvinistic and my skin is all diamondy and my voice is so silky smooth and I 
		totally like taking my shirt off at random moments cause I like have a six pack…
		totally.'),nl,read(_),nl,
write('You stare at him oddly and ask if he is a vampire.'),nl,read(_),nl,
write('Edw--Cedric:	Like why would you ask that?'),nl,read(_),nl,
write('You note that he is knawing on a blood bag'),nl,read(_),nl,
write('Edw--Cedric:	You are ruining my life! Like, leave me alone! Can a guy just have some space with his 
		bloo--fruit punch at all?'),nl,read(_),nl,
write('You are getting tired at his childish behavior. Stake him (1) or no (2)?'),nl,read(Stake),stake(Stake).

describe('Great Hall') :-
(house(House),House = no,write('A grand banquet hall opens up before you, lit by thousands and thousands of candles floating in midair over four long tables laid with glittering golden plates and goblets. At the top of the hall is another long table where the teachers are sitting. Looking upward you see a velvety black ceiling dotted with stars. You hear a student whisper, It is bewitched to look like the sky outside. I read about it in Hogwarts, A History. It is hard to believe there was a ceiling there at all, and that the Great Hall does not simply open on to the heavens.'),nl,sortingHat).

describe('Great Hall') :-
(house(House),\+ House = no,write('A grand banquet hall opens up before you, lit by thousands and thousands of candles floating in midair over four long tables laid with glittering golden plates and goblets. At the top of the hall is another long table where the teachers are sitting. Looking upward you see a velvety black ceiling dotted with stars. You hear a student whisper, It is bewitched to look like the sky outside. I read about it in Hogwarts, A History. It is hard to believe there was a ceiling there at all, and that the Great Hall does not simply open on to the heavens.'),nl).

describe('Diagon Alley') :-
write('There are shops and wizards milling about everywhere. Shops selling robes, shops selling telescopes and strange silver instruments you have never seen before, windows stacked with barrels of bat spleens and eels eyes, tottering piles of spell books, quills, and rolls of parchment, potion bottles, globes of the moon.'),nl.

describe('Ollivanders') :-
write('Peeling gold letters over the door of the shop read: Makers of Fine Wands since 382 B.C.  The shop is tiny, empty except for a single, spindly chair in the corner. Thousands of narrow boxes containing wands are piled right up to the ceiling of the tiny shop, and the whole place has a thin layer of dust about it.'),nl.

describe('Knockturn Alley') :-
write('You enter a dark, twisting alleyway devoted to the DarkArts. From the shop and street vendors one can purchase, among other things, shrunken heads, poisonous candles, human-looking fingernails, and Flesh-Eating Slug Repellent. Other wizards look at you with disapproving eyes. Should you be here?'),nl. 

describe('Bourgin and Burkes'):-
write('You enter the store and see a glass case nearby holding a withered hand on a cushion, a blood-stained pack of cards, and a staring glass eye. Evil-looking masks stare down from the walls, an assortment of human bones lay upon the counter, and rusty, spiked instruments hang from the ceiling, but nothing in here is ever likely to be on a Hogwarts school list.'),nl.

describe('Kitchens') :-
write('You enter an enormous, high-ceilinged room, large as the Great Hall, with mounds of glittering brass pots and pans heaped around the stone walls, and a great brick fireplace at the other end. There appears to be some sort of hidden doors amidst a wall of barrels in front of you.').

describe('Ravenclaw Tower') :-
write('You enter a wide, circular room with a midnight blue carpet, arched windows hung with blue and bronze silks, and a domed ceiling painted with stars. The windows give an excellent view of the school grounds.').

describe('Hufflepuff Basement') :-
write('The room is round and earthy and low-ceilinged. It feels sunny, and its circular windows have a view of rippling grass and dandelions. There is a lot of burnished copper about the place, and many plants, which either hang from the ceiling or sit on the windowsills.').

describe('Slytherin Dungeon') :-
write('The room is tinted green and extends partway under the lake. Low backed black and dark green button-tufted leach sofas fill the space, along with skulls and dark wood cupboards.').

describe('Gryffindor Tower') :-
write('The common room contains a lot of squashy armchairs, a fireplace, and tables. The fireplace is connected to the Floo Network, though not a very private means of communication. On the wall is a notice board for public announcements such as the date of the next Hogsmeade weekend.').

describe('Basement Hallway') :-
write('You can hear footsteps echoing above you from the many floors of the castle.').

describe('Hallway') :-
write('A hallway connecting to the stairwell to Gryffindor Tower.').

describe('Second Stairwell') :-
write('Leads to the second floor.').

describe('2nd Floor Hallway'):-
write('Takes you to Charms Class, Girls Bathroom, or Ravenclaw Tower.').

describe('Quidditch Fields'):-
fly_lesson(no),
write('Hundreds of seats are raised in stands around the field so that
the spectators are high enough to see what is going on. At either end
of the field are three golden poles with hoops on the end.'),nl,nl,flyingLesson.

describe('Quidditch Fields'):-
fly_lesson(yes),
write('Hundreds of seats are raised in stands around the field so that
the spectators are high enough to see what is going on. At either end
of the field are three golden poles with hoops on the end.').

describe('Girls Bathroom'):-
troll(no),
write('You enter the bathroom to see a horrible sight. A troll, twelve feet tall, its skin a dull, granite gray, its great lumpy body like a boulder with its small bald head perched on top like a coconut. It has short legs thick as tree trunks with flat, horny feet. The smell coming from it was incredible. It is holding a huge wooden club, which drags along the floor because its
arms are so long. You better have a plan to knock it out, and fast, as it heard you enter and is beginning to lumber your way. Either that, or run for your life!').

describe('Girls Bathroom'):-
troll(defeat),
write('Just a girls bathroom. Nothing exciting. Except for the residual troll snot staining the floor from where it fell when you defeated it.').

describe('Old Classroom'):-
thing_at('Invisibility Cloak',in_hand),
write('It looks like an unused classroom. The dark shapes of desks and chairs are piled against the walls, and there is an upturned wastepaper basket -- but propped against the wall facing you is something that does not look as if it belongs there, something that looks as if someone had just put it there to keep it out of the way. It is a magnificent mirror, as high as the ceiling, with an ornate gold frame, standing on two clawed feet. There os an inscription carved around the top: Erised stra ehru oyt ube cafru oyt on wohsi'),nl,read(_),nl,
write('You step closer to the mirror, and begin to see your reflection. But something is not right. It is you in the mirror, but your reflection is holding something. A can with the words SPAM written on the front. Your reflection smiles at you and slips the can into its pocket. You feel a sudden weight in your own pocket.'),nl,assert(thing_at(spam,in_hand)),!.

describe('Old Classroom') :-
write('You jiggle the doorknob but it is locked and will not open. It feels like there is an enchantment on it that even an unlocking spell will not break.'),!.

describe('Edge of Forbidden Forest'):-
write('The trees are clustered closely together, in a formidable manner. A narrow, winding earth track disappears into the thick black trees. It is not a place to be reckoned with. You feel that if you were to step foot in that place, the powers that control it would not let you leave alive.').

describe('Forbidden Forest'):-
thing_at('Invisibility Cloak',in_hand),
write('You enter the dark forest and hear a rustling in the bushes. Suddenly, out leaps, a horse? No, to the waist, a man, with red hair and beard, but below that is a horses gleaming chestnut body with a long, reddish tail.'),nl,read(_),nl,
write('Ronan:	'),name(Name),write(Name),write(', you should not be in the forest. Leave before the next thing to jump out of the bushes is a beast instead of a centaur. Luckily you have your invisibility cloak, otherwise you would have been killed already. For your bravery, though, I will teach you a spell that will set things on fire, to protect you later.'), assert(spells('Incendio')),nl,read(_),nl,
write('Learned Incendio.'),nl,read(_),nl,
write('You decide to leave the forest, determined to never return.').

describe('Forbidden Forest') :-
\+ thing_at('Invisibility Cloak',in_hand),
write('A beast jumps from the darkness and pierces your heart with its fangs. You die. There are consequences when you break the rules. Mwahahahaha!'),restart.

describe('Potions Class') :-
write('The dungeons are much colder than the main castle. The Potions classroom walls are covered in jars housing floating pickled animals. Cauldrons are set out at every desk for students to work at in pairs. You sit down with '),friend(Friend),write(Friend),write(' to begin your lesson').

describe('Hagrids Hut'):-
write('There is only one room inside, with hams and pheasants hanging from the ceiling. There is also a fireplace with a copper kettle hanging inside to boil water. In the corner stands a massive bed with a patchwork quilt over it.').

describe('Charms Class'):-
write('The classroom has three rows of desks, all facing the teachers table, behind which sits a large upholstered chair with a high back. Two blackboards flank the teachers table, and behind them is a small shelf with books and other objects, beneath a pair of windows. Flitwick, the short Charms Professor, stands on a stack of book to be seen by the rest of the class'),assert(spells('Wingardium Leviosa')).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Location Predicates/Special
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For interacting with Edward Cullens and killing him if you wish. 1 means stake him 2 means spare him. Is called in the description for Cabin 3.
stake(1):-
	write('You rip off a piece of paneling in the cabin, and spider-jump onto his chest, plunging the stake right through his glittering heart. He disintegrates into a pile of diamond flowers and butterflies. Diamond flowers are added to your inventory.'),assert(friend('Ron')),assert(thing_at('Diamond Flowers',in_hand)),nl,nl.

stake(2):-
	write('You decide to spare the poor vampire out of pity.'),nl,read(_),nl,
	write('Edw--Cedric:	Like omg I cannot believe you almost killed me but like you spared like my life! I am like forever grateful and like in your debt. I will follow you forever and ever and be the sparkly rainbow in your life! <3 '),nl,read(_),nl,
	write('You are seriously rethinking your choice to spare his life, but you get the feeling that staking him might result in all of his sparkles exploding all over you.'),nl,
	assert(friend('Edw-Cedric')),nl,nl.

%All ze dialogue and interactions for the journey from the Hogwarts train platform to the entrance
% hall.
entranceHall :-
	write('People push their way toward the door and out on to a tiny, dark platform. You shiver in the cold night air. Then a lamp came bobbing over the heads of the other students, followed by a giant of a man. His face is almost completely hidden by a long, shaggy mane of hair and a wild, tangled beard, but you can make out his eyes, glinting like black beetles under all the hair.'),nl,read(_),nl,
	write('Hagrid:		Firs years! Firs years over here!'),nl,read(_),nl,
	write('The giant lumbers over to you.'),nl,read(_),nl,
	write('Hagrid:		You must be '),name(Name),write(Name),write('. I have not introduced meself. Rubeus Hagrid,
		Keeper of Keys and Grounds here at Hogwarts. Follow me!'),nl,read(_),nl,
	write('You slip and stumble on a steep path. Suddenly, the narrow path opens onto the edge of a great black lake. Perched atop a high mountain on the other side, its windows sparkling in the starry sky, is a vast castle with many turrets and towers.'),nl,read(_),nl,
	write('Hagrid:		No moren two to a boat!'),nl,read(_),nl,
	write('He points to a fleet of little boats sitting in the water by the shore. You are followed into your boat by '),friend(Friend),write(Friend),write('.'),nl,read(_),nl,
	write('Hagrid:		Everyone in? Right then -- FORWARD!'),nl,read(_),nl,
	write('And the fleet of little boats moved off all at once, gliding across the lake, which was as smooth as glass. As you reach the cliff you bend your head as you are carried through a curtain of ivy hiding a wide opening in the cliff face. You reach a kind of underground harbor, and clamber out onto rocks and pebbles. Everyone walks up a flight of stone steps and crowded around the huge, Oak front door.'),nl,read(_),nl,
	write('The door swings open at once. A tall, black-haired witch in emerald-green robes stood there. She has a very stern face and your first thought is that this was not someone to cross.'),nl,read(_),nl,
	write('Prof. McGonagall:	Welcome to Hogwarts. The start-of-term banquet will begin shortly, but before you take your seats in the Great Hall, you will be sorted into your houses. The Sorting is a very important ceremony because, while you are here, your house will be something like your family within Hogwarts. You will have classes with the rest of your house, sleep in your house dormitory, and spend free time in your house common room.'),nl,read(_),nl,
	write('Prof. McGonagall:	The four houses are called Gryffindor, Hufflepuff, Ravenclaw, and Slytherin. Each house has its own noble history and each has produced outstanding witches and wizards. While you are at Hogwarts, your triumphs will earn your house points, while any rulebreaking will lose house points. At the end of the year, the house with the most points is awarded the house cup, a great honor. I hope each of you will be a credit to whichever house becomes yours.'),nl,read(_),nl,
	write('Prof. McGonagall:	The Sorting Ceremony will take place in a few minutes in front of the rest of the school. I suggest you all smarten yourselves up as much as you can. Enter when you are ready.'),retract(player_at(_)),assert(player_at('Entrance Hall')),nl,write('Possible paths: '),nl,nl,!,pathOptions.

%Generates your wand and interactions with Ollivander
ollivanders :-
	random(1,3,CoreRand),
	random(1,38,WandRand),
	core(CoreRand,Core,CoreDesc),
	wand(WandRand,Wand,WandDesc),
	random(8,15,WandLength),
	write('Ollivander:	Ah, welcome '),name(Name),write(Name),write(' ,
		I have been waiting for you. It is time to find you a wand. Now, you do not
		choose the wand, but the wand chooses you. Let us see what will be a good match.'),nl,read(_),nl,
	write('You try wand after wand, trying to conjure up the slightest bit of magic, but to no avail.'),nl,read(_),nl,
	write('Ollivander:	Not to worry, not to worry, I think I have the perfect one,
		let me bring it in from the back'),nl,read(_),nl,
	write('Ollivander places the wand in your hand and a wind rises up around you, rustling your hair.'),nl,read(_),nl,
	write('Ollivander:	'),write(Core),write(', '),write(Wand),write(', '),write(WandLength),
	write(' inches. A very special one indeed.'),nl,read(_),nl,
	write(CoreDesc),nl,read(_),nl,write(WandDesc),nl,read(_),retract(thing_at(wand, 'Ollivanders')),
    assert(thing_at(wand, in_hand)), nl, write('You took '), write(wand),nl, nl.

%Your first flying lesson. Gives you a broomstick and teaches you to fly.
flyingLesson :-
write('There are twenty broomsticks lying in neat lines on the ground. You heard Fred and George Weasley complain about the school brooms, saying that some of them started to vibrate if you flew too high, or always flew slightly to the left. A teacher with short, gray hair, and yellow eyes like a hawk, arrives.'),nl,read(_),nl,
write('Madam Hooch:	Well, what are you all waiting for? Everyone stand by a broomstick. Come on, hurry up.'),nl,read(_),nl,
write('You glance down at your broom. It is old and some of the twigs are sticking out at odd angles.'),nl,read(_),nl,assert(thing_at(broomstick,in_hand)),write('You obtained a broomstick'),nl,nl,
write('Madam Hooch:	Stick out your right hand over your broom, and say: up'),nl,nl,
read(FlyCommand),nl,!,startFlying(FlyCommand),nl,read(_),nl,
friend(Friend),write(Friend),write(', nervous and jumpy and frightened of being left on the
ground, pushs off hard.'),write(Friend),write(' is rising straight up like a cork shot out of a bottle -- twelve feet -- twenty feet. You see his scared white face look down at the ground falling away. He slips sideways off the broom and -- WHAM -- a thud and a nasty crack and, '),write(Friend),write(' lyes facedown on the grass in a heap. His broomstick still rises higher and higher, and starts to drift lazily toward the forbidden forest and out of sight.'),nl,read(_),nl,
write('Madam Hooch:	Out of the way! Are you alright? Broken wrist, come let us go to the hospital wing. Lesson over!'),nl,nl,startFlying('down'),retract(fly_lesson(no)),assert(fly_lesson(yes)).

%Allows you to change the dynamic fly fact to let you fly, or to ground you.
startFlying(_) :- \+ thing_at(broomstick,in_hand), write('You do not have a broomstick.').
startFlying(Command) :- Command = up, fly(flying), write('You are already flying.').
startFlying(Command) :-  Command = up, retract(fly(no)), assert(fly(flying)),write('Your broomstick shoots into your hand and you become airborne.'), !.
startFlying(Command) :- Command = down,retract(fly(flying)),assert(fly(no)),write('You land on the ground and dismount your broomstick.').
startFlying(Command) :- Command \= up, write('Your broom wobbles stubbornly but does not go into your hand.').
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spell Casting
%%%%%%%%%%%%%%%%%%%%%%%%%%
%spells are not guaranteed to work. The more a player practices a spell
%the greater the probability that the spell will succeed. I need to keep
%track of the success rate here as well.
cast(Spell,_) :-
	\+ spells(Spell),
	write('You do not know that spell yet.').

cast(Spell,Object) :-
	player_at(Here),
	\+ object_spellable(Object,Here,Spell),
	write('Either you cannot cast that spell on that object, or that object is not in this location.').

cast(Spell, Object) :-
	player_at(Here),
	%Ensures that you know the spell you are trying to cast
	spells(Spell),
	%Ensures that you can cast that spell on that object, which is at your location
	object_spellable(Object,Here,Spell),
	%find the current spell rate
	spell_rate(Current),
	Current = 65,
	%generates a random number to see if the spell succeeds
	random(65, 100, SuccessProb),
	%If SuccessProb is above 70 the spell succeeds
	success(SuccessProb,Spell,Object,Here),!.

cast(Spell,Object):- 
	player_at(Here),
	%Ensures that you know the spell you are trying to cast
	spells(Spell),
	%Ensures that you can cast that spell on that object, which is at your location
	object_spellable(Object,Here,Spell),
	%find the current spell rate
	spell_rate(Current),
	\+ Current = 65,
	%generates a random number to see if the spell succeeds
	random(Current, 100, SuccessProb),
	%A spell will succeed if a random number greater than 70 is generated.
	%At the beginning we will generate numbers from 0 to 100. Each time the
	%player casts a spell, the lower limit increases by one point to a maximum
	%of 65. The spell_rate is a dynamic fact.
	retract(spell_rate(Current)),
	NewRate is Current + 1,
	assert(spell_rate(NewRate)),
	%If SuccessProb is above 70 the spell succeeds
	success(SuccessProb,Spell,Object,Here),!.


%Prints out whether your spell succeeded or not.
success(Rate,Spell,Object,Here) :- 
	\+ Spell = 'Incendio',
	Rate>70, write('Your spell succeeded!'),
	retract(object_spellable(Object,Here,Spell)),
	assert(thing_at(Object,Here)),
	spellEffect(Spell,Object).

success(Rate,'Incendio',Object,Here) :- 
	Rate>70, write('Your spell succeeded!'),
	retract(object_spellable(Object,Here,'Incendio')),
	spellEffect('Incendio',Object).

success(Rate,_,_,_) :-
	\+ Rate>70, write('A large cloud of smoke erupted from your wand. It seems you need more practice').

%Lists the effects for each of the spell types.
spellEffect('Repairo',Object) :- 
	write('You successfully fixed the '),write(Object),write('.').

spellEffect('Incendio',Object) :-
	\+ Object = cauldron,
	\+ Object = 'Troll club',
	player_at(Here),
	write('You set the '),write(Object),write(' ablaze. It blows up in '),friend(Friend),write(Friend),write('s face then disintegrates into ash.'),retract(object_spellable(Object,Here,'Incendio')).


spellEffect('Incendio',cauldron) :-
	write('You set a fire beneath the cauldron.'),!.

spellEffect('Incendio','Troll club') :-
	write('You set the trolls club on fire. It is quite dumb, and stares at the club as the fires spreads to the handle, and begins to singe his hand. He cries out in pain, stumbles backwards, and hits his head on the wall. He falls to the ground with a thud that makes the whole room tremble.'),retract(troll(_)),retract(object_spellable('Troll club',_,_)),assert(troll(defeat)),nl,nl,
write('Congratulations, you have successfully defeated the troll. Stay and explore a while, or type restart to begin your adventure again!').


spellEffect('Wingardium Leviosa',quill) :-
	write('You successfully levitate the quill!').

spellEffect('Wingardium Leviosa','Troll club') :-
	write('The club flys suddenly out of the trolls hand, rises high, high up into the air, turns slowly over -- and drops, with a sickening crack, onto the trolls head. The troll sways on the spot and then falls flat on its face, with a thud that makes the whole room tremble.'),retract(troll(_)),retract(object_spellable('Troll club',_,_)),assert(troll(defeat)),nl,nl,
write('Congratulations, you have successfully defeated the troll. Stay and explore a while, or type restart to begin your adventure again!').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inventory
%%%%%%%%%%%%%%%%%%%%%%%%%%

%You can have a maximum of 4 items in your inventory.
inventory :- write('Inventory: '),
	setof(Item, thing_at(Item, in_hand), Items),
	write(Items),
	nl.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Take
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% This is how one can take an object.
take(_) :-
    setof(Item, thing_at(Item, in_hand), Items),
    length(Items,L),
    \+ L<4,
    write('Your inventory is full').

take(cat) :-     player_at(Place),
    setof(Item, thing_at(Item, in_hand), Items),
    length(Items,L),
    L<4,
    thing_at(cat, Place),
    retract(thing_at(cat, Place)),
    assert(thing_at(cat, in_hand)),
    nl, write('You see something sparkling on a ledge beneath a window. Whoops, those are the glittering eyes of a cat. It looks so lonely and abandoned. You decide to adopt it.').

take(X) :-
    thing_at(X, in_hand),
    nl, write('You are already holding that.'),
    nl.

take(X) :-
    player_at(Place),
    \+ setof(Item, thing_at(Item, in_hand), _),
    thing_at(X, Place),
    retract(thing_at(X, Place)),
    assert(thing_at(X, in_hand)),
    nl, write('You took '),
    write(X),
    nl.

take(X) :-
    player_at(Place),
    setof(Item, thing_at(Item, in_hand), Items),
    length(Items,L),
    L<4,
    thing_at(X, Place),
    retract(thing_at(X, Place)),
    assert(thing_at(X, in_hand)),
    nl, write('You took '),
    write(X),
    nl.


%I didn't have time to implement Accio here. :(
take(X) :-
	player_at(Place),
	thing_at(X, Location),
	Place \= Location,
	write('Cannot take '),write(X),
	write('. It is at '), write(Location).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Drop
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Allows you to drop items in your current location.
drop(X) :-
	player_at(Place),
	retract(thing_at(X, in_hand)),
	assert(thing_at(X, Place)),
	nl, write('You have just dropped: '),
	write(X),
	nl.
	
drop(X) :-
	\+ thing_at(X, in_hand),
	write('You do not have this item.').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wand Cores
%%%%%%%%%%%%%%%%%%%%%%%%%%
core(1,'Unicorn','Unicorn hair generally produces the most consistent magic, and is least subject to fluctuations and blockages. Wands with unicorn cores are generally the most difficult to turn to the Dark Arts. They are the most faithful of all wands, and usually remain strongly attached to their first owner, irrespective of whether he or she was an accomplished witch or wizard.

Minor disadvantages of unicorn hair are that they do not make the most powerful wands (although the wand wood may compensate) and that they are prone to melancholy if seriously mishandled, meaning that the hair may die and need replacing.').

core(2,'Phoenix','This is the rarest core type. Phoenix feathers are capable of the greatest range of magic, though they may take longer than either unicorn or dragon cores to reveal this. They show the most initiative, sometimes acting of their own accord, a quality that many witches and wizards dislike.

Phoenix feather wands are always the pickiest when it comes to potential owners, for the creature from which they are taken is one of the most independent and detached in the world. These wands are the hardest to tame and to personalise, and their allegiance is usually hard won.').

core(3,'Dragon','This core is the most flamboyant of the three, and often produces the strongest wands. Dragon heartstring usually favours ambitious spell-casting and as a result the wand is more likely to turn to the Dark Arts than any other core; however, a wand that has this core will not do so of its own will. Dragon heartstring wands generally are not sensitive to moving on from previous owners, but bond strongly with the current owner. This core produces wands that are most prone to accidents, being quite temperamental at times.').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wand Types
%%%%%%%%%%%%%%%%%%%%%%%%%%
wand(1,'Acacia','A very unusual wand wood, which I have found creates tricky wands that often refuse to produce magic for any but their owner, and also withhold their best effects from all but those most gifted. This sensitivity renders them difficult to place, and I keep only a small stock for those witches or wizards of sufficient subtlety, for acacia is not suited to what is commonly known as bangs-and-smells magic. When well-matched, an acacia wand matches any for power, though it is often underrated due to the peculiarity of its temperament.').

wand(2,'Alder','Alder is an unyielding wood, yet I have discovered that its ideal owner is not stubborn or obstinate, but often helpful, considerate and most likeable. Whereas most wand woods seek similarity in the characters of those they will best serve, alder is unusual in that it seems to desire a nature that is, if not precisely opposite to its own, then certainly of a markedly different type. When an alder wand is happily placed, it becomes a magnificent, loyal helpmate. Of all wand types, alder is best suited to non-verbal spell work, whence comes its reputation for being suitable only for the most advanced witches and wizards.').

wand(3,'Apple','Applewood wands are not made in great numbers. They are powerful and best suited to an owner of high aims and ideals, as this wood mixes poorly with Dark magic. It is said that the possessor of an apple wand will be well-loved and long-lived, and I have often noticed that customers of great personal charm find their perfect match in an applewood wand. An unusual ability to converse with other magical beings in their native tongues is often found among apple wand owners, who include the celebrated author of Merpeople: A Comprehensive Guide to Their Language and Customs, Dylan Marwood.').

wand(4,'Ash','The ash wand cleaves to its one true master and ought not to be passed on or gifted from the original owner, because it will lose power and skill. This tendency is extreme if the core is of unicorn. Old superstitions regarding wands rarely bear close examination, but I find that the old rhyme regarding rowan, chestnut, ash and hazel wands (rowan gossips, chestnut drones, ash is stubborn, hazel moans) contains a small nugget of truth. Those witches and wizards best suited to ash wands are not, in my experience, lightly swayed from their beliefs or purposes. However, the brash or over-confident witch or wizard, who often insists on trying wands of this prestigious wood, will be disappointed by its effects. The ideal owner may be stubborn, and will certainly be courageous, but never crass or arrogant.').

wand(5,'Aspen','Wand-quality aspen wood is white and fine-grained, and highly prized by all wand-makers for its stylish resemblance to ivory and its usually outstanding charmwork. The proper owner of the aspen wand is often an accomplished duellist, or destined to be so, for the aspen wand is one of those particularly suited to martial magic. An infamous and secretive eighteenth-century duelling club, which called itself The Silver Spears, was reputed to admit only those who owned aspen wands. In my experience, aspen wand owners are generally strong-minded and determined, more likely than most to be attracted by quests and new orders; this is a wand for revolutionaries.').

wand(6,'Beech','The true match for a beech wand will be, if young, wise beyond his or her years, and if full-grown, rich in understanding and experience. Beech wands perform very weakly for the narrow-minded and intolerant. Such wizards and witches, having obtained a beech wand without having been suitably matched (yet coveting this most desirable, richly hued and highly prized wand wood), have often presented themselves at the homes of learned wandmakers such as myself, demanding to know the reason for their handsome wand’s lack of power. When properly matched, the beech wand is capable of a subtlety and artistry rarely seen in any other wood, hence its lustrous reputation.').

wand(7,'Blackthorn','Blackthorn, which is a very unusual wand wood, has the reputation, in my view well-merited, of being best suited to a warrior. This does not necessarily mean that its owner practises the Dark Arts (although it is undeniable that those who do so will enjoy the blackthorn wand’s prodigious power); one finds blackthorn wands among the Aurors as well as among the denizens of Azkaban. It is a curious feature of the blackthorn bush, which sports wicked thorns, that it produces its sweetest berries after the hardest frosts, and the wands made from this wood appear to need to pass through danger or hardship with their owners to become truly bonded. Given this condition, the blackthorn wand will become as loyal and faithful a servant as one could wish.').

wand(8,'Black Walnut','Less common than the standard walnut wand, that of black walnut seeks a master of good instincts and powerful insight. Black walnut is a very handsome wood, but not the easiest to master. It has one pronounced quirk, which is that it is abnormally attuned to inner conflict, and loses power dramatically if its possessor practises any form of self-deception. If the witch or wizard is unable or unwilling to be honest with themselves or others, the wand often fails to perform adequately and must be matched with a new owner if it is to regain its former prowess. Paired with a sincere, self-aware owner, however, it becomes one of the most loyal and impressive wands of all, with a particular flair in all kinds of charmwork.').

wand(9,'Cedar','Whenever I meet one who carries a cedar wand, I find strength of character and unusual loyalty. My father, Gervaise Ollivander, used always to say, you will never fool the cedar carrier, and I agree: the cedar wand finds its perfect home where there is perspicacity and perception. I would go further than my father, however, in saying that I have never yet met the owner of a cedar wand whom I would care to cross, especially if harm is done to those of whom they are fond. The witch or wizard who is well-matched with cedar carries the potential to be a frightening adversary, which often comes as a shock to those who have thoughtlessly challenged them.').

wand(10,'Cherry','This very rare wand wood creates a wand of strange power, most highly prized by the wizarding students of the school of Mahoutokoro in Japan, where those who own cherry wands have special prestige. The Western wand-purchaser should dispel from their minds any notion that the pink blossom of the living tree makes for a frivolous or merely ornamental wand, for cherry wood often makes a wand that possesses truly lethal power, whatever the core, but if teamed with dragon heartstring, the wand ought never to be teamed with a wizard without exceptional self-control and strength of mind.').

wand(11,'Chestnut','This is a most curious, multi-faceted wood, which varies greatly in its character depending on the wand core, and takes a great deal of colour from the personality that possesses it. The wand of chestnut is attracted to witches and wizards who are skilled tamers of magical beasts, those who possess great gifts in Herbology, and those who are natural fliers. However, when paired with dragon heartstring, it may find its best match among those who are overfond of luxury and material things, and less scrupulous than they should be about how they are obtained. Conversely, three successive heads of the Wizengamot have possessed chestnut and unicorn wands, for this combination shows a predilection for those concerned with all manner of justice.').

wand(12,'Cypress','Cypress wands are associated with nobility. The great medieval wandmaker, Geraint Ollivander, wrote that he was always honoured to match a cypress wand, for he knew he was meeting a witch or wizard who would die a heroic death. Fortunately, in these less blood-thirsty times, the possessors of cypress wands are rarely called upon to lay down their lives, though doubtless many of them would do so if required. Wands of cypress find their soul mates among the brave, the bold and the self-sacrificing: those who are unafraid to confront the shadows in their own and others natures.').

wand(13,'Dogwood','Dogwood is one of my own personal favourites, and I have found that matching a dogwood wand with its ideal owner is always entertaining. Dogwood wands are quirky and mischievous; they have playful natures and insist upon partners who can provide them with scope for excitement and fun. It would be quite wrong, however, to deduce from this that dogwood wands are not capable of serious magic when called upon to do so; they have been known to perform outstanding spells under difficult conditions, and when paired with a suitably clever and ingenious witch or wizard, can produce dazzling enchantments. An interesting foible of many dogwood wands is that they refuse to perform non-verbal spells and they are often rather noisy.').

wand(14,'Ebony','This jet-black wand wood has an impressive appearance and reputation, being highly suited to all manner of combative magic, and to Transfiguration. Ebony is happiest in the hand of those with the courage to be themselves. Frequently non-conformist, highly individual or comfortable with the status of outsider, ebony wand owners have been found both among the ranks of the Order of the Phoenix and among the Death Eaters. In my experience the ebony wands perfect match is one who will hold fast to his or her beliefs, no matter what the external pressure, and will not be swayed lightly from their purpose.').

wand(15,'Elder','The rarest wand wood of all, and reputed to be deeply unlucky, the elder wand is trickier to master than any other. It contains powerful magic, but scorns to remain with any owner who is not the superior of his or her company; it takes a remarkable wizard to keep the elder wand for any length of time. The old superstition, wand of elder, never prosper, has its basis in this fear of the wand, but in fact, the superstition is baseless, and those foolish wandmakers who refuse to work with elder do so more because they doubt they will be able to sell their products than from fear of working with this wood. The truth is that only a highly unusual person will find their perfect match in elder, and on the rare occasion when such a pairing occurs, I take it as certain that the witch or wizard in question is marked out for a special destiny. An additional fact that I have unearthed during my long years of study is that the owners of elder wands almost always feel a powerful affinity with those chosen by rowan.').

wand(16,'Elm','The unfounded belief that only pure-bloods can produce magic from elm wands was undoubtedly started by some elm wand owner seeking to prove his own blood credentials, for I have known perfect matches of elm wands who are Muggle-borns. The truth is that elm wands prefer owners with presence, magical dexterity and a certain native dignity. Of all wand woods, elm, in my experience, produces the fewest accidents, the least foolish errors, and the most elegant charms and spells; these are sophisticated wands, capable of highly advanced magic in the right hands (which, again, makes it highly desirable to those who espouse the pure-blood philosophy).').

wand(17,'English Oak','A wand for good times and bad, this is a friend as loyal as the wizard who deserves it. Wands of English oak demand partners of strength, courage and fidelity. Less well-known is the propensity for owners of English oak wands to have powerful intuition, and, often, an affinity with the magic of the natural world, with the creatures and plants that are necessary to wizardkind for both magic and pleasure. The oak tree is called King of the Forest from the winter solstice up until the summer solstice, and its wood should only be collected during that time (holly becomes King as the days begin to shorten again, and so holly should only be gathered as the year wanes. This divide is believed to be the origin of the old superstition, when his wand’s oak and hers is holly, then to marry would be folly, a superstition that I have found baseless). It is said that Merlin’s wand was of English oak (though his grave has never been found, so this cannot be proven).').

wand(18,'Fir','My august grandfather, Gerbold Octavius Ollivander, always called wands of this wood the survivor’s wand, because he had sold it to three wizards who subsequently passed through mortal peril unscathed. There is no doubt that this wood, coming as it does from the most resilient of trees, produces wands that demand staying power and strength of purpose in their true owners, and that they are poor tools in the hands of the changeable and indecisive. Fir wands are particularly suited to Transfiguration, and favour owners of focused, strong-minded and, occasionally, intimidating demeanour.').

wand(19,'Hawthorn','The wandmaker Gregorovitch wrote that hawthorn makes a strange, contradictory wand, as full of paradoxes as the tree that gave it birth, whose leaves and blossoms heal, and yet whose cut branches smell of death. While I disagree with many of Gregorovitch’s conclusions, we concur about hawthorn wands, which are complex and intriguing in their natures, just like the owners who best suit them. Hawthorn wands may be particularly suited to healing magic, but they are also adept at curses, and I have generally observed that the hawthorn wand seems most at home with a conflicted nature, or with a witch or wizard passing through a period of turmoil. Hawthorn is not easy to master, however, and I would only ever consider placing a hawthorn wand in the hands of a witch or wizard of proven talent, or the consequences might be dangerous. Hawthorn wands have a notable peculiarity: their spells can, when badly handled, backfire.').

wand(20,'Hazel','A sensitive wand, hazel often reflects its owner’s emotional state, and works best for a master who understands and can manage their own feelings. Others should be very careful handling a hazel wand if its owner has recently lost their temper, or suffered a serious disappointment, because the wand will absorb such energy and discharge it unpredictably. The positive aspect of a hazel wand more than makes up for such minor discomforts, however, for it is capable of outstanding magic in the hands of the skillful, and is so devoted to its owner that it often wilts (which is to say, it expels all its magic and refuses to perform, often necessitating the extraction of the core and its insertion into another casing, if the wand is still required) at the end of its masters life (if the core is unicorn hair, however, there is no hope; the wand will almost certainly have died). Hazel wands also have the unique ability to detect water underground, and will emit silvery, tear-shaped puffs of smoke if passing over concealed springs and wells.').

wand(21,'Holly','Holly is one of the rarer kinds of wand woods; traditionally considered protective, it works most happily for those who may need help overcoming a tendency to anger and impetuosity. At the same time, holly wands often choose owners who are engaged in some dangerous and often spiritual quest. Holly is one of those woods that varies most dramatically in performance depending on the wand core, and it is a notoriously difficult wood to team with phoenix feather, as the woods volatility conflicts strangely with the phoenixs detachment. In the unusual event of such a pairing finding its ideal match, however, nothing and nobody should stand in their way.').

wand(22,'Hornbeam','My own wand is made of hornbeam, and so it is with all due modesty that I state that hornbeam selects for its life mate the talented witch or wizard with a single, pure passion, which some might call obsession (though I prefer the term vision), which will almost always be realised. Hornbeam wands adapt more quickly than almost any other to their owner’s style of magic, and will become so personalised, so quickly, that other people will find them extremely difficult to use even for the most simple of spells. Hornbeam wands likewise absorb their owner’s code of honour, whatever that might be, and will refuse to perform acts - whether for good or ill - that do not tally with their master’s principles. A particularly fine-tuned and sentient wand.').

wand(23,'Larch','Strong, durable and warm in colour, larch has long been valued as an attractive and powerful wand wood. Its reputation for instilling courage and confidence in the user has ensured that demand has always outstripped supply. This much sought-after wand is, however, hard to please in the matter of ideal owners, and trickier to handle than many imagine. I find that it always creates wands of hidden talents and unexpected effects, which likewise describes the master who deserves it. It is often the case that the witch or wizard who belongs to the larch wand may never realise the full extent of their considerable talents until paired with it, but that they will then make an exceptional match.').

wand(24,'Laurel','It is said that a laurel wand cannot perform a dishonourable act, although in the quest for glory (a not uncommon goal for those best suited to these wands), I have known laurel wands perform powerful and sometimes lethal magic. Laurel wands are sometimes called fickle, but this is unfair. The laurel wand seems unable to tolerate laziness in a possessor, and it is in such conditions that it is most easily and willingly won away. Otherwise, it will cleave happily to its first match forever, and indeed has the unusual and engaging attribute of issuing a spontaneous lightning strike if another witch or wizard attempts to steal it.').

wand(25,'Maple','I have often found that those chosen by maple wands are by nature travellers and explorers; they are not stay-at-home wands, and prefer ambition in their witch or wizard, otherwise their magic grows heavy and lacklustre. Fresh challenges and regular changes of scene cause this wand to literally shine, burnishing itself as it grows, with its partner, in ability and status. This is a beautiful and desirable wood, and wand quality maple has been among the most costly for centuries. Possession of a maple wand has long been a mark of status, because of its reputation as the wand of high achievers.').

wand(26,'Pear','This golden-toned wood produces wands of splendid magical powers, which give of their best in the hands of the warm-hearted, the generous and the wise. Possessors of pear wands are, in my experience, usually popular and well-respected. I do not know of a single instance where a pear wand has been discovered in the possession of a Dark witch or wizard. Pear wands are among the most resilient, and I have often observed that they may still present a remarkable appearance of newness, even after many years of hard use.').

wand(27,'Pine','The straight-grained pine wand always chooses an independent, individual master who may be perceived as a loner, intriguing and perhaps mysterious. Pine wands enjoy being used creatively, and unlike some others, will adapt unprotestingly to new methods and spells. Many wandmakers insist that pine wands are able to detect, and perform best for, owners who are destined for long lives, and I can confirm this in as much as I have never personally known the master of a pine wand to die young. The pine wand is one of those that is most sensitive to non-verbal magic.').

wand(28,'Poplar','If you seek integrity, search first among the poplars, was a great maxim of my grandfather, Gerbold Ollivander, and my own experience of poplar wands and their owners tallies exactly with his. Here is a wand to rely upon, of consistency, strength and uniform power, always happiest when working with a witch or wizard of clear moral vision. There is a tired old joke among lesser wandmakers that no poplar wand has ever chosen a politician, but here they show their lamentable ignorance: two of the Ministry’s most accomplished Ministers for Magic, Eldritch Diggory and Evangeline Orpington, were the possessors of fine, Ollivander-made poplar wands.').

wand(29,'Red Oak','You will often hear the ignorant say that red oak is an infallible sign of its owners hot temper. In fact, the true match for a red oak wand is possessed of unusually fast reactions, making it a perfect duelling wand. Less common than English oak, I have found that its ideal master is light of touch, quick-witted and adaptable, often the creator of distinctive, trademark spells, and a good man or woman to have beside one in a fight. Red oak wands are, in my opinion, among the most handsome.').

wand(30,'Redwood','Wand-quality redwood is in short supply, yet constant demand, due to its reputation for bringing good fortune to its owner. As is usually the case with wandlore, the general populace have the truth back to front: redwood wands are not themselves lucky, but are strongly attracted to witches and wizards who already possess the admirable ability to fall on their feet, to make the right choice, to snatch advantage from catastrophe. The combination of such a witch or wizard with a redwood wand is always intriguing, and I generally expect to hear of exciting exploits when I send this special pairing out from my workshop.').

wand(31,'Rowan','Rowan wood has always been much-favoured for wands, because it is reputed to be more protective than any other, and in my experience renders all manner of defensive charms especially strong and difficult to break. It is commonly stated that no Dark witch or wizard ever owned a rowan wand, and I cannot recall a single instance where one of my own rowan wands has gone on to do evil in the world. Rowan is most happily placed with the clear-headed and the pure-hearted, but this reputation for virtue ought not to fool anyone - these wands are the equal of any, often the better, and frequently out-perform others in duels.').

wand(32,'Silver Lime','This unusual and highly attractive wand wood was greatly in vogue in the nineteenth century. Demand outstripped supply, and unscrupulous wandmakers dyed substandard woods in an effort to fool purchasers into believing that they had purchased silver lime. The reasons for these wands’ desirability lay not only in their unusually handsome appearance, but also because they had a reputation for performing best for Seers and those skilled in Legilimency, mysterious arts both, which consequently gave the possessor of a silver lime wand considerable status. When demand was at its height, wandmaker Arturo Cephalopos claimed that the association between silver lime and clairvoyance was a falsehood circulated by merchants like Gerbold Ollivander (my own grandfather), who have overstocked their workshops with silver lime and hope to shift their surplus. But Cephalopos was a slipshod wandmaker and an ignoramus, and nobody, Seer or not, was surprised when he went out of business.').

wand(33,'Spruce','Unskilled wandmakers call spruce a difficult wood, but in doing so they reveal their own ineptitude. It is quite true that it requires particular deftness to work with spruce, which produces wands that are ill-matched with cautious or nervous natures, and become positively dangerous in fumbling fingers. The spruce wand requires a firm hand, because it often appears to have its own ideas about what magic it ought to be called upon to produce. However, when a spruce wand meets its match - which, in my experience, is a bold spell-caster with a good sense of humour - it becomes a superb helper, intensely loyal to their owners and capable of producing particularly flamboyant and dramatic effects.').

wand(34,'Sycamore','The sycamore makes a questing wand, eager for new experience and losing brilliance if engaged in mundane activities. It is a quirk of these handsome wands that they may combust if allowed to become bored, and many witches and wizards, settling down into middle age, are disconcerted to find their trusty wand bursting into flame in their hand as they ask it, one more time, to fetch their slippers. As may be deduced, the sycamores ideal owner is curious, vital and adventurous, and when paired with such an owner, it demonstrates a capacity to learn and adapt that earns it a rightful place among the worlds most highly-prized wand woods.').

wand(35,'Vine','The druids considered anything with a woody stem as a tree, and vine makes wands of such a special nature that I have been happy to continue their ancient tradition. Vine wands are among the less common types, and I have been intrigued to notice that their owners are nearly always those witches or wizards who seek a greater purpose, who have a vision beyond the ordinary and who frequently astound those who think they know them best. Vine wands seem strongly attracted by personalities with hidden depths, and I have found them more sensitive than any other when it comes to instantly detecting a prospective match. Reliable sources claim that these wands can emit magical effects upon the mere entrance into their room of a suitable owner, and I have twice observed the phenomenon in my own shop.').

wand(36,'Walnut','Highly intelligent witches and wizards ought to be offered a walnut wand for trial first, because in nine cases out of ten, the two will find in each other their ideal mate. Walnut wands are often found in the hands of magical innovators and inventors; this is a handsome wood possessed of unusual versatility and adaptability. A note of caution, however: while some woods are difficult to dominate, and may resist the performance of spells that are foreign to their natures, the walnut wand will, once subjugated, perform any task its owner desires, provided that the user is of sufficient brilliance. This makes for a truly lethal weapon in the hands of a witch or wizard of no conscience, for the wand and the wizard may feed from each other in a particularly unhealthy manner.').

wand(37,'Willow','Willow is an uncommon wand wood with healing power, and I have noted that the ideal owner for a willow wand often has some (usually unwarranted) insecurity, however well they may try and hide it. While many confident customers insist on trying a willow wand (attracted by their handsome appearance and well-founded reputation for enabling advanced, non-verbal magic) my willow wands have consistently selected those of greatest potential, rather than those who feel they have little to learn. It has always been a proverb in my family that he who has furthest to travel will go fastest with willow.').

wand(38,'Yew','Yew wands are among the rarer kinds, and their ideal matches are likewise unusual, and occasionally notorious. The wand of yew is reputed to endow its possessor with the power of life and death, which might, of course, be said of all wands; and yet yew retains a particularly dark and fearsome reputation in the spheres of duelling and all curses. However, it is untrue to say (as those unlearned in wandlore often do) that those who use yew wands are more likely to be attracted to the Dark Arts than another. The witch or wizard best suited to a yew wand might equally prove a fierce protector of others. Wands hewn from these most long-lived trees have been found in the possession of heroes quite as often as of villains. Where wizards have been buried with wands of yew, the wand generally sprouts into a tree guarding the dead owner’s grave. What is certain, in my experience, is that the yew wand never chooses either a mediocre or a timid owner.').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sorting Hat
%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * The Sorting Predicate, which stores all the questions for the sorting hat
 * sort(Num, Question, ValA, ValB, ValC, ValD)
 * each of the Vals will be either g, s, r, h to represent one of the four houses
 * at the end of the quiz, the most frequent letter will be the individual's house
 */

sort(1, 'Which of the following would you most hate people to call you?
(1) Ordinary
(2) Ignorant
(3) Cowardly
(4) Selfish.  ', h,r,g,s).

sort(2, 'Once every century, the Flutterby bush produces flowers that adapt their scent to attract the unwary. If it lured you, it would smell of:
(1) a crackling log fire
(2) the sea
(3) fresh parchment
(4) home.', g,s,r,h).

sort(3, 'Given the choice, would you rather invent a potion that would guarantee you: 
(1) love
(2) glory
(3) wisdom
(4) power', g,h,r,s).

sort(4, 'After you have died, what would you most like people to do when they hear your name? 
(1) Miss you, but smile.
(2) Ask for more stories about your adventures.
(3) Think with admiration of your achievements.
(4) I do not care what people think of me after I am dead; it is what they think of me while I am alive that counts.', h,g,r,s).

sort(5,'What kind of instrument most pleases your ear? 
(1) the violin
(2) the trumpet
(3) the piano
(4) the drum',h,g,r,s).

sort(6, 'Which of the following do you find most difficult to deal with? 
(1) cold
(2) loneliness
(3) boredom
(4) being ignored', r,h,g,s).

sort(7, 'Which of the following would you most like to study? 
(1) ghosts
(2) vampires
(3) trolls
(4) centaurs', g,h,s,r).

sort(8, 'Late at night, walking alone down the street, you hear a peculiar cry that you believe to have a magical source. Do you: 
(1) Proceed with caution, keeping one hand on your concealed wand and an eye out for any disturbance.
(2) Draw your wand and try to find the source of the noise.
(3) Draw your wand and stand your ground.
(4) Withdraw into the shadows to await developments, while mentally reviewing the most appropriate defensive and offensive spells, should trouble occur?', h,s,g,r).

sort(9, 'You and two friends need to cross a bridge guarded by a river troll who insists on fighting one of you before he will let all of you pass. Do you: 
(1) Attempt to confuse the troll into letting all three of you pass without fighting.
(2) Suggest drawing lots to decide which of you will fight.
(3) Suggest that all three of you should fight (without telling the troll).
(4) Volunteer to fight.', r,s,h,g).

sort(10, '(1) Moon or (2) stars?', h,r,g,s).

sort(11, '(1) Black or (2) white?', s,g,h,r).

sort(12, '(1) Dawn or (2) dusk?', h,s,r,g).

sort(13, '(1) Left or (2) right?', r,g,s,h).

sort(14, '(1) Heads or (2) tails?', g,s,r,h).

sort(15, '(1) Forest or (2) river?', r,h,g,s).

sort(16, 'You enter an enchanted garden. What would you be most curious to examine first?
(1) the silver leafed tree bearing golden apples,
(2) the fat red toadstools that appear to be talking to each other,
(3) the bubbling pool, in the depths of which something luminous is swirling,
(4) the statue of an old wizard with a strangely twinkling eye.', s,h,g,r).

sort(17, 'Four goblets are placed before you. Which would you choose to drink?
(1) The foaming, frothing, silvery liquid that sparkles as though containing ground diamonds.
(2) The smooth, thick, richly purple drink that gives off a delicious smell of chocolate and plums.
(3) The golden liquid so bright that it hurts the eye, and which makes sunspots dance all around the room.
(4) The mysterious black liquid that gleams like ink, and gives off fumes that make you see strange visions.', r,h,g,s).

sort(18, 'Four boxes are placed before you. Which would you try and open:
(1) The small tortoiseshell box, embellished with gold, inside which some small creature seems to be squeaking.
(2) The gleaming jet black box with a silver lock and key, marked with a mysterious rune that you know to be the mark of Merlin.
(3) The ornate golden casket, standing on clawed feet, whose inscription warns that both secret knowledge and unbearable temptation lie within.
(4) The small pewter box, unassuming and plain, with a scratched message upon it that reads: I open only for the worthy.', h,r,s,g).

sort(19, 'A Muggle confronts you and says that they are sure you are a witch or wizard. Do you:
(1) Ask what makes them think so?
(2) Agree, and ask whether they would like a free sample of a jinx?
(3) Agree, and walk away, leaving them to wonder whether you are bluffing?
(4) Tell them that you are worried about their mental health, and offer to call a doctor.', r,s,g,h).

sort(20, 'What are you most looking forward to learning at Hogwarts?
(1) Every area of magic I can.
(2) Hexes and jinxes.
(3) All about magical creatures, and how to befriend or care for them.
(4) Flying on a broomstick.', r,s,h,g).

sort(21, 'Which would you rather be? (1) feared, (2) trusted, (3) imitated, (4) praised', s,h,r,g).

sort(22, 'If you could have any power, which would you choose?
(1) The power to speak to animals.
(2) The power to change your appearance at will.
(3) The power to read minds.
(4) the power of invisibility.',h,s,r,g).

sort(23, 'One of your house mates has cheated in a Hogwarts exam by using a Self-Spelling Quill. Now he has come top of the class in Charms, beating you into second place. Professor Flitwick is suspicious of what happened. He draws you to one side after his lesson and asks you whether or not your classmate used a forbidden quill. What do you do?
(1) Lie and say you do not know (but hope that somebody else tells Professor Flitwick the truth).
(2) Tell Professor Flitwick that he ought to ask your classmate (and resolve to tell your classmate that if he does not tell the truth, you will).
(3) Tell Professor Flitwick the truth. If your classmate is prepared to win by cheating, he deserves to be found out. Also, as you are both in the same house, any points he loses will be regained by you, for coming first in his place.
(4) You would not wait to be asked to tell Professor Flitwick the truth. If you knew that somebody was using a forbidden quill, you would tell the teacher before the exam started.', h,r,g,s).

sort(24, 'A troll has gone berserk in the Headmasters study at Hogwarts. It is about to smash, crush and tear several irreplaceable items and treasures, including a cure for dragon pox, which the Headmaster has nearly perfected; student records going back 1000 years; a mysterious handwritten book full of strange runes, believed to have belonged to Merlin and an invisibility cloak.  Which one item would you rescue from the trolls club?
(1) dragon pox cure
(2) student records
(3) Merlins book
(4) invisibility cloak.',h,r,s,g).

sort(25, 'Which road tempts you most?
(1) The narrow, dark, lantern-lit alley.
(2) The twisting, leaf-strewn path through the woods.
(3) The cobbled street lined with ancient buildings
(4) The wide, sunny, grassy lane.',s,g,r,h).

sort(26, 'Which nightmare would frighten you most?
(1) Standing on top of something very high and realizing suddenly that there are no hand or footholds, nor any barrier to stop you falling.
(2) An eye at the keyhole of the dark, windowless room in which you are locked.
(3) Waking up to find that neither your friends nor your family have any idea who you are.
(4) Being forced to speak in such a silly voice that hardly anyone can understand you, and everyone laughs at you.', h,g,r,s).

sort(27, 'How would you like to be known in history?
(1) the wise
(2) the good
(3) the great
(4) the bold.', r,h,s,g).

%Sorting hat song, then the quiz, which gives you your house stored in a dynamic fact.
sortingHat :-
write('You walk with your classmates to the front of the room, and Professor McGonagall silently places a four-legged stool in front of you and your classmates. On top of the stool she puts a pointed wizard’s hat. The hat is patched and frayed and extremely dirty. Everyone in the Hall is staring at the hat, and for a few seconds, there was complete silence. Then the hat twitches. A rip near the brim opens wide like a mouth – and the hat begins to sing:'),nl,nl,
write('
Oh you may not think I am pretty,
But do not judge on what you see,
I will eat myself if you can find
A smarter hat than me.'),nl,read(_),nl,

write('You can keep your bowlers black,
Your top hats sleek and tall,
For I am the Hogwarts Sorting Hat
And I can cap them all.'),nl,read(_),nl,

write('There is nothing hidden in your head
The Sorting Hat can not see,
So try me on and I will tell you
Where you ought to be.'),nl,read(_),nl,

write('You might belong in Gryffindor,
Where dwell the brave at heart,
Their daring, nerve, and chivalry
Set Gryffindors apart;'),nl,read(_),nl,

write('You might belong in Hufflepuff,
Where they are just and loyal,
Those patient Hufflepuffs are true
And unafraid of toil;'),nl,read(_),nl,

write('Or yet in wise old Ravenclaw,
if you have a ready mind,
Where those of wit and learning,
Will always find their kind;'),nl,read(_),nl,

write('Or perhaps in Slytherin
You will make your real friends,
Those cunning folks use any means
To achieve their ends.'),nl,read(_),nl,

write('So put me on! Do not be afraid!
And do not get in a flap!
You are in safe hands (though I have none)
For I am a Thinking Cap!'),nl,read(_),nl,
write('After the hats reverberating notes fade into the Great Hall, you walk up tentatively to
the sorting hat. McGonagall places the tattered hat on your head, and suddenly, you hear it
speaking into your mind. . .'),nl,read(_),nl,nl,

	%Chooses seven random placement questions, storing the question numbers in QuestList
	randseq(7,27,QuestList),
	QuestList = [NumA | [NumB | [NumC | [NumD | [NumE | [NumF | [NumG | []] ] ] ] ] ] ],
	sort(NumA,A,A1,A2,A3,A4), sort(NumB,B,B1,B2,B3,B4), sort(NumC,C,C1,C2,C3,C4), sort(NumD,D,D1,D2,D3,D4), 
	sort(NumE,E,E1,E2,E3,E4), sort(NumF,F,F1,F2,F3,F4), sort(NumG,G,G1,G2,G3,G4),
	write(A), nl,
	read(AnsA), nl,
	write(B), nl,
	read(AnsB), nl,
	write(C), nl,
	read(AnsC), nl,
	write(D), nl,
	read(AnsD), nl,
	write(E), nl,
	read(AnsE),nl,
	write(F),nl,
	read(AnsF),nl,
	write(G),nl,
	read(AnsG),nl,
	retrieveAns(AnsA,A1,A2,A3,A4,ResA),
	retrieveAns(AnsB,B1,B2,B3,B4,ResB),
	retrieveAns(AnsC,C1,C2,C3,C4,ResC),
	retrieveAns(AnsD,D1,D2,D3,D4,ResD),
	retrieveAns(AnsE,E1,E2,E3,E4,ResE),
	retrieveAns(AnsF,F1,F2,F3,F4,ResF),
	retrieveAns(AnsG,G1,G2,G3,G4,ResG),
	AnsList = [ResA, ResB, ResC, ResD, ResE, ResF, ResG],
	countAns(AnsList, g, GNum),
	countAns(AnsList, s, SNum),
	countAns(AnsList, r, RNum),
	countAns(AnsList, h, HNum),
	placement(GNum,SNum,RNum,HNum,House),
	retract(house(_)),
	assert(house(House)).
	
retrieveAns(UserAns,Ans1,Ans2,Ans3,Ans4,Retrieved) :-
	(UserAns = 1, Retrieved = Ans1);
	(UserAns = 2, Retrieved = Ans2);
	(UserAns = 3, Retrieved = Ans3);
	(UserAns = 4, Retrieved = Ans4).

countAns([],_,0).
countAns([F|R], E, Num) :-
	F=E,
	countAns(R, E, NewNum),
	Num is NewNum + 1.
countAns([F|R], E, Num) :-
	F\=E,
	countAns(R, E, Num).

placement(G,S,R,H,House) :-
	(G>=S, G>=R, G>=H, House = gryffindor,gCrest,
	write('Well, I know just what to do with you. GRYFFINDOR!'));
	(S>G, S>R, S>=H, House = slytherin,sCrest,write('Vying for power, are we? SLYTHERIN!'));
	(R>G, R>=S, R>=H, House = ravenclaw,rCrest,
	write('Such a clever one! RAVENCLAW!'));
	(H>G, H>S, H>R, House = hufflepuff,hCrest,write('So loyal. HUFFLEPUFF!')).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Placement Crests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gCrest :-
write('                       MMMN=+++++?+++++++++++++?+?++?NMMM:                      '),nl,
write('                  M+++++++++++++++++++++++++++++++++++++++++M                   '),nl,
write('                  ,?+++++++++++++++++++++++++++++++++++++++++M                  '),nl,
write('                   M++++++INMMMMMMD8OONMOOOODMMMM7+?+++++++++M                  '),nl,
write('                   M++++MZOOOOM.MOOOOD..8OOOO88OOOOO8MM?+++++M                  '),nl,
write('                   M++++M8OOZM   MOMMMO MOOOOMMOOOOOMOO++++++M                  '),nl,
write('                   7++++M ~8M   ,MMMDMZZ$MNOOOMOOOOOMMO$+++++M                  '),nl,
write('                  M?++++   M.,MMMMZZZZZZZZ8MMMOOOOOO88OM+++++8                  '),nl,
write('                 N+++++M. M8OZZZZZZZZZZN+=====~~MMOOOOOD?+++++M.                '),nl,
write('         .MM. .M++++++I. .ZOOMZZZZZZNMO=====DM8=M==$MOOOM+++++?M. ..            '),nl,
write('        .M?++++++++++$.  MOOMZZZZZZZD=+===========+MDOOOOM+++++++++?+M          '),nl,
write('        N+++++++++++MOOM?ZOMZZZZZZZZM=+======MO=~==MOOOOOON7IMM+++++++M         '),nl,
write('        8++++++++NNOOOOODOMMMZZZZZZZZZZD====MOOOOD8ODZOOOON+====+++++++M        '),nl,
write('       .+++++?MMMMOOOOOZ.D88ZZZ$ZZZZZZZM====MZOOOOOOMMOOOO~===Z8M?+++++M        '),nl,
write('        ?++++?OO. MOOZD   MOZD8ZZZZZZZZZD=========ZOMMOOOM====MOOM+++++M        '),nl,
write('        N+++++ZI   MOM    DZMZZZZZZZZZZZZM=======MOOOOOO8~====OOO7+++++M        '),nl,
write('        M++++?M    .N  MMMZ8ZZZZZZZZZMZZZZZZ8NMZOOOOOOOOM=====OOO++++++M        '),nl,
write('        M+++++OM. .MO8.   OMZZZZ8ZZZZNZZZZZZZZZZMOOOOOO8=====MOON+++++?N        '),nl,
write('        M++++?NMM.MOOOO: NZZOZ8ZZZZM+==MMZZ8ZZZZZZOOOOZD===DOOOOM?+++++,        '),nl,
write('        .+++OOZZZZDZOOOZMOOOMMMZZ8~+======~MNZZZZMMOOOM===MOOOOOM+++++?         '),nl,
write('        .7+$ZZZZZZDMZOO8MOOOOOMZZM==========M=NZM$ZNOM====MOOMOOM+++++D         '),nl,
write('        .M+MZZZZMM8OMZ8~.MOOOM.MZM==========$==M==MZM====+OONMMOM+++++M.        '),nl,
write('        .M++ZZZZ8  DOM=M  OOM   MM==========?======~M===~MOOOMMOO+++++M         '),nl,
write('        .M++DZMOI. .N.==M..7     M===O+======~M=====M===8ZOOOZOO++++++Z         '),nl,
write('      M?MM+++8MM    O$M=M.MD.    ~==7==============?MMM=DOOOOOOO++++++          '),nl,
write('    =+++++++++MO.  MOOM=MNOZM   MO==$I~==================8MZMM=?M++++D8Z+M.     '),nl,
write('    M+?++M?+++?OD MOOOM=M8OOOM.MOO+$IM=8==========================7N++?++++I    '),nl,
write('    M???++?++++8ONDMMMM=MMMMDZDZOO==N?ZM+M+MMMI====MMMMN===========+++D+M++N    '),nl,
write('     OI??I+++++M  M   M=M .    . ?==++=M==========MOO:  .:OMM~====7++M++M+?M    '),nl,
write('      ..IM++++?M .OM  M=MMM  .MZ M===============~OOON. NOOO..:MM+++?8++++M.    '),nl,
write('         M?++++M. DM  M=M8M  .OMM===============MOOOOOMMOOOOM ,?+++++7.         '),nl,
write('          .M++?O.  .  ==..    .M===============:.OOOOOMOOOOOOMM?++++?M.         '),nl,
write('          N??+?8MM87$M=I.   ..M=========~=====I..$ZOZM.MOOOOMMM++++$            '),nl,
write('       M$77$$$$$7$$$$~~~~~~=~===~===~~~~~~~~~===~~=~~=7MMMMM=.=+?+++,           '),nl,
write('  ,MMN=M$$7$MMMMM7$$D~=+7$ODNMMMMMMMMMMMMMD$+~==~~~=~~=~~~~~~~~~~=MMMI....      '),nl,
write('   M=~~~7$MMM8MMMM7$M,,,,,,,,,,,,,,,MMM=?MMM,,,,,,,,,:ZMMMMD===~~~~~~~~~~+MM,   '),nl,
write('    O=~~7ZMM$$7MMM7$M,,,,,,,,,,,,,,MMMM:MM,=M,,,,,,,,,,MMMMM~,,,,,ZMM+=~~~~~M$  '),nl,
write('    :~~87MMM$$$$77$$?,MMMM,:DM:7MM,MMM$MMMM,,~,,,,,,,,,,,MO,,,,,,,,,,,,:~~M.    '),nl,
write('     ~~M$MMM$$$$$$$7,MMMMMMMMMIMMMMMM,MMMN7MM,MMMMMM,.MM7M:,,MD,,,,I,,,M~~M     '),nl,
write('    .~~MZMM8$$$$$$$Z,:MM,N,,MMMM,,MMM,,MMM,MM,,MM,MM,MM,MM,7MMMMMMMMMM,M~~?     '),nl,
write('    .~=NDMM77MMMMMMM,,MM,,,,NMM,,,MMM,,MMM,MM,,MM:MM,MM,MM,MM,MM,MMNMM,M~==     '),nl,
write('    ,~=7NMM$7$7MMMOM,,MM,,,,MM,,,,MMM,,MM?:MMMIMM,MM,MM,MM,MM,MM,MMI,,,M~=~     '),nl,
write('    I~+7$MMM$$$MMM7M,,,,MMMMM,,,~MMMO~OMM,,,,M:,M~MM:MMMMM,MM,MM,MM$,,,M~=.     '),nl,
write('    M~M$7MMM7$$MMM$M,,,,,MM,,,,,,~M~,,MO,,,,,,,,,,,,,,,,=MI=MMM$MMMM,,,N~~.     '),nl,
write('    M~M$$$MMM$7MMMMM,,,,,:+$NMMMMMMMMMMMMMMMMNI,,,,,,,,,,,,,,,,,,,,,M,,N~=.     '),nl,
write('    M~M$$$MMMMMM77$N=~~~~~~~~~~~~~=~~=~~~=~==~~~~~~~~~~$MMM?,,,,,,,,,,,M~=      '),nl,
write('    ~~M$$$$7MZ7$$$$$I8MMMMMMZ+=+.  . .MM=======7.~MMMMN=~~~~=~=$MM,,,,,M~=      '),nl,
write('   M==M$$7$$DMMMMZ7$M++++M~=====M..   M .M======M  M+++++++DNMM===~~NMM8~?      '),nl,
write('   :+.M8N...     .+7?+++++MM=======M. M.OOO+=======~?+++++M   ....=MM?~~~I      '),nl,
write('                    N++++++MD=======M NMOOOM========M+++=N              NM      '),nl,
write('                     M+++++++?MMM?===NO OOMNM?=====~Z++8                        '),nl,
write('                      D++++++++++?8. .7 8MZ++++++++++?M                         '),nl,
write('                       .M++M$8+++++7? ? M+++++++N~++IZ                          '),nl,
write('                         8M   M+?++++8M+++++++M.  MN                            '),nl,
write('                              . M+++++++++++?D                                  '),nl,
write('                                 I+++++++++M                                    '),nl,
write('                                   M+++++?+                                     '),nl,
write('                                    =O++M                                       '),nl,
write('                                     .M$                                        '),nl,
write('                                      .                                         '),nl.
 


rCrest :-
write('            $$$          $$$$$$$MMMMMMMMMMMMMMMMMMM$$$$$$$$        $$$          '),nl,
write('            $$$$$$$$$$$$$$$$$$$$MMMMMMMMMMMMMMMMMMMM$$$$$$$$$$$$$$$$$$          '),nl,
write('            $$$$$$$$$$$$$$$$$$$MMMMMMMMMMMMMMMMMMMMMM$$$$$$$$$$$$$$$$$          '),nl,
write('            $$$$$$$$$$$$$$$$$$$MMMMMMMMMMMMMMMMMMMMMMMM$$$$$$$$$$$$$$           '),nl,
write('             $$$$$$$$$$$$$$$$$MMMMMMMMMMMMMMMMMMMMMMMMM$$$$$$$$$$$$$$           '),nl,
write('             $$$$$            MMMMMMMMMMMMMMMMMMMMMMM        $$$$$$$$           '),nl,
write('             $$$$             MMMMMMMMMMMMMMMMMMMMMM          $$$$$$$           '),nl,
write('          8NNN                 MMMMMMMMMMMMMMMMMMMMMMM        $$$$$$$           '),nl,
write('      MMMMMNDMMMM              MMMMMMMMMMMMMMMMMMMMMMM,,,,,,,,,,,,,,,,,,,,,     '),nl,
write('      MMMMM   MMMM,,,,,,,,,,,,,,,MMMMMMMMMMMM,,,,,,,,,,,,,,,,,,,,,,,,,D,,,,,    '),nl,
write('       MMMM   MMMMM,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,IM,,,,,,,,,,,8MMM,,,,,    '),nl,
write('       MMMM    MMMM,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,DM,,,,,,,,,,,,,,MM,,,     '),nl,
write('       MMMM    MMMM,,,,,:MZ,,?MM,ZM:,:MD,,,M7DM,,MIMD,MM,DMD:MZMM,,M~,MM,,,,    '),nl,
write('       MMMM   MMMM,,,,,MMI,MMZMM,,8,NM,DM+MMMMMI8M+,,,MM,,,,,MM,MM+MM,MM,,,,,,  '),nl,
write('        MMMDMMM,,,,,,,,,,,OMM+MM,,7,MM7D,,MM,MM7MM8,,,MM,,DD+MM,MMM,MOMI,,,,,,, '),nl,
write('        MMM  MMMM,,,,,,,MI,MM,MM,D,,MM,,,,MM,MM8MMM,M,MM,MM,,MM,?M,,MMM,,,,,,,, '),nl,
write('        MMM   MMMM,,,,,MM,,MM,8MMM,,MM,MM,MM,MM+,MMDM,MMDMM,,MM,,N,,MZ,,,,,,,,  '),nl,
write('        MMM   MMMM,,,,,,MMMMN,,,7,,,:MMI,,,,8,,,,,~,,~,,,,,,,,,,,,,,,,,,,,,,,   '),nl,
write('        MMM   MMMMM,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,==++III?:,,,,,,,,    '),nl,
write('        MMM      MM,,,,,,,,,,,,,,,,,,+OMMMMMMMMMMMMMMMM      $$$$$$$$,,,,,,,    '),nl,
write('         MM                       MMMMMMMMMMMMMMMMMMMMMM     $$$$$$$ ,,,,,,,    '),nl,
write('         MMM$$$$$                 MMMMMMMMMMMMMMMMMMMMM      $$$$$$$,,,,,,,     '),nl,
write('            $$$$$$$                MMMMMMMMMMMMMMMMMMMM      $$$$$$=,,,,,,,     '),nl,
write('            $$$$$$$       MMMMMMMMMMMMMMMMMMMMMMMMMMMMM      $$$$$$$    ,,,     '),nl,
write('            $$$$$$$     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN      $$$$$$$ ,,,,,      '),nl,
write('            $$$$$$$    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM        $$$$$$$  ,         '),nl,
write('            $$$$$$$   MMMMMMMMMMMMMMMMMMMMMMMMMMMMM          $$$$$$$   ,        '),nl,
write('            $$$$$$$   MMMMM    MMMMMMMMMMMMMMMMMMMM          $$$$$$$   ,        '),nl,
write('            $$$$$$$              MMMMMMMMMMMMMMMMMM          $$$$$$$            '),nl,
write('            $$$$$$$$               MMMMMMMMMMMMMMMMM         $$$$$$$            '),nl,
write('            $$$$$$$$                MMMMMMMMMMMMMMMMMM      $$$$$$$$            '),nl,
write('            $$$$$$$$                MMMMMMMMMMMMMMMMMMMM    $$$$$$$             '),nl,
write('             $$$$$$$                 MMMMMMMMMMMMMMMMMMMMMMZ$$$$$$$             '),nl,
write('             $$$$$$$                MMMMMMMMM   MMMMMMMMMMMMMMMMMMMMM           '),nl,
write('              $$$$$$                MMMMMMMMM       MMMMMMMMMMMMMMMMMMMMM       '),nl,
write('              $$$$$$$             MMMMMMMMMN           MMMMMMMMMMMMMMMMMM       '),nl,
write('               $$$$$$$$     MMM  MMMMMMMMMM              $MMMMM$                '),nl,
write('                $$$$$$$$     MMMMMMMMMMNMM              $$$$$$$$                '),nl,
write('                 $$$$$$$$     MMMMMMMM                 $$$$$$$$                 '),nl,
write('                  $$$$$$$$$         MM               $$$$$$$$$                  '),nl,
write('                  $$$$$$$$$$         M             $$$$$$$$$$                   '),nl,
write('                   $$$$$$$$$$                     $$$$$$$$$$                    '),nl,
write('                    $$$$$$$$$$$                 $$$$$$$$$$$                     '),nl,
write('                      $$$$$$$$$$              $$$$$$$$$$$                       '),nl,
write('                       $$$$$$$$$$$          $$$$$$$$$$$$                        '),nl,
write('                         $$$$$$$$$$$$$   $$$$$$$$$$$$                           '),nl,
write('                           $$$$$$$$$$$$$$$$$$$$$$$$                             '),nl,
write('                             $$$$$$$$$$$$$$$$$$$                                '),nl,
write('                                $$$$$$$$$$$$$$                                  '),nl,
write('                                 $$$$$$$$$$$$                                   '),nl.
                                                                                                                                            
                                                                                                                                            
hCrest:-
write('                                                       MMMMNODO                                                           '),nl,
write('                                                       DMMMMMMNI                                                          '),nl,
write('                                                     8OO88OMMMOO7                                                         '),nl,
write('                                                    $Z888ZOO8OZZO                                                         '),nl,
write('                                                  $DMMMMMMMMMMMM7?                                                        '),nl,
write('                                             MMMI7MMMMMMMMMMMMMMM?                                                        '),nl,
write('                                           $MZ~~=I==MMMMMMMMDZM==8?                                                       '),nl,
write('                                           OD=~+=+~=MMMMM8=?O=OM===?                                                      '),nl,
write('                                          NM$I=======Z8==~$=ZD=ZMMN7                                                      '),nl,
write('                                         MM+?=====~===?D$Z$~=M==MMO                                                       '),nl,
write('                                   M     MM~$?===I8$~=~=ZMO==D==IMZ                                                       '),nl,
write('                   ~O+~=~?NMMMD77MDOD?==OMMO+====~=+ZN7MIMM+7M?==$MZ?M7???III      IM$I                                   '),nl,
write('                   N+===M?I+?=DD++77I==O=MMM?=I=+Z===MMM7MMMMNM+=+$88O88$I7DNMM7     M+                                   '),nl,
write('                  M$==+?=======+======7+M==MM==I=====7MMMOMMMD=M7==?===7===IZI~NZ    $7                                   '),nl,
write('                  M+==?===~+===?==7Z=?8M?=MMM?=7?=====MOZODMMMZ=MM==+==M==$I=8O=N    IZ                                   '),nl,
write('                  M?==I========ZD$+ZMZM?=MMMM7~O======DMMMMMMMMM++NMMMMMO++===DM?    M?+?III=:                            '),nl,
write('                  M$==+===7=+=ZMM88DMM+=MMMMM=MIZ=~IZ===MMMMMMNMMM=+====+$==?=MN  8 N7?=======?,                          '),nl,
write('                  $N======+MMMMMMMMN==IM?MMO=D=~===OI====MMMMMMMMMMD=N?==+==D7===MMM8===~?====I=:                         '),nl,
write('             M7====OZ=D====+++I+====IM7=MN?=8==NZ~========MMMMMMMMMMMMMZ~====+DMMMM=+===MMMM=~=?+                         '),nl,
write('            M?+==77OZM$NI===++====DMN==8M==N=+=M==========MMMMMMMMMMMMMMMMMMMMMMMMM~=$=7=MMM===M                          '),nl,
write('           NMI+=+NZ==NMMMMMMMMMMMMMMMMMMMMMD=+MMND====~D$+++++=====++=++===MMMMMM?++I====NMD==ON8                         '),nl,
write('            OMMMM8==OMMMMMMMMMMMMMMMMMMMMMMMD=7M====N=+=+++++++++++++++++==NNMMN=+=++========NM?=OO                       '),nl,
write('                   DMMMMMMMMMMMMMMMMMMMMMMMMMMNM=DMMI+==+++++++++++++++==+=DMMMM8=8MD==MMMMMMM=====D                      '),nl,
write('                  MMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMM?++++=+++++++++++++++==$MMMMMZ=DOM?==+D=====?=8ZM                     '),nl,
write('                ZMMMMD~MMMMMMMMMMMMMMMMMMMMMMMMMMMMM==++++++++++++++=++++==IMMMM8OM?=ZMMN===N?NMM+=M                      '),nl,
write('              8NMMMMMM7MMMMMMMMMMMMMMMMMMMMMMMMMDM8Z$N?N=+==+++==++++++++++=7MMMMM==NMN8MMMMMM++==IO8                     '),nl,
write('            $$8NMMMMN=MMMMMMMMMMMMMMMMMMMMMMMD+?ZM?I???I++++++=====+++++===IMMMMM7=+=++NMMMMMMMMMD                        '),nl,
write('       8MMNMMMMMMMMM==MMMMMMMMM?MMMMMMMMMMMMII7?MMM?I???+==+======+=+==++++7MMMMMZ=N$MI==$MMMMM                           '),nl,
write('       IONMMNN8ONMMN+=MMDMMNMMM?IIMMMMMMMZM??I7?MMMMM?+??I========+=+++++==7MDMOO+=NNNM+=+=?MMMM                          '),nl,
write('        8ND==$=+=MMM==?==OMMMMN+M?MMMMMMM???II?MMMMMMMM??I++=++++++++=++++=$NM=+=+8=MMM===8==8MMM                         '),nl,
write('       IMM+=MM8==NMMD+=+=DMMMMZ?I?M8MMMMM?????ZMMMD??7?NM???=======+++++++=DMMOMNMM=?MM+=MM===MMM                         '),nl,
write('       MMZ==ZMN+=NMMMMM7MMMMMMMN??MMOMMD?????IIDNM8??????NM+?D====+++++++==NMMMMMM$==MM=NMM===D+MM                        '),nl,
write('      MM=+==MMM==OMM+8===MMMMMMZ??MMMMMO????I???7MMM????7?7M??N===++++++=+=NMMM8==+=8MD=MMM+====IMM                       '),nl,
write('      MN=M~DMMMII=MN?+++=MMMMMM7??MMMMMI?????????IMMMMMMZ7O++?NN===+++++++=8MM8===++NM=$M+MMI====MM                       '),nl,
write('      MM=+$8MMMZM=IMM++++MMMMMMMN??7MMMD???????????NMMMMMZ==+=$==+==+==+==+$MMMMMI=MD=+MM===+D8=IMM                       '),nl,
write('      MN===OMMDMM+++=+++?MMMMMMMMMM?MMMMMI????????????8MMMMD+=+============OMMMMMM===NMM+====$=IMMM                       '),nl,
write('       MMD==MMM=NMN=++=MMMMMMMMMMMD+IMMMM????8???I8????NM8MMM+=============8MMMMMMMMMMD=8==8==?MMMM                       '),nl,
write('        MMMMMMM+++MMMMMMMMMMMMMMMMMMMMMMM????MMDMMM???IN???MMM$?=========++8MMMMM~?MM=====MNMMMMMM                        '),nl,
write('         MD??+?MM++MMM==MMMMMMMMMMNND8DM?I??IMMMDZMM????????MMMMMMMMMMMMMMMOMMD=~MMM=+?7==DMMMMMMM                        '),nl,
write('         MMM==+MMMMMMMN+=MMM???++++++=D???I?7MMM??MM???I????MMMMMMMMMMMMMMMOMN++N8=MMN+=+MMMMN=MMM                        '),nl,
write('          MMM7MZMMMMMMM=+MMM?+++++=ID??II7MMMMMZMMMM????????M?NMMMMMMMMMMMM8M=+DM8====$MMMMMMM                            '),nl,
write('         MMNMMMMM+MMMMM+=MMM++++DI???I?NMMMMMM=+MMMMMM???????+?MMMMMMMMMMMMN?I=MMMNMO=8MMMMMMMZDM                         '),nl,
write('      NDDMMNNZ7NMMI+NMMN?MMM+++=?=7?DMMMMM+==++++=OMMMM??????Z?ZMMM8MMMMMMMN==+MMMM$=O=MMNZ+7MMMN                         '),nl,
write('        $$M      MMD+MMMMMMM++++=MMMNO=$7+=++++++I?IMMM?????$$??MMM8MMMMMMMM=7MMMND=N=8M$===88D                           '),nl,
write('              8M+MMMMNM88DMM+++++==++++++=$???D==O?NMMM?????????MMMMMMMMMMMMD=IMM=78=NMM==NZIMM                           '),nl,
write('             +MMMMMMMM N8 NMM++++++++++++DO?NMMZ?I?MMMM????????OMMMM$MMMMMMM+=MMM=+=MMMMM+=$+=M                           '),nl,
write('             IMMMMMM      7MM+++++++++++++8?OMMMMMMMMMM????????MMMMM8MMMMMM8++MMM+=MMMMMDMM+=MMM                          '),nl,
write('               M8     MM  IMM+++++++++++++++=+=NMMMMMMMNN?????IMM?8M7MMMMDMO=+MM$N=$+=$Z+==+MMMM8                         '),nl,
write('               Z IMM  N  M8MM+++++++++?+++?+?++N?+D7NMMMZ?????IMMM?MMMMMMMMO=+NM==O==++MMMMMM                             '),nl,
write('              M  MM  MMN  MMM+++++++++++++++++++++++MMMMN??IINMMM8??8MNMMMMM=+I=+7=DD8+?MM       M                        '),nl,
write('                  MMMMMM  NMM+++++++++++++++++++++=787?????8MMMMMMMD8ZNMMMNM++$==MD78+=MM      MM                         '),nl,
write('      IMMMM     8D++MMMMZ+=MMM++++++++++++++++++$???7DMMMMMMNMDMMMMMMMMMMDMM?===7MMZZMMM       MM                         '),nl,
write('       ?MMMNM    +NZMMMMM==MMMM==++++++++++++++=O??MMMMMNMMMMMMMMMMMMMMMDMMMN===$M8?78M      MMMM                         '),nl,
write('        ZMMMMMMMMMMMMMMMN==MMMMM=++++++++++++++++=8=MMMMMMMMMMMMMMMMMMMMMMMMMN==IM7    NMMMMMMMM                          '),nl,
write('           NMMMMMMMM8MMM?==MMMMMNZ=+++++++++++++++=+MMMMMMMMMMMMMMMMMOMMMMMMMMI=8MM     $MMMM8                            '),nl,
write('           +8M==7=+=DMMM++8MMMMMMMM++++++++++?++++++MMMMMMMMMMMMMMMMDMNMMMMMMOD++MM                                       '),nl,
write('         N$+MODMMMMMMMM+++MMMMMMMMMMD=++++++++++++++MMMMMMMMMMMMMMZMMMMMMMMMO==$+MMMM          M                          '),nl,
write('          MMM+=NNMMMN8=+=+MMMMMMMMMN+=I+++++?++++++=MMMMMMMMMMMMMDMMMNZDMMMO===+=+MMMMMMM    MMM                          '),nl,
write('             MMOI7O+==+++++NMMMMMM=+=NMM$++++++?+++=MMMMMMMMMMMDMMND===+7N+===+++==IMMMN    MMM7                          '),nl,
write('               +++=++=?=+++++MMMMMMMMMMMMNI++??++++=MMMMMMMMMNMMMMMND=++I+=++++==+N+=+ZMMMMD                              '),nl,
write('               +++=NI+++++=?+++8MMMMMMMMMMMDN+?+++++MMMMMMMMMMMMMMMMMD++=+7++++++===8Z                                    '),nl,
write('                7==+++++++MN++++IMMMMMMMMMMMNN+++++MMMMMNMMMMMMMMM?+=++=M=++++=+=+=+D8                                    '),nl,
write('                 ?=++++++=M$=+M++++++ZMMMMMMMMMMNN+=MNZMMMMMMMMD+++===ND+MDNM=++O==+87                                    '),nl,
write('                  I?++++7M+MINI+MM=+++++++?8MMMMMMMMMMMMM87+++++=+=OMM+?=+DM+==$===N8                                     '),nl,
write('                    ?=+7M+=OM+++M++?M+++=+++==++=+++=++++=++++++=DM+=MMMM==+MM++==M                                       '),nl,
write('                    I?==+IMM++=M+++N==MMMNI+=++++++++++++=IMM+OM+=+M++DM+=++?===N                                         '),nl,
write('                      7?===?++8D+=N7++M++O?M+ON7MM+?NMNDM=M$+M=NN+=Z8=+MM?++++D                                           '),nl,
write('                       =$7+=++=MMM+++M7M?+$M?N++M++++M=Z?++MMM++MM=+M++++++=8                                             '),nl,
write('                         I77=++=++++ZM++++M?+=++M=+++MOZZ++M=++++OM$+++++ID                                               '),nl,
write('                            O7O=+++++++++DM=++++M=+7=M$+I=+NMZ+++++++=$8                                                  '),nl,
write('                               Z8O=++=+++++++++DMMMM$DO$++++++++++=88                                                     '),nl,
write('                                   OD8O=++++++++=++=++++==+++=ZO87                                                        '),nl,
write('                                        ?Z8D8NND8OZ$ZONDD8O8O                                                             '),nl,
write('                                             :~~~====~=~                                                                  '),nl.
                                                                                                                                            
                                                                                                                                                                                                                
sCrest:-                                                       
write('                                                          8,::::?8                                                      '),nl,
write('                                                        $,,::::::~=O                                                    '),nl,
write('                                                       I,:~$~,=7Z==?8+                                                  '),nl,
write('                                                      +,:~?~88NN:M+=+IO                                                 '),nl,
write('                                                     N=:~N?===?8$M=~?ON~                                                '),nl,
write('                                                     D?======?INOII~IDD?                                                '),nl,
write('                                                      M:===?+7N:I7OZ?DNI=                                               '),nl,
write('                                                   ?+.,:~?:~~INNNN8=?ZDI=                                               '),nl,
write('                                                  Z,,:+O$~,,,:~DNNNN=+IO+                                               '),nl,
write('                                                 $,::=~7=+~=~NMNNNNNM7=I7=                                              '),nl,
write('                                               Z~,:~D$Z$O::~~Z$77$$7ZN$IZ8                                              '),nl,
write('                                              ,~:~O7,?OODNNDNDIDDNNDNN8=+?8                                             '),nl,
write('                                            ~~,,~I.:=~8NDDNNNNNNNNNNNDNI===?7                                           '),nl,
write('                                           8,,:===ZMNNNN?,NNNNNNODNNNDIM,Z=+$I                                          '),nl,
write('                                 :====,~+~:,:+?,:~NNNN=I,N==INNNN78NZ7+8NI~=~~~=O          ODDDD~                       '),nl,
write('                         ,:::~~~,,,,,:,,,,:~=I8?N$~MN~=?,=+=7NNNNN+NN~NDNN:NMN===8NNNN?..O,,,,::~7                      '),nl,
write('                         77.~D=~~+7$$I+~=DIM?=D8=~?DMO,,,.=I$O$=7NN~N7INNN:M,,N==~::::::.,:=ZND?=?7?                    '),nl,
write('                          ONN:ZM~,,,,,,,O+,=NO==,:NN,,======MNN=DNN=MD~DNN=D=Z$I+=~+$NZ===7+,,,?DI88~                   '),nl,
write('                          IZNZ+,,:ZD8$I~::INNM:?~ON$??==II+7~=7?$7NI?N==?M~ZND7?~.,:,,,:M?I,N?=~N7DD?~                  '),nl,
write('                         O,NN,,,DM8Z8MNNNNNNNZ$==MNN:,,~===$MNIMD7Z:,NZ~N:=8~:7MNNNNNMZ,,7?OM:=7ZZDDI=                  '),nl,
write('                        ?=8N:,.N+,,,,,,NNI..O,~+NNNN:,.MO~==NN88N7,,MNM=,7N,=INNNNNZNNNN=,INNNNIIDDZI=                  '),nl,
write('                        $:NM=,+O,,,,,,,?+=,,=,:N8M:$7,O7====$NO~NINZ=7NN=,,Z:.NM~,,77:.NN.~ONN+ZI7D8OZ7                 '),nl,
write('                  $D8$~=7:N8=,++,,MM,=$7+MM,,$N:N.?NN.~7====?NN,MN$N~=7ZNM?~:,N.,NNZ$NNNN7:=NN~?=~:::::~~I              '),nl,
write('               7NZZOOOZDO$OD===~,I~NND~I8~NNNDZN,?NNNZ=I====~ND$$I.DNO7:=8NNNMD,,$++==8NN=:=NND==?DMMZ+~=+Z             '),nl,
write('              8OOOOOOOD8ONON==$=,+N88ZONNNNDND:.8NNNN+~~==~,++ZD8OMN+NN??==IIOZ.::=,+==NN,=?NN~DOO8DDD887=IZ            '),nl,
write('              NDNDDDNNOOO8DNN=Z===+DNNNNNNDI,,ZNONNN~==:,?O==~NN=+ONN:DNNI~,,,,~?,,,I=$N.~=8D=MOONNNDDDD8$7OD           '),nl,
write('              NNNDDNNNZOON8NDN~D7===========DM7=MNMI:,+~=======NND$+NNDINNN$I:.,,::O=$M,==IZ==DOODDNNDDDDN?ZM           '),nl,
write('          ZNDMZNND8NNDNNDDNDDNND=DNOI??$DMNNI==NNII,:+7=========NNNN~DNN77NNNNMNOOMNZ,==D8NNZ=8DDN~NNDDDDM===~O         '),nl,
write('         DZDMO8ZNND8NNNNNDDDNNNNNNNNM7?~IZ~===ZDII7~~.Z::+======+NNM8?INNN=DNNNMIIII7NNNN8DD8NZIIZNNNDDDDO==~~=$        '),nl,
write('         DDN8O8?=?MNNNO+NDDNNNNNDN===?ZD8OOOOOOOOOO$,.:==+===~ZI:ZNNDOOOOOOOOOOO8NDZINNNDDDOOO8NNNNNDDD8NO888Z+$8       '),nl,
write('         NDN8N8NZIIDDD88DNNONNDNNDOOOOOOOOOOOOOOOOOO=.:==I?+?NNDOOOOOOOOOOOOOOOOOOOOZDNNNDDMDZ8:?D8D8DDZODNDNDIOD+      '),nl,
write('          8NOON8DNOOOZNNNDDNNNNN7OOOOOOOOOOOOOOOOOOZD:+:INNNOOOOOOOOOOOOOOOOOOOOOOOOO8ZNNNDN:NNZOOODO==I8OO88N$88I      '),nl,
write('           8DDZONNNNNNNNNNNNNDNZOOOOOOOOOOOOOOOOOOOOONNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOO8Z8N8NDDDNNNZOO8NNNND8ONM?887      '),nl,
write('             NOND88D8O8DNDNDDMN?DOOOOOOOOOOOOOZDI.,,,=.,,.78OOOOOOOOOOOOOOOOOOOOOOOOO8$=NDDNNDDNNNNNNNNDDDONNI8DM$      '),nl,
write('               ZNNNNNNNNNNNDONM=DOOOOOOOOOOOO8,,,,+======,:,OOOOOOOOOOOOOOOOOOOOOOOOO87+NNDND88DNNNDD88ONNN87DDNZ7      '),nl,
write('             7NDNZMO$NNN+NDDZNN=NOOOOOOOOOOOO,??$DONZ=ON+=,:7DOOOOOOO8OOOOOOOOOOOOOOO87NNNDNNNDDDMNNNNO7?~+ODD8O$?      '),nl,
write('            88OM+=+D$=~Z8ND888DDNOOOOOOOOOO?7.,==.,===~MN7,::MOOOOOI.IZOOOOOOOOOOOOOODD8DNDDNNZO=7Z8NNNM7=?8NOZ$?       '),nl,
write('           NONN+,=+7N?=+NNDO8O88NOOOOOOOOZ=~$======+=DNNNM,::DOOO8:=NZOOOOOOOOOOOOOOONZN8OONNNDO~NNNZ8NNND=IZD7         '),nl,
write('          DZN$8,,=8NN?=ONNNDO88MDOOOOOOOOO:,==~?$D++NOZDN8=~=NDOO7,88OOOOOOOOOOOOOOOONDNNNNINNN8ZNNOOODNNNN=$8?         '),nl,
write('          8NN,8,,=M$NI=ZND8NI:O=8OOOOOOOOO+88+DN8=ONOOZ8::=+?N8OOI,8DOOOOOOOOOOOOOOOONZDDD78NNN$ONNNZ8DNNNN?IOO         '),nl,
write('         7ZN:,8,IN$8N78OM,=++~~IOOOOOOOOOOZ8N8I=ZNOOOOOI,,Z=$NOOO7,?NZOOOOOOOOOOOOOOOM8.:,=7NNNI~ONDODDN8NNMI8D         '),nl,
write('         7ZN,,=?$N?DNMN:+D~,,,,7$OOOOOOOOZNZZ88OOOOOOO8,,O=?NNOOOD,==MOOOOOOOOOOOOOOON=?:~=,NNIZ.NNNDDDNONNN+8N?        '),nl,
write('         ?ONM,,?ZN+ONNN~:O$,,,7+IZOOOOOOODNOOOOOOOOOZ8I:,==MNOOOOZO,?~D8OOOOOOOOOOOOONZNNN~MN,=DN8+N8ODNZNNN+8NI        '),nl,
write('         ~DZNN7,ZN7I,NNNI+,,,I?=+ZOOOOOOOZOOOOOOOOOO+:~:I=NN8OOOOOZ?,,=8DOOOOOOOOOOOO8ONNND:~INN?+~MDONZ8NNN?DN7        '),nl,
write('          7ZONNNDND=$,~NNNNMD~==~ZOOOOOOOOOOOOOOOO8I,,:+7NNOOOOOOOOO=,:?ODOOOOOOOOOO8Z=:OMNNNMO~+I,NZOONNNNM7DDI        '),nl,
write('           8O8NDDMN==7,,$NN7NNO=:OOOOOOOOOOOOOOOOD,,,I?ZNNOOOOOOOOOOD.,+=NOOOOOOOOOON7===7NNN77=I.M8NNNNNNN+ODD7        '),nl,
write('           8OONN?:I8==?7+MN+=8NN~8OOOOOOOOOOOOOON.,,8=NNNOOOOOOOOOOOZD,:O=MOOOOOOOOOM+=DZN$NN~~N~,,MN=NNNNN?DD$I        '),nl,
write('          $8OOONDD,$NI=:,+NI8=MN=DOOOOOOOOOOOOZZ,,,?~NNNOOODZ?,..=.,?Z+,?=ZOOOOOOOOONZ=$N.INNMD,~IMN?NDONN+7DD$?        '),nl,
write('          8ZNNNN8IO,7M,7?=M:I=IN+NOOOOOOOOOOOZ7,,,=~NNNOON,,,,~===:,,:7:+=+8OOOOOOOONI=NN.,,==~NNNN7MOO88DII8D7         '),nl,
write('          NO888DZ==7NNM,=:8~.,ZN+NOOOOOOOOOOZ8.::+=8NNZD~,,~IMNNNNNO==:~+==DOOOOOOODN?:NN8:=N8~NNNZ+MOOO88NI8DI         '),nl,
write('       DZZI+??=INI?$ZNNO,++=8,=I=OOOOOOOOOOOD.:.:=ZNNON~,,+INNNDDNNNNI,=IZ$NNOOOOOONIO.NNNN===NNM===7MD8NNOZDDI         '),nl,
write('         OI===D7NN::=INNO,I==M8M==ZOOOOOOOOOO,,==+NNO8+:,:=MNOOOOOON,,=~M=MNNDOOOOZN:IONNN$==NNNZ7,7N=~+=I8DDZ7         '),nl,
write('        ZI=:=N+N:~~=O+=NND+=8=MN$=NOOOOOOOON,:~==ONDON~:,,=ONOZOD$:,,~?N~NN78MOOOO8N8=NNN8IZ,+DI=,OD+.N=$DDNO$?         '),nl,
write('       Z,,:~=N$N~+NNZ==Z8.==O~$NM=ZOOOOOOOZ$=====MNOODI=,,,~~:,,,,,,=8M:NN$$ONOOOONN~7NN.+~8ON==$=.~N$++7ODD$I          '),nl,
write('       $~~O==7I?Z~NNNMI?N:,?,~?NN~+8OOOOOO8~:~===NNOOZD=O,,+:,,,,:=?NOZNN===ZMOOOZNN=8N,=:+$N==?NNM.8M.?=~~=7O          '),nl,
write('       $~~MO8$==8=+D~7DO,88=N=+MN==ZOOOOOOD=:7==~NNOOOODI?MZ=:~+78N$$DDI===78DOOODDZ=MN:N.,MO8N,NM,~N?D===IOD8          '),nl,
write('       Z~~M8OOO8MZ+7$N8.:.Z==D?MN==~8OOOOON?:$===NNOOOOO8M+Z?DZ$?IMOOD,+===~NOOOZN~7=MN==+,,,=M,I:MD+O==$DIDDI          '),nl,
write('       N=~NNOOOO88=7$ND.~?.==?ONN~==?OOOOON:~,?==MN8OOOOOOOOOOOOOOOOO,:~=+=$NOOO88:7=N7==?~.D=+N~D+=~ZDDN8$DN7          '),nl,
write('       N==ZNNOOO8DN?+8N7..8M==MNM====DOOOODI=,=+=+NNOOOOOOOOOOOOOOOZ:,:==O7NOOOOM==D,O==8$=+D=,N++DDD8ZNND$DN7          '),nl,
write('        ==+NNNNOODDN~8INNNNN=:DNZ=====DZOOZN=~,====8NDZOOOOOOOOOOOZ,,:==IDNDOOON+==8.Z=~NN7,:,ZN8Z88OONNN8$DNI          '),nl,
write('        O==ONNNNN8Z8DZINNNNN~:OM=======8OOO8O7:,,,,,:ZNN8OOOOZODI,,,===DONNOOON=====?$=.NOMNMN8=Z88OZNNNN78DDI          '),nl,
write('        Z:~=8NNNNNNNNNNNNNNN,:8+========OOOOD7?,~+:,,,,,+$DNN8I+,,===+DDNNOO8N======I7=:N~=+=:8OO88DNNNN+ZDD$I          '),nl,
write('         :=MI?NNNNNNO7$NNNNN,=8==========$OOOD?D$==?::,,,,,,,,,~+==+ZNNNDOODN=======+$=.N+,,INNDDDNNNNNN+ZNO$           '),nl,
write('        :=D,,,,7+D,,=,:,MNM::I?=======+=7N~DOOONNN?===7,,:,,,,,,,.NNNNNZOONN?====?M==8=~MD,,D=+ZNNNNNNN7=+I$I           '),nl,
write('       =~II.=::?I,:NNNNNNN+,=D===+MNNZ7MNNNZZOOOONNNO?O7DDMMNOM7N8NNNOOODNNNN$~$OMN=O??=:ND,,,,,,.78~IZ+Z$+$D           '),nl,
write('       =~?7.NN8Z=D,DNNNDD,,=N===N~$NNNNNNN??D=NOOOO8NNNNNNNNNNNNNN8OOOONNNNNMN=NNMI++ZO+=:NNNMNN,,?$?N~NONIOD           '),nl,
write('       ?+=D,,$8?N+~7MMM+,:=D==IZ+??ONNNNNNDDO==7OOOOOOZODNNNNDOZOOOOONN+$NNO=IMND?II+=$8~N.$~..,$$=N::$MNNI8D?          '),nl,
write('       +77+8=,~,,,,,,,,~=8I=O7++IIII+NNNNNM======7DOOOOOOOOOOOOOOOZDN?====8II$DIIIIIII+Z?ZN7,~?Z888?::$NND7DD7          '),nl,
write('        ~OZ7~DO=======7MIO$+++IIIIIII?=DN8=========+NOOOOOOOOOOOONN=======+M$?IIIIIIIIII+D=NNM:,,,,,?NNNDIDDD7          '),nl,
write('         =OD8ZI?7$Z$I?+=N++?IIIIIIIIII+I+?N$~========~7DZOOOOZDN8======?D$++++=8IIIIIIIIII$==?8MNNNNNM7?8DD8ZI          '),nl,
write('          =INDDDDDDDDD87=N+IIIIIIII?M?O8?II++8D+=========NO8NM7====~$N$+++++=+++D+IIIIIII+ZIO88OZZZZO8DDDNOZ7+          '),nl,
write('            +I7Z8DDD88DO7=D?IIIIIII7MIZ7?N8++?++=IODDZI???+++?7ONOI+++++++?O8NN?+D?IIIII+Z$DDNNDDDDDDDNDOZ$I            '),nl,
write('             ~=?II77777$OZ?=8IIIIINI8MIIOD++IM8+~+++?+++++++=++?+++++~~+IMI++O?+MND?Z$I8+ODDOZZ$$$ZZZZ$$7I              '),nl,
write('                       =+8O$+O7II8MI8DI7M+++?M+?D~DDMNO?II+II+I7Z8ION,OM+=M=?+ZI+?+7+?87DDDOZ7?                         '),nl,
write('                         =I8O7+Z$?IIII?MI++++NN++++=M=O+8I+ID+~N=+I+887M++IN+++N$++I8?8DD8Z$I                           '),nl,
write('                          ~+ND87?ZOIII?MN=N+=M?++++IM+++8+=+8++M7D?+=M7M+++8D7+++IM+ODDNOZ7?                            '),nl,
write('                            =?8DDZ??8$?II+++8M+++++8Z+++D~=?8+?M$+II+DZ=NM$I++?D$I8D8NOZ$I                              '),nl,
write('                              =?$NDDZI+ON??++++?++ONI+++D=+7O++OO?D++N+++++?M$?ZDDDNOO$7+                               '),nl,
write('                                =?78NDD8$??$MZI=++++++++++++??+==+++++=$DOIIODDDN8OZ$I+~                                '),nl,
write('                                  =?I$8N8DD8Z7?I$NM8Z$7?=======+?$ZDNZIIZ8DD8NDOOZ$I+~                                  '),nl,
write('                                    ~=?I7$8NDDDDDDD8OZ$7?+++++?I$Z8DDDDDDDNOOZZ$I?=                                     '),nl,
write('                                        =+?I7$ZO8DNNNDDD8DDDD888DDNNND8OOZZ$7I+=                                        '),nl,
write('                                            ~=+?I777$$$ZZZZZZZZZZZZZ$$77I?+=                                            '),nl,
write('                                                :~==++????IIIIII????++=~~                                               '),nl.  
                                
