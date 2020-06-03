/*
This game consists of shooting a series of planets, which move from right (outside the frame) to left (outside the frame).

There are an unlimited number of levels of difficulty, with each level:

                  - increasing the velocity of the planets
                  
                  - incrementing the number of these planets 
                  
                  - decreasing the planet's size
                  
                  - allocating a reduced number of bullets to the player.

The player wins by shooting all the planets of each level.

The player loses if not all planets have been destroyed ***OR*** if the player exceeds the allocated number of bullets.

*/

import ddf.minim.*;
 
AudioPlayer song;
Minim minim;  
AudioSample shot, target_destroyed, last_laugh, added_sound;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//implementing an arraylist of class "Planets":
ArrayList<Planets> the_list;

//creating a temporary object of class "Planets":
Planets planet_obj;

int number_planets;
float valX;
float valY;
float planet_width;
float planet_height;
float velocityX;

float slotHeight;
float yPos;
float startY;

int slotSize;
int constSlotSize;
int level;

String current_level;
String number_of_planets;
String ammo;

float x, y;

float v_index1, v_index2;

int result;
int showInfo;

int timer;

int go;
int scroll_index;
boolean hitTarget;
int counter;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup(){
  
      //all sound clips:
      minim = new Minim(this);
      song  = minim.loadFile("01 Wild World.mp3");
      song.play();
      shot = minim.loadSample("Laser Shot 8.mp3");
      target_destroyed = minim.loadSample("Explosion+3.mp3");
      last_laugh = minim.loadSample("Laugh+2.mp3");
    
      size(800, 700);
      
      stroke(255, 0, 0);
      
      //starting number of planets (for level 1):
      number_planets = 2;
      
      //starting values for initial velocity of planets (level 1):
      v_index1 = 1;
      v_index2 = 1.25;
      
      //setting level index:
      level = 1;
                                          
      creating_planets();
      
      result = 0;
      
      showInfo = 0;
        
      number_of_planets = "planets to destroy = ";
      ammo = "ammo available = ";
      
      go = 0;
      
      scroll_index = 2;
      hitTarget=false;
      counter=30;
      
}

void draw(){
    
     if(go != 1){
    
         background(0, 0, 0);
     
         //this is to display the "retro" star pattern in the background:     
         retroStarPattern();
         
         //intro message:
         fill(246, 255, 5);
         textSize(23);
         textAlign(CENTER);
         text("Howdy!\n\nWelcome to:\n\nTHE DEADLY YELLOW PLANET EXTERMINATOR\n\n(Not for the faint-hearted.)\n\nRules of the game?\n\nSimple:\nit's a 'shoot-them-up'.\n\nJust left-click to fire away at the deadly and\nvery naughty yellow planets.\n\nBut beware!\nYou have limited ammo for each level!\n\n(By the way: you shoot these planets with a laser-gun,\njust so you know.)\n\n(That's right: a laser-gun.)\n\n(Problem? See if I care.)\n\nI can tell you can't wait to play.\n\nWanna play?\n\nSure?\n\nThen sit back,\nrelax,\nhave a beer,\nenjoy the Cat Stevens song,\nand press 'g' to start\n(as in: 'g' after 'f', yes, well done Einstein...)", width/2, height-scroll_index);
         go = startGame();
         scroll_index += 1;
    }
    
    else{
  
         background(0, 0, 0);
         
         //this is to display the "retro" star pattern in the background:     
         retroStarPattern();
         
         noCursor();
       
         for(int i = the_list.size()-1; i >= 0; i--) {
           
               //essential step: extracting each object of class "Planets" from the arraylist and assign it to our temp object of the same class:           
               planet_obj = the_list.get(i);
               
               //here: invoking two methods of class "Planets":           
               planet_obj.draw();
               planet_obj.move();  
               
               //this is to draw our rifle scope:
               if (!hitTarget)
                 rifleScope();
               else
                 shakingScope(); //--> if target is hit, scope jiggles
               
               turnOffHit(); //-->reset counter
    
               //checking for any ball disappearing to the left of the screen:          
               result = planet_obj.checkBall();
         } 
         
         if(result > 0){
           
             if(level == 1){
               
                 BIG_loser_page();
                 showInfo = 1;
             }        
             else{
               
                 LOSE_page1();
                 showInfo = 1;
             }
         }
         
         else if(planet_obj.getAmmo() == 0){
           
             if(level == 1){
               
                 BIG_loser_page();
                 showInfo = 1;
             }        
             else{
               
                 LOSE_page2();
                 showInfo = 1;
             }
         }
               
         else if(the_list.size() == 0){
    
             continue_game();
             level += 1;
         }
         
         //displaying info on bottom left corner of screen:
         if(showInfo == 0){
           
             show_LEVEL();
             show_current_num_planets();
             show_ammo_left();
         }     
    }         
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int startGame(){
  
  if(key == 'g')
      return 1;
      
  else
      return 0;
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void creating_planets(){
  
      the_list = new ArrayList();
      
      slotHeight = height/number_planets;

      startY = yPos = slotHeight/2; 
                                      
      for(int i=0; i<number_planets; i++){
        
           planet_height = random(10, slotHeight);
           planet_width = planet_height;
             
           valX = random(width+10, width+400);
           valY = random(yPos, startY*number_planets);
           
           velocityX = random(v_index1, v_index2);
                
           the_list.add(new Planets(valX, valY, planet_width, planet_height, velocityX, number_planets)); 
           
           yPos += slotHeight;               
      }      
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void retroStarPattern(){
  
     fill(255, 255, 255);  
     x = random(1, width-1);
     y = random(1, height-1);
     ellipse(x, y, 7, 7);  
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void rifleScope(){
  
     stroke(255, 0, 0);
  
     //both vertical lines:
     strokeWeight(2);
     line(mouseX, mouseY-75, mouseX, mouseY-15);
     line(mouseX, mouseY+15, mouseX, mouseY+75);
     //its added thick lines:
     strokeWeight(8);
     line(mouseX, mouseY-48, mouseX, mouseY-40);
     line(mouseX, mouseY+40, mouseX, mouseY+48);
     //its thin little horizontal lines:
     strokeWeight(2);
     line(mouseX-5, mouseY-29, mouseX+5, mouseY-29);
     line(mouseX-3, mouseY-22, mouseX+3, mouseY-22);
     line(mouseX-3, mouseY+22, mouseX+3, mouseY+22);
     line(mouseX-5, mouseY+29, mouseX+5, mouseY+29);

   
     //both horizontal lines:
     strokeWeight(2);
     line(mouseX-75, mouseY, mouseX-15, mouseY);
     line(mouseX+15, mouseY, mouseX+75, mouseY);
     //its added thick lines:
     strokeWeight(8);
     line(mouseX-48, mouseY, mouseX-40, mouseY);
     line(mouseX+40, mouseY, mouseX+48, mouseY);
     //its thin little vertical lines:
     strokeWeight(2);
     line(mouseX-29, mouseY-5, mouseX-29, mouseY+5);
     line(mouseX-22, mouseY-3, mouseX-22, mouseY+3);
     line(mouseX+22, mouseY-3, mouseX+22, mouseY+3);
     line(mouseX+29, mouseY-5, mouseX+29, mouseY+5);
     
     noFill();
     strokeWeight(2);
     ellipse(mouseX, mouseY, 100, 100); 
}

void shakingScope(){
  
     stroke(255, 0, 0);
     
     //both vertical lines:
     strokeWeight(3);
     line(mouseX+random(-4,4), mouseY-75+random(-4,4), mouseX+random(-4,4), mouseY-15+random(-4,4));
     line(mouseX+random(-4,4), mouseY+15+random(-4,4), mouseX, mouseY+75+random(-4,4));
     //its added thick lines:
     strokeWeight(8);
     line(mouseX+random(-4,4), mouseY-48+random(-4,4), mouseX+random(-4,4), mouseY-40+random(-4,4));
     line(mouseX+random(-4,4), mouseY+40+random(-4,4), mouseX+random(-4,4), mouseY+48+random(-4,4));
     //its thin little horizontal lines:
     strokeWeight(2);
     line(mouseX-5+random(-1,1), mouseY-29+random(-1,1), mouseX+5+random(-1,1), mouseY-29+random(-1,1));
     line(mouseX-3+random(-1,1), mouseY-22+random(-1,1), mouseX+3+random(-1,1), mouseY-22+random(-1,1));
     line(mouseX-3+random(-1,1), mouseY+22+random(-1,1), mouseX+3+random(-1,1), mouseY+22+random(-1,1));
     line(mouseX-5+random(-1,1), mouseY+29+random(-1,1), mouseX+5+random(-1,1), mouseY+29+random(-1,1));

   
     //both horizontal lines:
     strokeWeight(2);
     line(mouseX-75+random(-4,4), mouseY+random(-4,4), mouseX-15+random(-4,4), mouseY+random(-4,4));
     line(mouseX+15+random(-4,4), mouseY+random(-4,4), mouseX+75+random(-4,4), mouseY+random(-4,4));
     //its added thick lines:
     strokeWeight(8);
     line(mouseX-48+random(-4,4), mouseY+random(-4,4), mouseX-40+random(-4,4), mouseY+random(-4,4));
     line(mouseX+40+random(-4,4), mouseY+random(-4,4), mouseX+48+random(-4,4), mouseY+random(-4,4));
     //its thin little vertical lines:
     strokeWeight(2);
     line(mouseX-29+random(-1,1), mouseY-5+random(-1,1), mouseX-29+random(-1,1), mouseY+5+random(-1,1));
     line(mouseX-22+random(-1,1), mouseY-3+random(-1,1), mouseX-22+random(-1,1), mouseY+3+random(-1,1));
     line(mouseX+22+random(-1,1), mouseY-3+random(-1,1), mouseX+22+random(-1,1), mouseY+3+random(-1,1));
     line(mouseX+29+random(-1,1), mouseY-5+random(-1,1), mouseX+29+random(-1,1), mouseY+5+random(-1,1));
     
     noFill();
     strokeWeight(3);
     ellipse(mouseX+random(-5,5), mouseY+random(-5,5), 100, 100);
     
     counter--;
  
}

void turnOffHit(){
  
    if (counter == 0){
      
      hitTarget=false;
      counter = 30;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void BIG_loser_page(){ //for player who can't even pass level 1!
  
      song.pause();
      
      last_laugh.trigger();
  
     //first: deleting ALL remaining planets:
     for(int i = 0; i < the_list.size(); i++)
         the_list.remove(i);
  
     background(153, 175, 32);
     textSize(19);
     textAlign(CENTER);
     fill(0, 0, 0);
     text("You're kidding, right...?.\nYou failed to pass level " + level + ".\nI mean...\nI'm simply lost for words.", width/2, height/2-70); 
     
     sad_face();
     
     noLoop();
}


void LOSE_page1(){ //in the case where a planet has not been destroyed

      song.pause();
      
      last_laugh.trigger();
  
     //first: deleting ALL remaining planets:
     for(int i = 0; i < the_list.size(); i++)
         the_list.remove(i);
  
     background(86, 242, 92);
     textSize(19);
     textAlign(CENTER);
     fill(0, 0, 0);
     text("Oops! Game over.\nYeah ok, you reached level " + level + ", big deal.\nBye now.", width/2, height/2-70); 
     
     sad_face();
     
     noLoop();
}

void LOSE_page2(){ //if player runs out of ammo

      song.pause();
      
      last_laugh.trigger();
  
     //first: deleting ALL remaining planets:
     for(int i = 0; i < the_list.size(); i++)
         the_list.remove(i);
  
     background(86, 242, 92);
     textSize(19);
     textAlign(CENTER);
     fill(0, 0, 0);
     text("Oops! Game over.\nYou wasted all your ammo,\nby firing away like a maniac.\nSo in the end, you reached level " + level + ", whatever.\nBye now.", width/2, height/2-70); 
     
     sad_face();
     
     noLoop();
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void show_LEVEL(){
  
     textSize(20);
     textAlign(LEFT);
     fill(2, 234, 221);
     text("LEVEL = " + level + "", 5, height-50);    
}

void show_current_num_planets(){
  
     textSize(20);
     textAlign(LEFT);
     fill(2, 234, 221);
     text(number_of_planets, 5, height-30);
     fill(2, 234, 221);
     text(the_list.size(), 208, height-30);  
}

void show_ammo_left(){
  
     textSize(20);
     textAlign(LEFT);
     fill(2, 234, 221);
     text(ammo, 5, height-10);
     fill(2, 234, 221);
     text(planet_obj.showBulletsLeft(), 186, height-10);  
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void continue_game(){
  
    number_planets += 1;
    v_index1 += 0.25;
    v_index2 += 0.25;
  
    creating_planets();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void mousePressed(){
  
   if(go == 1){
        
       for(int i = 0; i < the_list.size(); i++) {
    
             planet_obj = the_list.get(i); 
             
             float distance = dist(planet_obj.getX(), planet_obj.getY(), mouseX, mouseY);
             
             if(distance <= planet_obj.getPlanetWidth()){
               
                   target_destroyed.trigger();
                   planet_obj.decrease_ammo();              
                   the_list.remove(i);
                   hitTarget = true;
    
             }        
             else{
               
                 shot.trigger();
                 planet_obj.decrease_ammo(); 
             }
       }   
   }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void sad_face(){
  
     //face:
     fill(255, 248, 31);
     ellipse(width/2, 450, 50, 50);
     
     //left eye:
     fill(0, 0, 0);
     ellipse(width/2 - 8, 442, 4, 11);
     
     //right eye:
     fill(0, 0, 0);
     ellipse(width/2 + 8, 442, 4, 11);
     
     //sad mouth:
     stroke(0, 0, 0);
     strokeWeight(3);
     noFill();
     arc(width/2, 464, 16, 16, PI, TWO_PI);
}