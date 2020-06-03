
class Planets{

    float _x;
    float _y;
    float _planet_width;
    float _planet_height;
    float _d;
    float _speed;          
    int _num_bullets;
    int _answer;
   
    //6-argument constructor: 
    Planets(float vX, float vY, float p_width, float p_height, float velocity_index, int n_planets){
                
          _x = vX;  
          _y = vY;
          _planet_width = p_width;
          _planet_height = p_height;
          _speed = velocity_index;
          _num_bullets = n_planets + 5;
          _answer = 0;
    }

    void draw(){
          
        stroke(0, 0, 0);
        strokeWeight(1);
        fill(240, 252, 107);
        ellipse(_x, _y, _planet_width, _planet_height);
    }
       
    void move(){
    
       _x -= _speed;
    }
    
    void decrease_ammo(){
      
      _num_bullets -= 1;
    }
    
    int showBulletsLeft(){
      
      return _num_bullets;     
    }
    
    float getX(){
      
      return _x;
    }

    float getY(){
      
      return _y;
    }
    
    float getPlanetWidth(){
      
      return _planet_width;
    }
    
    int getAmmo(){
      
      return _num_bullets;
    }
    
    int checkBall(){ //this method checks whether the centre of a planet has crossed the X axis of the main frame
      
        if(_x <= -(_planet_width/2)){
          
            _answer = 1;            
            return _answer;
        }
        
        else{
          
            _answer = 0;         
            return _answer;
        }         
    }

////////////////////////////////////////////////  END OF CLASS  ////////////////////////////////////////////////////////////////
}