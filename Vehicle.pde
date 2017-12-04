class Vehicle {
  PVector pos;
  PVector vel;
  PVector acc;
  float health;
  float maxForce = 1.0;
  float maxVel = 5.0;
  DNA dna;

  Vehicle(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector();
    health = 1;
    dna = new DNA();
  }

  Vehicle(float x, float y, DNA dna_) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector();
    health = 1;
    dna = dna_;
  }

  void show() {
    noStroke();
    float r = 1;
    float g = 1;
    if (health <= 0.5)
      g = map(health, 0, 0.5, 0, 1);
    else
      r = 1 - map(health, 0.5, 1, 0, 1);
    
    r *= 255;
    g *= 255;

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-PI/2.0 + vel.normalize().heading());

    if (debug) {
      noFill();
      stroke(0, 255, 0);
      line(0, 0, 0, dna.foodWeight*10);
      ellipse(0, 0, dna.foodPerception, dna.foodPerception);
      
      stroke(255, 0, 0);
      line(0, 0, 0, dna.poisonWeight*10);
      ellipse(0, 0, dna.poisonPerception, dna.poisonPerception);
    }
    
    noStroke();
    fill(r, g, 0);
    drawTriangle(pos, vel.normalize());
    popMatrix();
  }

  void update() {
    vel.add(acc).limit(maxVel);
    pos.add(vel);
    acc.mult(0);
    health -= 0.005;
  }

  PVector seek(PVector target) {
    PVector steering = target.copy();
    steering.sub(pos);
    steering.sub(vel);
    return steering;
  }

  PVector eat(ArrayList<PVector> food) {
    PVector closest = findClosest(food, pos);
    if (closest == null) return new PVector();

    float d = pos.dist(closest);
    
    if (d < 5) {
      food.remove(food.indexOf(closest));
      health += 0.5;
    } else if (d < dna.foodPerception/2) {
      return seek(closest);
    }
    
    return new PVector();
  }

  PVector avoid(ArrayList<PVector> poison) {
    PVector closest = findClosest(poison, pos);
    if (closest == null) return new PVector();

    float d = pos.dist(closest);
    
    if (d < 5) {
      poison.remove(poison.indexOf(closest));
      health -= 0.5;
    } else if (d < dna.poisonPerception/2) {
      return seek(closest);
    }

    return new PVector();
  }

  PVector avoidBounds() {
    PVector steer = new PVector();
    
    if (pos.x < 10) {
      steer.x += 1.0;
    } else if (pos.x > width-10) {
      steer.x -= 1.0;
    }

    if (pos.y < 10) {
      steer.y += 1.0;
    } else if (pos.y > height-10) {
      steer.y -= 1.0;
    }
      
    return steer;  
  }
  
  void applyForce(PVector force) {
    acc.add(force).limit(maxForce);
  }
  
  void applyBehaviors(ArrayList<PVector> food, ArrayList<PVector> poison) {
    PVector foodSteer = eat(food);
    PVector poisonSteer = avoid(poison);
    PVector boundSteer = avoidBounds();
    
    foodSteer.mult(dna.foodWeight);
    poisonSteer.mult(dna.poisonWeight);

    applyForce(foodSteer);
    applyForce(poisonSteer);
    applyForce(boundSteer);
  }

  boolean dead() {
    return (health < 0);
  }

  void cloneMe() {
    if (health < 0.5) return;
    if (random(1) < 0.006) {
      vehicles.add(new Vehicle(pos.x, pos.y, dna.copy().mutate()));
    }
  }
}
  
void drawTriangle(PVector pos, PVector dir) {
  float x1 = -8;
  float y1 = -8;
  float x2 = 8;
  float y2 = -8;
  float x3 = 0;
  float y3 = 14;
  triangle(x1, y1, x2, y2, x3, y3);
}

PVector findClosest(ArrayList<PVector> list, PVector pos) {
  float record = 2*width;
  int closest = -1;
    
  for (int i = 0; i < list.size(); i++) {
    if (pos.dist(list.get(i)) < record) {
      record = pos.dist(list.get(i));
      closest = i;
    }
  }

  if (closest > -1)
    return list.get(closest);

  return null;
}
