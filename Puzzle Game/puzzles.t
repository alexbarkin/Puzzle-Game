%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                --Puzzles--                                %%
%%Alex Barkin                                                                %%
%%puzzles.t                                                                  %%
%%Jan. 2014                                                                  %%
%%Ms.Krasteva                                                                %%
%%   This program is an interactive puzzle game where the user can drag and  %%
%%  drop the puzzle piece in the correct location...or not. There are three  %%
%%    Main procedures in this program; mainMenu, userInput, and display.     %%
%%  mainMenu is the hub for the whole program and as long as you don't exit  %%
%%  you will be eventually brought back there. userInput is where the user   %%
%%  can play the puzzle game and it has it's own window to eliminate ghost   %%
%% buttons entirely. display is where the user learns if they got the puzzle %%
%%    correct or not. Program flow is fairly easy in this program because    %%
%%   everything is controlled by a GUI button and thus doesn't need error    %%
%%              trapping. Hope you enjoy my code...and the game              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Importing generic Turing GUI file
import GUI

%set four seperate variables to multiple screens sizes/locations
var winID := Window.Open ("position:200;200, graphics:700;400")
var winID1 := Window.Open ("position:200;200, graphics:700;400")
var winID2 := Window.Open ("position:40;400, graphics:150;150")
var winID3 := Window.Open ("position:200;200, graphics:700;400")
Window.Hide (winID1)
Window.Hide (winID2)

%This section forwwards all procedures that need to be called by a GUI button (thats most of the procedures)
forward procedure mainMenu
forward procedure instructions
forward procedure userInput
forward procedure checker
forward procedure display
forward procedure check1
forward procedure check2
forward procedure check3
forward procedure reset
forward procedure levelFixer
forward procedure picReveal
forward procedure picHide
forward procedure playMusic
forward procedure stopMusic
forward procedure goodBye

%Global declaration section
var puzzle : int %declared for difficulty of puzzle
var x, y, b : int %used for mousewhere
var show : boolean := true %used to show puzzle
var stop1 : boolean := true %used to stop music
var display1, display2 : boolean := false %these two are used for if puzzle is correct or not
var hide : boolean := false %hides image
var play1 : boolean := false %plays music
var playme : boolean := false %decides whether music needs to be played or not
var button1, button2, button3, mainButton, buttonExit : int %these variables are used for buttons that lead to subprograms
var buttonShow, buttonHide : int %these two hide and show the puzzle image
var boxX1, boxX4, boxX8, boxX15, boxX2, boxX9, boxX14, boxX16, boxX3, boxX6, boxX11, boxX12, boxX5, boxX7, boxX10, boxX13, boxY4, boxY9, boxY11, boxY13, boxY1, boxY6,
    boxY7, boxY14, boxY2, boxY5, boxY12, boxY15, boxY3, boxY8, boxY10, boxY16 : int %These 32 variables are used to set the location of the bottom left corner of the puzzle pieces
var c, ex : int := 0 %Sets the x location of title and the background
%Import backgrounds and overall puzzle pictures
var picture1 : int := Pic.FileNew ("7070heart.jpg")
var picture2 : int := Pic.FileNew ("7070bird copy.jpeg")
var picture3 : int := Pic.FileNew ("7070candy.jpg")
var picBackground : int := Pic.FileNew ("background.jpg")
var picBackground2 : int := Pic.FileNew ("background2.jpg")
var picBackground3 : int := Pic.FileNew ("background3.jpg")

/***********************************************************
 *                    --Program Title--                    *
 *Used to clear the screen and write the title at the top  *
 *                       of the page                       *
 ***********************************************************/
procedure title
    %Declare font used to write the title
    var font1 : int := Font.New ("Comic Sans:20")
    %This if statement is used to set different backgrounds under the title
    if c = -1 then
	cls
	Pic.Draw (picBackground, 0, 0, picMerge)
    elsif c = -2 then
	cls
	Pic.Draw (picBackground2, 0, 0, picMerge)
    elsif c = -3 then
	cls
	Pic.Draw (picBackground3, 0, 0, picMerge)
    else
	drawfillbox (0, 0, 700, 400, c)
    end if
    Font.Draw ("Puzzles", ex, 360, font1, 36)
end title

/***********************************************************
 *                --Program Introduction--                 *
 *  Used to animate the introduction and leads to mainMenu *
 ***********************************************************/
procedure introduction
    Window.SetActive (winID)
    setscreen ("offscreenonly")
    ex := 300 %Redeclares the variable that sets where the title is on the screen
    Music.PlayFileLoop ("SuperMario.mp3")
    %intro animations
    for x : 0 .. 400
	c := x div 4 + 8
	title
	drawfillbox (350, -300 + x, 450, -200 + x, 10)
	drawfilloval (400, -320 + x, 20, 20, 10)
	drawfilloval (470, -250 + x, 20, 20, 10)
	drawfilloval (400, -220 + x, 20, 20, x div 4 + 8)
	drawfilloval (370, -250 + x, 20, 20, x div 4 + 8)
	drawfillbox (-150 + x, 100, -50 + x, 200, 6)
	drawfilloval (-170 + x, 150, 20, 20, 6)
	drawfilloval (-30 + x, 150, 20, 20, 6)
	drawfilloval (-100 + x, 120, 20, 20, x div 4 + 8)
	drawfilloval (-100 + x, 180, 20, 20, x div 4 + 8)
	drawfillbox (750 - x, 200, 850 - x, 300, 8)
	drawfilloval (800 - x, 320, 20, 20, 8)
	drawfilloval (800 - x, 180, 20, 20, 8)
	drawfilloval (770 - x, 250, 20, 20, x div 4 + 8)
	drawfilloval (830 - x, 250, 20, 20, x div 4 + 8)
	drawfillbox (250, 600 - x, 350, 700 - x, 9)
	drawfilloval (300, 580 - x, 20, 20, 9)
	drawfilloval (370, 650 - x, 20, 20, 9)
	drawfilloval (300, 680 - x, 20, 20, x div 4 + 8)
	drawfilloval (270, 650 - x, 20, 20, x div 4 + 8)
	delay (12)
	View.Update
    end for
    setscreen ("nooffscreenonly")
    mainButton := GUI.CreateButton (305, 190, 0, "Main Menu", mainMenu)
    GUI.SetColor (mainButton, 35)
end introduction

/***********************************************************
 *                  --Program Main Menu--                  *
 *This is the control centre of the game which leads to any*
 *             puzzle,instructions, or goodbye             *
 ***********************************************************/
body procedure mainMenu
    Window.Hide (winID)
    Window.Show (winID3)
    Window.SetActive (winID3)
    %Main menu local declaration section
    var buttonInstruct, font6, font7 : int
    font6 := Font.New ("Lucida Calligraphy:30")
    font7 := Font.New ("Lucida Calligraphy:10")
    picture1 := Pic.Scale (picture1, 150, 150)
    picture2 := Pic.Scale (picture2, 150, 150)
    ex := 300 %sets title location
    c := -1 %sets background
    GUI.Hide (mainButton)
    %This if structure is used to only stop and start the music when it isnt already playiong
    if playme = false then
	Music.PlayFileStop
	Music.PlayFileLoop ("main music.mp3")
    else
	playme := false %redeclares playme to false so that next main menu will still work
    end if
    title
    var pictures : array 1 .. 3 of int
    pictures (1) := picture1
    pictures (2) := picture2
    pictures (3) := picture3
    Font.Draw ("Click the picture to select a level.", 245, 330, font7, 48)
    %These are the names and buttons for puzzle levels and other procedures for the main menu
    Font.Draw ("Easy", 90, 280, font6, 48)
    button1 := GUI.CreatePictureButton (60, 100, pictures (1), check1)
    GUI.SetColor (button1, 113)
    Font.Draw ("Medium", 275, 280, font6, 40)
    button2 := GUI.CreatePictureButton (270, 100, pictures (2), check2)
    GUI.SetColor (button2, 8)
    Font.Draw ("Hard", 510, 280, font6, 23)
    button3 := GUI.CreatePictureButton (480, 100, pictures (3), check3)
    GUI.SetColor (button3, 14)
    buttonInstruct := GUI.CreateButton (240, 50, 0, "Instructions", instructions)
    GUI.SetColor (buttonInstruct, 36)
    buttonExit := GUI.CreateButton (340, 50, 0, "Exit", GUI.Quit)
    GUI.SetColor (buttonExit, 48)
end mainMenu

/***********************************************************
 *                  Program Instructions                   *
 *This is a tool that the user can use to learn how to play*
 *     the game and it can lead back to mainMenu only      *
 ***********************************************************/
body procedure instructions
    Window.Hide (winID3)
    Window.Show (winID)
    Window.SetActive (winID)
    var font2, font5 : int %declares two seperate fonts
    font2 := Font.New ("Comic Sans:15")
    font5 := Font.New ("Rockwell Extra Bold:25")
    playme := true %makes it so that the music will start when you return to main menu
    var picture4 : int := Pic.FileNew ("instructions.jpg")
    ex := 300 %sets title 'x' location
    c := -3 %sets background colour
    title
    Font.Draw ("This is an interactive puzzle game that allows you to drag any piece and move it", 0, 330, font2, 11)
    Font.Draw ("to another location. Once the pieces are in the correct location you can click", 0, 300, font2, 11)
    Font.Draw ("finished. The screen will then switch to display where you will learn if you", 0, 270, font2, 11)
    Font.Draw ("solved it correctly or not.", 0, 240, font2, 11)
    Font.Draw ("drag", 370, 130, font5, 35)
    Font.Draw ("and", 400, 100, font5, 36)
    Font.Draw ("drop", 430, 70, font5, 37)
    Pic.Draw (picture4, 10, 10, picCopy)
    %draws the arrow for instructing user
    for x : 0 .. 30
	drawline (50, 50, 170, 150, 7)
	drawline (50, 50 + x, 50 + x, 50, 7)
    end for
    mainButton := GUI.CreateButton (550, 100, 0, "Main Menu", mainMenu)
    GUI.SetColor (mainButton, 48)
end instructions

/***********************************************************
 *                   Program User Input                    *
 *This is where the user can try to do a puzzle and either *
 * reset or finish the puzzle,finish will lead to display  *
 * and the output will vary if it is correct or not...You  *
 * can also reveal/hide the photo or stop/start the music  *
 ***********************************************************/
body procedure userInput
    Window.Hide (winID)
    Window.Show (winID1)
    Window.SetActive (winID1)
    setscreen ("offscreenonly")
    var buttonFinish, buttonReset : int %These two variables are used for buttons at the bottom right hand corner of the screen
    var isDragged1, isDragged2, isDragged3, isDragged4, isDragged5, isDragged6, isDragged7, isDragged8, isDragged9, isDragged10, isDragged11, isDragged12,
	isDragged13, isDragged14, isDragged15, isDragged16 : boolean := false %These variables are later used to decipher which puzzle piece the user wants to drag
    %The next 48 variables are used to import the photos for the puzzle pieces
    var picID1_1 : int := Pic.FileNew ("heart13.jpg")
    var picID1_2 : int := Pic.FileNew ("heart14.jpg")
    var picID1_3 : int := Pic.FileNew ("heart15.jpg")
    var picID1_4 : int := Pic.FileNew ("heart16.jpg")
    var picID1_5 : int := Pic.FileNew ("heart9.jpg")
    var picID1_6 : int := Pic.FileNew ("heart10.jpg")
    var picID1_7 : int := Pic.FileNew ("heart11.jpg")
    var picID1_8 : int := Pic.FileNew ("heart12.jpg")
    var picID1_9 : int := Pic.FileNew ("heart5.jpg")
    var picID1_10 : int := Pic.FileNew ("heart6.jpg")
    var picID1_11 : int := Pic.FileNew ("heart7.jpg")
    var picID1_12 : int := Pic.FileNew ("heart8.jpg")
    var picID1_13 : int := Pic.FileNew ("heart1.jpg")
    var picID1_14 : int := Pic.FileNew ("heart2.jpg")
    var picID1_15 : int := Pic.FileNew ("heart3.jpg")
    var picID1_16 : int := Pic.FileNew ("heart4.jpg")
    var picID2_1 : int := Pic.FileNew ("bird13.jpeg")
    var picID2_2 : int := Pic.FileNew ("bird14.jpeg")
    var picID2_3 : int := Pic.FileNew ("bird15.jpeg")
    var picID2_4 : int := Pic.FileNew ("bird2.16.jpg")
    var picID2_5 : int := Pic.FileNew ("bird9.jpeg")
    var picID2_6 : int := Pic.FileNew ("bird10.jpeg")
    var picID2_7 : int := Pic.FileNew ("bird11.jpeg")
    var picID2_8 : int := Pic.FileNew ("bird2.12.jpg")
    var picID2_9 : int := Pic.FileNew ("bird5.jpeg")
    var picID2_10 : int := Pic.FileNew ("bird6.jpeg")
    var picID2_11 : int := Pic.FileNew ("bird7.jpeg")
    var picID2_12 : int := Pic.FileNew ("bird2.8.jpg")
    var picID2_13 : int := Pic.FileNew ("bird1.jpeg")
    var picID2_14 : int := Pic.FileNew ("bird2.jpeg")
    var picID2_15 : int := Pic.FileNew ("bird3.jpeg")
    var picID2_16 : int := Pic.FileNew ("bird4.jpeg")
    var picID3_1 : int := Pic.FileNew ("candy13.jpg")
    var picID3_2 : int := Pic.FileNew ("candy14.jpg")
    var picID3_3 : int := Pic.FileNew ("candy15.jpg")
    var picID3_4 : int := Pic.FileNew ("candy16.jpg")
    var picID3_5 : int := Pic.FileNew ("candy9.jpg")
    var picID3_6 : int := Pic.FileNew ("candy10.jpg")
    var picID3_7 : int := Pic.FileNew ("candy11.jpg")
    var picID3_8 : int := Pic.FileNew ("candy12.jpg")
    var picID3_9 : int := Pic.FileNew ("candy5.jpg")
    var picID3_10 : int := Pic.FileNew ("candy6.jpg")
    var picID3_11 : int := Pic.FileNew ("candy7.jpg")
    var picID3_12 : int := Pic.FileNew ("candy8.jpg")
    var picID3_13 : int := Pic.FileNew ("candy1.jpg")
    var picID3_14 : int := Pic.FileNew ("candy2.jpg")
    var picID3_15 : int := Pic.FileNew ("candy3.jpg")
    var picID3_16 : int := Pic.FileNew ("candy4.jpg")
    ex := 150 %redeclares where the title is placed on the screen
    c := -2 %redeclares what background is displayed
    title
    View.Update
    loop
	mousewhere (x, y, b) %tracks the mouse on the screen
	%these four if statements set the perameters for the dragging...they need to be seperated because two could be true at the same time
	if x <= 37 then
	    x := 39
	end if
	if x >= 663 then
	    x := 661
	end if
	if y <= 37 then
	    y := 39
	end if
	if y >= 363 then
	    y := 361
	end if
	%This if statement makes sure no two pieces can be dragged at the same time saving the user from confusion
	if isDragged1 = false and isDragged2 = false and isDragged3 = false and isDragged4 = false and isDragged5 = false and isDragged6 = false and isDragged7 = false
		and isDragged8 = false and isDragged9 = false and isDragged10 = false and isDragged11 = false and isDragged12 = false and isDragged13 = false
		and isDragged14 = false and isDragged15 = false and isDragged16 = false then
	    %This if structure declares which box is being dragged by setting the perameters of the box
	    if x >= boxX1 and x <= boxX1 + 70 and y >= boxY1 and y <= boxY1 + 70 and b = 1 then
		isDragged1 := true
	    elsif x >= boxX2 and x <= boxX2 + 70 and y >= boxY2 and y <= boxY2 + 70 and b = 1 then
		isDragged2 := true
	    elsif x >= boxX3 and x <= boxX3 + 70 and y >= boxY3 and y <= boxY3 + 70 and b = 1 then
		isDragged3 := true
	    elsif x >= boxX4 and x <= boxX4 + 70 and y >= boxY4 and y <= boxY4 + 70 and b = 1 then
		isDragged4 := true
	    elsif x >= boxX5 and x <= boxX5 + 70 and y >= boxY5 and y <= boxY5 + 70 and b = 1 then
		isDragged5 := true
	    elsif x >= boxX6 and x <= boxX6 + 70 and y >= boxY6 and y <= boxY6 + 75 and b = 1 then
		isDragged6 := true
	    elsif x >= boxX7 and x <= boxX7 + 70 and y >= boxY7 and y <= boxY7 + 70 and b = 1 then
		isDragged7 := true
	    elsif x >= boxX8 and x <= boxX8 + 70 and y >= boxY8 and y <= boxY8 + 70 and b = 1 then
		isDragged8 := true
	    elsif x >= boxX9 and x <= boxX9 + 70 and y >= boxY9 and y <= boxY9 + 70 and b = 1 then
		isDragged9 := true
	    elsif x >= boxX10 and x <= boxX10 + 70 and y >= boxY10 and y <= boxY10 + 70 and b = 1 then
		isDragged10 := true
	    elsif x >= boxX11 and x <= boxX11 + 70 and y >= boxY11 and y <= boxY11 + 70 and b = 1 then
		isDragged11 := true
	    elsif x >= boxX12 and x <= boxX12 + 70 and y >= boxY12 and y <= boxY12 + 70 and b = 1 then
		isDragged12 := true
	    elsif x >= boxX13 and x <= boxX13 + 70 and y >= boxY13 and y <= boxY13 + 70 and b = 1 then
		isDragged13 := true
	    elsif x >= boxX14 and x <= boxX14 + 70 and y >= boxY14 and y <= boxY14 + 70 and b = 1 then
		isDragged14 := true
	    elsif x >= boxX15 and x <= boxX15 + 70 and y >= boxY15 and y <= boxY15 + 70 and b = 1 then
		isDragged15 := true
	    elsif x >= boxX16 and x <= boxX16 + 70 and y >= boxY16 and y <= boxY16 + 70 and b = 1 then
		isDragged16 := true
	    end if
	end if
	%This if structure centers the selected piece around the mouse to move them
	if isDragged1 = true then
	    boxX1 := x - 35
	    boxY1 := y - 35
	elsif isDragged2 = true then
	    boxX2 := x - 35
	    boxY2 := y - 35
	elsif isDragged3 = true then
	    boxX3 := x - 35
	    boxY3 := y - 35
	elsif isDragged4 = true then
	    boxX4 := x - 35
	    boxY4 := y - 35
	elsif isDragged5 = true then
	    boxX5 := x - 35
	    boxY5 := y - 35
	elsif isDragged6 = true then
	    boxX6 := x - 35
	    boxY6 := y - 35
	elsif isDragged7 = true then
	    boxX7 := x - 35
	    boxY7 := y - 35
	elsif isDragged8 = true then
	    boxX8 := x - 35
	    boxY8 := y - 35
	elsif isDragged9 = true then
	    boxX9 := x - 35
	    boxY9 := y - 35
	elsif isDragged10 = true then
	    boxX10 := x - 35
	    boxY10 := y - 35
	elsif isDragged11 = true then
	    boxX11 := x - 35
	    boxY11 := y - 35
	elsif isDragged12 = true then
	    boxX12 := x - 35
	    boxY12 := y - 35
	elsif isDragged13 = true then
	    boxX13 := x - 35
	    boxY13 := y - 35
	elsif isDragged14 = true then
	    boxX14 := x - 35
	    boxY14 := y - 35
	elsif isDragged15 = true then
	    boxX15 := x - 35
	    boxY15 := y - 35
	elsif isDragged16 = true then
	    boxX16 := x - 35
	    boxY16 := y - 35
	end if
	delay (3)
	%resets the dragged variables if you release piece so that piece does not stayt selected
	if b = 0 then
	    isDragged1 := false
	    isDragged2 := false
	    isDragged3 := false
	    isDragged4 := false
	    isDragged5 := false
	    isDragged6 := false
	    isDragged7 := false
	    isDragged8 := false
	    isDragged9 := false
	    isDragged10 := false
	    isDragged11 := false
	    isDragged12 := false
	    isDragged13 := false
	    isDragged14 := false
	    isDragged15 := false
	    isDragged16 := false
	end if
	%Puzzle border
	title
	Draw.ThickLine (49, 49, 49, 330, 2, 7)
	Draw.ThickLine (49, 330, 330, 330, 2, 7)
	Draw.ThickLine (330, 330, 330, 49, 2, 7)
	Draw.ThickLine (330, 49, 49, 49, 2, 7)
	%this if structure draws different pictures depending on what puzzle is selected
	if puzzle = 1 then
	    %draws grid
	    drawline (120, 50, 120, 330, 7)
	    drawline (190, 50, 190, 330, 7)
	    drawline (260, 50, 260, 330, 7)
	    drawline (50, 120, 330, 120, 7)
	    drawline (50, 190, 330, 190, 7)
	    drawline (50, 260, 330, 260, 7)
	    %draws puzzle pieces for puzzle 1
	    Pic.Draw (picID1_1, boxX1, boxY1, picCopy)
	    Pic.Draw (picID1_2, boxX2, boxY2, picCopy)
	    Pic.Draw (picID1_3, boxX3, boxY3, picCopy)
	    Pic.Draw (picID1_4, boxX4, boxY4, picCopy)
	    Pic.Draw (picID1_5, boxX5, boxY5, picCopy)
	    Pic.Draw (picID1_6, boxX6, boxY6, picCopy)
	    Pic.Draw (picID1_7, boxX7, boxY7, picCopy)
	    Pic.Draw (picID1_8, boxX8, boxY8, picCopy)
	    Pic.Draw (picID1_9, boxX9, boxY9, picCopy)
	    Pic.Draw (picID1_10, boxX10, boxY10, picCopy)
	    Pic.Draw (picID1_11, boxX11, boxY11, picCopy)
	    Pic.Draw (picID1_12, boxX12, boxY12, picCopy)
	    Pic.Draw (picID1_13, boxX13, boxY13, picCopy)
	    Pic.Draw (picID1_14, boxX14, boxY14, picCopy)
	    Pic.Draw (picID1_15, boxX15, boxY15, picCopy)
	    Pic.Draw (picID1_16, boxX16, boxY16, picCopy)
	elsif puzzle = 2 then
	    %draws puzzle pieces for puzzle 2
	    Pic.Draw (picID2_1, boxX1, boxY1, picCopy)
	    Pic.Draw (picID2_2, boxX2, boxY2, picCopy)
	    Pic.Draw (picID2_3, boxX3, boxY3, picCopy)
	    Pic.Draw (picID2_4, boxX4, boxY4, picCopy)
	    Pic.Draw (picID2_5, boxX5, boxY5, picCopy)
	    Pic.Draw (picID2_6, boxX6, boxY6, picCopy)
	    Pic.Draw (picID2_7, boxX7, boxY7, picCopy)
	    Pic.Draw (picID2_8, boxX8, boxY8, picCopy)
	    Pic.Draw (picID2_9, boxX9, boxY9, picCopy)
	    Pic.Draw (picID2_10, boxX10, boxY10, picCopy)
	    Pic.Draw (picID2_11, boxX11, boxY11, picCopy)
	    Pic.Draw (picID2_12, boxX12, boxY12, picCopy)
	    Pic.Draw (picID2_13, boxX13, boxY13, picCopy)
	    Pic.Draw (picID2_14, boxX14, boxY14, picCopy)
	    Pic.Draw (picID2_15, boxX15, boxY15, picCopy)
	    Pic.Draw (picID2_16, boxX16, boxY16, picCopy)
	elsif puzzle = 3 then
	    %draws puzzle pieces for puzzle 3
	    Pic.Draw (picID3_1, boxX1, boxY1, picCopy)
	    Pic.Draw (picID3_2, boxX2, boxY2, picCopy)
	    Pic.Draw (picID3_3, boxX3, boxY3, picCopy)
	    Pic.Draw (picID3_4, boxX4, boxY4, picCopy)
	    Pic.Draw (picID3_5, boxX5, boxY5, picCopy)
	    Pic.Draw (picID3_6, boxX6, boxY6, picCopy)
	    Pic.Draw (picID3_7, boxX7, boxY7, picCopy)
	    Pic.Draw (picID3_8, boxX8, boxY8, picCopy)
	    Pic.Draw (picID3_9, boxX9, boxY9, picCopy)
	    Pic.Draw (picID3_10, boxX10, boxY10, picCopy)
	    Pic.Draw (picID3_11, boxX11, boxY11, picCopy)
	    Pic.Draw (picID3_12, boxX12, boxY12, picCopy)
	    Pic.Draw (picID3_13, boxX13, boxY13, picCopy)
	    Pic.Draw (picID3_14, boxX14, boxY14, picCopy)
	    Pic.Draw (picID3_15, boxX15, boxY15, picCopy)
	    Pic.Draw (picID3_16, boxX16, boxY16, picCopy)
	end if
	%These 16 if structures are used to snap the pieces to the grid
	if (boxX1 >= 40 and boxX1 <= 60) and (boxY1 >= 40 and boxY1 <= 60) then
	    boxX1 := 50
	    boxY1 := 50
	end if
	if (boxX2 >= 110 and boxX2 <= 130) and (boxY2 >= 40 and boxY2 <= 60) then
	    boxX2 := 120
	    boxY2 := 50
	end if
	if (boxX3 >= 180 and boxX3 <= 200) and (boxY3 >= 40 and boxY3 <= 60) then
	    boxX3 := 190
	    boxY3 := 50
	end if
	if (boxX4 >= 250 and boxX4 <= 270) and (boxY4 >= 40 and boxY4 <= 60) then
	    boxX4 := 260
	    boxY4 := 50
	end if
	if (boxX5 >= 40 and boxX5 <= 60) and (boxY5 >= 110 and boxY5 <= 130) then
	    boxX5 := 50
	    boxY5 := 120
	end if
	if (boxX6 >= 110 and boxX6 <= 130) and (boxY6 >= 110 and boxY6 <= 130) then
	    boxX6 := 120
	    boxY6 := 120
	end if
	if (boxX7 >= 180 and boxX7 <= 200) and (boxY7 >= 110 and boxY7 <= 130) then
	    boxX7 := 190
	    boxY7 := 120
	end if
	if (boxX8 >= 250 and boxX8 <= 270) and (boxY8 >= 110 and boxY8 <= 130) then
	    boxX8 := 260
	    boxY8 := 120
	end if
	if (boxX9 >= 40 and boxX9 <= 60) and (boxY9 >= 180 and boxY9 <= 200) then
	    boxX9 := 50
	    boxY9 := 190
	end if
	if (boxX10 >= 110 and boxX10 <= 130) and (boxY10 >= 180 and boxY10 <= 200) then
	    boxX10 := 120
	    boxY10 := 190
	end if
	if (boxX11 >= 180 and boxX11 <= 200) and (boxY11 >= 180 and boxY11 <= 200) then
	    boxX11 := 190
	    boxY11 := 190
	end if
	if (boxX12 >= 250 and boxX12 <= 270) and (boxY12 >= 180 and boxY12 <= 200) then
	    boxX12 := 260
	    boxY12 := 190
	end if
	if (boxX13 >= 40 and boxX13 <= 60) and (boxY13 >= 250 and boxY13 <= 270) then
	    boxX13 := 50
	    boxY13 := 260
	end if
	if (boxX14 >= 110 and boxX14 <= 130) and (boxY14 >= 250 and boxY14 <= 270) then
	    boxX14 := 120
	    boxY14 := 260
	end if
	if (boxX15 >= 180 and boxX15 <= 200) and (boxY15 >= 250 and boxY15 <= 270) then
	    boxX15 := 190
	    boxY15 := 260
	end if
	if (boxX16 >= 250 and boxX16 <= 270) and (boxY16 >= 250 and boxY16 <= 270) then
	    boxX16 := 260
	    boxY16 := 260
	end if
	buttonFinish := GUI.CreateButton (423, 10, 0, "Finish", checker)
	GUI.SetColor (buttonFinish, 13)
	buttonReset := GUI.CreateButton (350, 10, 0, "Reset", reset)
	GUI.SetColor (buttonReset, 48)
	%This if statement shows / hides the image and switches the button
	if hide = true then
	    buttonHide := GUI.CreateButton (600, 0, 0, "Hide Image", picHide)
	    GUI.SetColor (buttonHide, 40)
	elsif show = true then
	    buttonShow := GUI.CreateButton (600, 30, 0, "Show Image", picReveal)
	    GUI.SetColor (buttonShow, 9)
	end if
	%This if statement stops / starts the music and switches the button
	if play1 = true then
	    buttonHide := GUI.CreateButton (500, 0, 0, "Play Music", playMusic)
	    GUI.SetColor (buttonHide, 50)
	elsif stop1 = true then
	    buttonShow := GUI.CreateButton (500, 30, 0, "Stop Music", stopMusic)
	    GUI.SetColor (buttonShow, 45)
	end if
	delay (20)
	View.Update
	%This is used to exit the loop aswell as stop the music
	if GUI.ProcessEvent then
	    Music.PlayFileStop
	    exit
	end if
    end loop
end userInput

/***********************************************************
 *                     Program Checker                     *
 *  This procedure is used to check whether the puzzle is  *
 *   correct and then tells display by declaring either    *
 *                   diplay1 or display2                   *
 ***********************************************************/
body procedure checker
    setscreen ("nooffscreenonly")
    %This if statement is used to checker if every piece is right or not
    if (boxX1 = 50 and boxY1 = 50) and (boxX2 = 120 and boxY2 = 50) and (boxX3 = 190 and boxY3 = 50) and (boxX4 = 260 and boxY4 = 50) and (boxX5 = 50 and boxY5 = 120)
	    and (boxX6 = 120 and boxY6 = 120) and (boxX7 = 190 and boxY7 = 120) and (boxX8 = 260 and boxY8 = 120) and (boxX9 = 50 and boxY9 = 190)
	    and (boxX10 = 120 and boxY10 = 190) and (boxX11 = 190 and boxY11 = 190) and (boxX12 = 260 and boxY12 = 190) and (boxX13 = 50 and boxY13 = 260)
	    and (boxX14 = 120 and boxY14 = 260) and (boxX15 = 190 and boxY15 = 260) and (boxX16 = 260 and boxY16 = 260) then
	display1 := true %used to make it show the correct display
	display
    else
	display2 := true %Used to show the incorrect display
	display
    end if
end checker

/***********************************************************
 *                     Program Display                     *
 * This is where the user finds out if they are correct or *
 *not. This leads to mainMenu, userInput(same or different *
 *                   puzzle),or goodbye                    *
 ***********************************************************/
body procedure display
    picHide
    Window.Hide (winID1)
    Window.Show (winID)
    Window.SetActive (winID)
    var facefont : int %used for a font
    var playAgainButton, nextButton : int %used for two of the buttons
    facefont := Font.New ("Comic Sans:40")
    ex := 300 %redeclares where the title is placed on the screen
    %This if statement is used to decide which display to show
    if display1 = true then
	Music.PlayFileLoop ("that was easy.mp3")
	%Used to change the colours of graphics
	for x : 0 .. 68
	    c := 7 + x %redeclares what background is displayed
	    title
	    Font.Draw ("WOW! you did it.", 145, 250, facefont, x)
	    drawfillstar (20, 250, 70, 300, x)
	    drawfillstar (50, 220, 100, 270, x)
	    drawfillstar (60, 280, 110, 330, x)
	    drawfillstar (600, 250, 650, 300, x)
	    drawfillstar (570, 220, 620, 270, x)
	    drawfillstar (560, 290, 610, 340, x)
	    delay (25)
	end for
	Music.PlayFileStop
	c := -3 %redeclares what background is displayed
	title
	Font.Draw ("WOW! you did it.", 145, 250, facefont, 14)
	drawfillstar (20, 250, 70, 300, 14)
	drawfillstar (50, 220, 100, 270, 14)
	drawfillstar (60, 280, 110, 330, 14)
	drawfillstar (600, 250, 650, 300, 14)
	drawfillstar (570, 220, 620, 270, 14)
	drawfillstar (560, 290, 610, 340, 14)
	Music.PlayFileStop
    elsif display2 = true then
	Music.PlayFileLoop ("losing horn.mp3")
	for x : 0 .. 2
	    c := -1 %redeclares what background is displayed
	    title
	    Font.Draw ("Sorry, you got it wrong.", 60, 300, facefont, 40)
	    delay (600)
	    c := 40 %redeclares what background is displayed
	    title
	    Font.Draw ("Sorry, you got it wrong.", 60, 300, facefont, 45)
	    delay (600)
	end for
	c := -1 %redeclares what background is displayed
	title
	Font.Draw ("Sorry, you got it wrong.", 60, 300, facefont, 45)
	Music.PlayFileStop
    end if
    Music.PlayFileLoop ("main music.mp3")
    playme := true %redeclares playme to true so that next music will start again
    %These four buttons are so the user can select where to go after they finish the puzzle
    playAgainButton := GUI.CreateButton (100, 140, 0, "Play Again", reset)
    mainButton := GUI.CreateButton (250, 140, 0, "Main Menu", mainMenu)
    nextButton := GUI.CreateButton (400, 140, 0, "Next Puzzle", levelFixer)
    buttonExit := GUI.CreateButton (540, 140, 0, "Exit", GUI.Quit)
    %This if statement is to decide which colour the buttons in display will be
    if display1 = true then
	GUI.SetColor (playAgainButton, 52)
	GUI.SetColor (mainButton, 52)
	GUI.SetColor (nextButton, 52)
	GUI.SetColor (buttonExit, 52)
    elsif display2 = true then
	GUI.SetColor (playAgainButton, 45)
	GUI.SetColor (mainButton, 45)
	GUI.SetColor (nextButton, 45)
	GUI.SetColor (buttonExit, 45)
    end if
    %This loop is used because there are multiple buttons and will exit when one of them is pressed
    loop
	exit when GUI.ProcessEvent
    end loop
end display

/***********************************************************
 *                     Program Check1                      *
 *    This procedure selects puzzle easy and resets the    *
 *              location of the puzzle pieces              *
 ***********************************************************/
body procedure check1
    puzzle := 1 %makes it so the easy puzzle is used
    reset
end check1

/***********************************************************
 *                     Program Check2                      *
 *   This procedure selects puzzle medium and resets the   *
 *              location of the puzzle pieces              *
 ***********************************************************/
body procedure check2
    puzzle := 2 %makes it so the medium puzzle is used
    reset
end check2

/***********************************************************
 *                     Program Check3                      *
 *    This procedure selects puzzle hard and resets the    *
 *              location of the puzzle pieces              *
 ***********************************************************/
body procedure check3
    puzzle := 3 %makes it so the hard puzzle is used
    reset
end check3

/***********************************************************
 *                      Program Reset                      *
 *This procedure sets and resets the location of the puzzle*
 * pieces and resets whether the puzzle is correct or not  *
 ***********************************************************/
body procedure reset
    %These two variables neutralize rather the puzzle is correct or not
    display1 := false
    display2 := false
    %The next 16 variable redeclarations are used to reset the values of the puzzle piece locations
    boxX1 := 520
    boxX2 := 360
    boxX3 := 600
    boxX4 := 520
    boxX5 := 440
    boxX6 := 600
    boxX7 := 440
    boxX8 := 520
    boxX9 := 360
    boxX10 := 440
    boxX11 := 600
    boxX12 := 600
    boxX13 := 440
    boxX14 := 360
    boxX15 := 520
    boxX16 := 360
    boxY1 := 135
    boxY2 := 210
    boxY3 := 290
    boxY4 := 60
    boxY5 := 210
    boxY6 := 135
    boxY7 := 135
    boxY8 := 290
    boxY9 := 60
    boxY10 := 290
    boxY11 := 60
    boxY12 := 210
    boxY13 := 60
    boxY14 := 135
    boxY15 := 210
    boxY16 := 290
    userInput
end reset

/***********************************************************
 *                   Program Level Fixer                   *
 *  This procedure is called when next level is selected.  *
 *  This redeclares the value of puzzle and also gives an  *
 *     error message if you just did the hardest level     *
 ***********************************************************/
body procedure levelFixer
    var facefont1 : int := Font.New ("Britannic Bold:22") %Declares font used to write Hardest level message
    %This if statement is used to go to the next puzzle when the next puzzle button is pressed
    if puzzle = 1 then
	check2
    elsif puzzle = 2 then
	check3
    elsif puzzle = 3 then
	ex := 300 %redeclares where the title is placed on the screen
	c := -1 %redeclares what background is displayed
	title
	Font.Draw ("WoW you just did the hardest level!!", 110, 300, facefont1, 12)
	Font.Draw ("Go back to the main menu to choose a new game.", 40, 200, facefont1, 12)
	mainButton := GUI.CreateButton (305, 240, 0, "Main Menu", mainMenu) %Makes a button that redirects to main menu
	GUI.SetColor (mainButton, 40)
    end if
end levelFixer

/***********************************************************
 *                Program Picture Revealer                 *
 * This procedure opens a window beside userInput to show  *
 *              the final image of the puzzle              *
 ***********************************************************/
body procedure picReveal
    Window.Show (winID2)
    Window.SetActive (winID2)
    title
    %This if statement is used to decide which image to reveal
    if puzzle = 1 then
	Pic.Draw (picture1, 0, 0, picCopy)
    elsif puzzle = 2 then
	Pic.Draw (picture2, 0, 0, picCopy)
    elsif puzzle = 3 then
	Pic.Draw (picture3, 0, 0, picCopy)
    end if
    GUI.Disable (buttonShow)
    show := false %used to hide the show image button
    hide := true %used to show the hide image button
    Window.SetActive (winID1)
end picReveal

/***********************************************************
 *                  Program Picture Hider                  *
 * This procedure closes a window beside userInput to hide *
 *              the final image of the puzzle              *
 ***********************************************************/
body procedure picHide
    Window.Hide (winID2)
    Window.SetActive (winID1)
    hide := false %used to hide the hide image button
    show := true %used to show the show image button
end picHide

/***********************************************************
 *                  Program Music Stopper                  *
 *  This procedure stops the music that is playing in the  *
 *                       background                        *
 ***********************************************************/
body procedure stopMusic
    Window.SetActive (winID2)
    Music.PlayFileStop
    Window.SetActive (winID1)
    stop1 := false %used to hide the stop music button
    play1 := true %used to show the play music button
end stopMusic

/***********************************************************
 *                  Program Music Player                   *
 *This procedure restarts the music that is playing in the *
 *                       background                        *
 ***********************************************************/
body procedure playMusic
    Window.SetActive (winID2)
    Music.PlayFileLoop ("main music.mp3")
    Window.SetActive (winID1)
    play1 := false %used to hide the play music button
    stop1 := true %used to show the stop music button
end playMusic

/***********************************************************
 *                     Program Good Bye                    *
 *This is where I say farewell to the user and I countdown *
 *                       until exit                        *
 ***********************************************************/
body procedure goodBye
    Window.Hide (winID3)
    Window.Show (winID)
    Window.SetActive (winID)
    setscreen ("offscreenonly")
    var font3, font4 : int %used for fonts in goodbye
    var x, y : int %These two variables are used for the countdown in goodbye
    x := 49 %used to declare the second number to 1
    y := 49 %used to declare the first number to 1
    font3 := Font.New ("Comic Sans:20")
    font4 := Font.New ("Comic Sans:10")
    ex := 300 %redeclares where the title is placed on the screen
    c := -3 %redeclares what background is displayed
    Music.PlayFileLoop ("Thats all folks!.wav")
    %This loop is used to countdown until exit
    loop
	title
	x := x - 1 %This counter is used to countdown until exit
	%Used to reset the numbers to a space and '9' once the numbers hit ten
	if x = 47 then
	    x := 57 %redeclares second number to '9'
	    y := 32 %redeclares first number to a space
	end if
	%This array is used to allow a variable to be written in the font.Draw command
	var textstring : array 1 .. 3 of string
	textstring (1) := "I hope you enjoyed 'Puzzles' by Alex Barkin"
	textstring (2) := "This is my final ICS project for ICS-20."
	textstring (3) := "(This window will close in " + chr (y) + chr (x) + " seconds)"
	Font.Draw (textstring (1), 90, 300, font3, 52)
	Font.Draw (textstring (2), 120, 250, font3, 52)
	Font.Draw (textstring (3), 240, 220, font4, 52)
	View.Update
	delay (1000)
	exit when y = 32 and x = 48 %used to exit loop when the numbers are a space and a '0'
    end loop
    Music.PlayFileStop
    Window.Close (winID)
end goodBye

%Main Program
introduction
loop
    exit when GUI.ProcessEvent
end loop
Music.PlayFileStop
goodBye
%End program
