int percentage = 8;

class Person {
  
 // this is a really bad model but no cathedrals
 boolean isMinority;
 float xpos;
 float ypos;
 
 // maybe factor stress level in somewhere?
 float speed;
 
 // between 0 and 100
 float stress;
 
 float size;
 
 color c;
 
 Person()
 {
   xpos = random(width - 250);
   ypos = random(height - 20);
  
   isMinority = (random(100) < percentage); 
   c = (isMinority) ? color(231, 153, 74) : color(74, 152, 231);
   
   speed = random(5);
   
   stress = (isMinority) ? random(100) : random(50);
   
   size = 10 + 0.23 * (stress);
 }
  
 void display()
 {
   fill(c);
   stroke(0);
   ellipse(xpos, ypos, size, size);
 }
 
 void move()
 {
   xpos += random(-1 * speed, speed);
   ypos += random(-1 * speed, speed);
   
   xpos = (xpos < (width - 250)) ? xpos : 0;
   ypos = (ypos < (height - 20)) ? ypos : 0;
 }
 
}

ArrayList<Person> people; 

void setup() {
  size(1000, 600);
  line(800, 0, 800, 600);
  people = new ArrayList<Person>();
  populateWorld(percentage);
}

// populates world
// \param[in] percentage: Percentage of minority
void populateWorld(int percentage)
{
  for(int i = 0; i < 150; i++) 
  {
    people.add(new Person());
  }
}

void draw() {
  
  background(128);
  for(int i = 0; i < people.size(); i++)
  {
    Person p = people.get(i);
   
    p.display();
    p.move();
  }
  fill(0);
  textSize(16);
  text(people.size(), 830, 20);
}



