int percentage = 8;
int maxPlayerStress = 100;

int sidebarX = 800;
boolean canStart = false;
int currentQuoteIndex = 0; 

/**
wordwrap taken from http://wiki.processing.org/index.php?title=Word_wrap_text
@author Daniel Shiffman
*/
 
// Function to return an ArrayList of Strings (maybe redo to just make simple array?)
// Arguments: String to be wrapped, maximum width in pixels of each line
ArrayList wordWrap(String s, int maxWidth) {
  // Make an empty ArrayList
  ArrayList a = new ArrayList();
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  // As long as we are not at the end of the String
  while (i < s.length()) {
    // Current char
    char c = s.charAt(i);
    w += textWidth(c); // accumulate width
    if (c == ' ') rememberSpace = i; // Are we a blank space?
    if (w > maxWidth) {  // Have we reached the end of a line?
      String sub = s.substring(0,rememberSpace); // Make a substring
      // Chop off space at beginning
      if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1,sub.length());
      // Add substring to the list
      a.add(sub);
      // Reset everything
      s = s.substring(rememberSpace,s.length());
      i = 0;
      w = 0;
    } 
    else {
      i++;  // Keep going!
    }
  }
 
  // Take care of the last remaining line
  if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1,s.length());
  a.add(s);
 
  return a;
}

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
  noLoop();
  
  displayStartScreen();
  people = new ArrayList<Person>();
  things = new ArrayList<Objective>();
  populateWorld(percentage);
  populateQuotes();
  
  player = new Person(true, true);
  
}

void displayStartScreen()
{
  background(255-48);
  textAlign(LEFT);
  textSize(16);
  stroke(48);
  fill(48);
  
  ArrayList<String> textList = new ArrayList<String>();
  String[] text = loadStrings("start.txt");
  for(int i = 0; i < text.length; i++)
  {
    ArrayList<String> t = wordWrap(text[i], width - 50);
    for(int k = 0; k < t.size(); k++)
    {
      textList.add(t.get(k));
    }
  }
  
  for(int i = 0; i < textList.size(); i++)
  {
    float y = (i * 20) + height/3;
    text(textList.get(i), 20, y);
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
  if(canStart)
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
}


void displayQuote(int ypos)
{
  textAlign(LEFT);
  stroke(208);
  textSize(14);
  ArrayList<String> wrapped = wordWrap(quotes[currentQuoteIndex], (width - sidebarX - 30));
  for(int i = 0; i < wrapped.size(); i++)
  {
    text(wrapped.get(i), sidebarX + 10, ypos + (18.0 * i));
  }
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

void mousePressed()
{
  loop();
  canStart = true;
}
