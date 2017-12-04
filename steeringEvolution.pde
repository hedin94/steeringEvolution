ArrayList<Vehicle> vehicles;
ArrayList<PVector> food;
ArrayList<PVector> poison;

float foodCount = 100;
float poisonCount = 20;
float vehicleCount = 10;

float foodRate = 0.07;
float poisonRate = 0.01;

boolean debug = true;

float mr = 0.1;

void setup() {
  size(1200, 650, P2D);

  vehicles = new ArrayList<Vehicle>();
  food = new ArrayList<PVector>();
  poison = new ArrayList<PVector>();

  for (int i = 0; i < vehicleCount; i++)
    vehicles.add(new Vehicle(random(width), random(height)));

  for (int i = 0; i < foodCount; i++) {
    food.add(new PVector(random(width), random(height)));
  }

  for (int i = 0; i < poisonCount; i++) {
    poison.add(new PVector(random(width), random(height)));
  }
}


void draw() {
  background(0);

  if (random(1) < foodRate) {
    food.add(new PVector(random(width), random(height)));
  }

  if (random(1) < poisonRate) {
    poison.add(new PVector(random(width), random(height)));
  }

  for (PVector f : food) {
    noStroke();
    fill(50, 255, 50);
    ellipse(f.x, f.y, 10, 10);
  }

  for (PVector p : poison) {
    noStroke();
    fill(255, 50, 50);
    ellipse(p.x, p.y, 10, 10);
  }

  for (int i = 0; i < vehicles.size(); i++) {
    Vehicle v = vehicles.get(i);
    v.applyBehaviors(food, poison);
    v.update();
    if (v.dead()) {
      vehicles.remove(i);
      continue;
    }
    v.cloneMe();
    v.show();
  }

  if (vehicles.isEmpty()) 
    for (int  i = 0; i < vehicleCount; i++)
      vehicles.add(new Vehicle(random(width), random(height)));
}
