int percentage = 8;
int maxPlayerStress = 100;

int sidebarX = 800;
boolean gameRunning = false;
int currentQuoteIndex = 0; 

class Shape {
  float xpos;
  float ypos;
  float size;
  
  Shape(float x, float y, float s)
  {
    xpos = x; 
    ypos = y;
    size = s;
  }
}


class Person extends Shape {
  
 // this is a really bad model but no cathedrals
 boolean isMinority;
 
 // maybe factor stress level in somewhere?
 float speed;
 
 // between 0 and 100
 float stress;
 
 color c;
 // is this the player object?
 boolean isPlayer;
 
 int points; 
 
 Person(boolean isPlayer_)
 {
   super(random(sidebarX - 30), random(height - 20), 30);
   boolean isMinority_ = (random(100) < percentage); 
   _init(isMinority_, isPlayer_);
 }
 
 Person(boolean isMinority_, boolean isPlayer_)
 {
   super(random(sidebarX - 30), random(height - 20), 30);
   _init(isMinority_, isPlayer_);
 }
 
 private void _init(boolean isMinority_, boolean isPlayer_)
 {
   c = (isMinority_) ? color(231, 153, 74) : color(74, 152, 231);
   speed = random(6);
   
   stress = (isMinority) ? random(100) : random(50);
   
   isPlayer = isPlayer_;
   points = 0; 
 }
 
  
 void display()
 {
   display(xpos, ypos);
 }
 
 void display(float x, float y)
 {
   fill(c);
   stroke(0);
   size = 10 + 0.23 * (stress);
   if(!isPlayer)
   {
     ellipse(x, y, size, size);
   }
   else
   {
     rect(x, y, size, size);
   }
 }
 
 void move()
 {
   xpos += random(-1 * speed, speed);
   ypos += random(-1 * speed, speed);
   
   xpos = (xpos < (width - 250)) ? xpos : 0;
   ypos = (ypos < (height - 20)) ? ypos : 0;
 }
 
 void move(float x, float y)
 {
   // todo: check boundaries & such
   xpos += x;
   ypos += y;
 }
 
 void alterStress(float delta)
 {
   stress = ((stress + delta) >= 0.0) ? stress + delta : 0.0; 
 }
 
 void explode()
 {
 
 }
 
}

class Objective extends Shape
{
  color c;
  
  Objective()
  {
    super(random(24, sidebarX - 30), random(24, height - 30), random(24));
    
    c = color(24, 214, 71);
  }
  
  void display()
  {
    fill(c);
    stroke(208); 
    rect(xpos, ypos, size, size);
  }
}

// need particles for explosion
class Particle extends Shape
{
  Particle(float x, float y, float s)
  {
    super(x, y, s);
  }
}



ArrayList<Person> people; 
Person player;
ArrayList<Objective> things;
String[] quotes;

void setup() {
  size(1000, 600);
  
  people = new ArrayList<Person>();
  things = new ArrayList<Objective>();
  populateWorld(percentage);
  populateQuotes();
  
  player = new Person(true, true);
  
  //noLoop();
}

void displayStartScreen()
{
  background(255-48);
  textAlign(LEFT);
  textSize(16);
  stroke(48);
  fill(48);
  
  String[] textArray = loadStrings("start.txt");
  
  for(int i = 0; i < textArray.length; i++)
  {
    float y = (i * 20) + height/3;
    text(textArray[i], 20, y);
  }
  // user clicks to start the game

}



// I want to pull them from the 'net, but right now they're hardcoded.
void populateQuotes()
{
  quotes = loadStrings("quotes.txt");
}

// populates world
// \param[in] percentage: Percentage of minority
void populateWorld(int percentage)
{
  for(int i = 0; i < 150; i++) 
  {
    people.add(new Person(false));
  }
  
  int amount = int(random(1, 70));
  for(int i = 0; i < amount; i++)
  {
    things.add(new Objective());
  }
  
}

void draw() {
  if(gameRunning)
   {
    background(48);
    stroke(208);
    line(sidebarX, 0, sidebarX, height);
    for(int i = 0; i < people.size(); i++)
    {
      Person p = people.get(i);
     
      p.move();
      p.display();
    }
    
    for(int i = 0; i < things.size(); i++)
    {
      things.get(i).display();
    }
    
     player.display();
    
    displayQuote(height/2);
    stroke(208);
    textSize(16);
    text("Points: " + player.points, sidebarX + 10, 30);
    text("Stress level: " + int(player.stress), sidebarX + 10, 60);
    text("Objectives left: " + int(things.size()), sidebarX + 10, 90);
    line(sidebarX, 96, width, 96);
    
  }
  else 
  {
    displayStartScreen();
  }
}


void displayQuote(int ypos)
{
  textAlign(LEFT);
  stroke(208);
  textSize(14);
  text(quotes[currentQuoteIndex], sidebarX + 10, ypos, width - sidebarX - 30, height-30);

}

boolean collide(Shape p1, Shape p2)
{
  return checkCollision(p1, p2) || checkCollision(p2, p1);
}

boolean checkCollision(Shape p1, Shape p2)
{
  float halfSize1 = p1.size / 2.0;
  float halfSize2 = p2.size / 2.0;
  
  return ((p1.xpos - halfSize1) < (p2.xpos - halfSize2)) 
      && ((p1.xpos + halfSize1) > (p2.xpos - halfSize2))
      && ((p1.ypos - halfSize1) < (p2.ypos - halfSize2))
      && ((p1.ypos + halfSize1) > (p2.ypos - halfSize2));
}

// check collision of player with people
boolean checkPeopleCollision()
{
  boolean isColliding = false; 
  // really primitive collision checking here, so sue me
  
  for(int i = 0; i < people.size(); i++)
  {
    Person p = people.get(i);
    if(collide(player, p))
    {
      isColliding = true;
      float stressDelta = (p.isMinority) ? -0.1 : 1.0;
      player.alterStress(stressDelta);
    }
  }
  
  return isColliding;
  
}

void checkObjectiveCollisions()
{
  // have I found an objective?
  for(int i = things.size() - 1; i >= 0; i--)
  {
    Objective o = things.get(i);
    if(collide(player, o))
    {
      player.alterStress(-0.5 * o.size);
      
      player.points += o.size;
      things.remove(o);
    }
  } 
}

boolean checkWin()
{
  return (things.size() == 0) && (player.stress < maxPlayerStress);
}

boolean checkLoss()
{
  return (player.stress >= maxPlayerStress);
}

void displayWin()
{
  textSize(64);
  textAlign(CENTER);
  stroke(color(24, 214, 71));
  text("You win", width/2, height/2);
  noLoop();
}


void displayLoss()
{
  textSize(64);
  textAlign(CENTER);
  stroke(color(213, 74, 231));
  text("Game over", width/2, height/2);
  noLoop();
}

void moveGame(float deltaX, float deltaY)
{

  player.move (deltaX * player.speed, deltaY * player.speed);
 
  boolean isColliding = checkPeopleCollision();
  if(isColliding)
  {
    player.move(-1.0 * deltaX * player.speed, -1.0 * deltaY * player.speed);
    
    // new quote from annoying blue person
    currentQuoteIndex =  int(random(quotes.length));
  }
  checkObjectiveCollisions();
  
  player.display();
  
  if(checkWin()) 
  {
    displayWin();
  }
  else
  {
    if(checkLoss())
    {
      player.explode();
      displayLoss();
    }
  }  
}

void keyPressed()
{
  float deltaX = 0.0;
  float deltaY = 0.0;
  if(key == CODED)
  {
    switch(keyCode)
    {
      case UP:
        deltaX = 0.0;
        deltaY = -1.0;
        break;
      case DOWN:
        deltaX = 0.0;
        deltaY = 1.0;
        break;
      case LEFT:
        deltaX = -1.0;
        deltaY = 0.0;
        break;
      case RIGHT: 
        deltaX = 1.0;
        deltaY = 0.0;
        break;
      default:
        break;
    }
  }
  moveGame(deltaX, deltaY);
}

void mousePressed()
{
  gameRunning = true;
  // loop();

}

void mouseDragged()
{
  moveGame(mouseX - pmouseX, mouseY - pmouseY); 
}
