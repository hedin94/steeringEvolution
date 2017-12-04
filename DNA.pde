class DNA {
  float foodWeight;
  float poisonWeight;
  float foodPerception;
  float poisonPerception;

  DNA() {
    foodWeight = random(-1, 1);
    poisonWeight = random(-1, 1);
    foodPerception = random(0, 200);
    poisonPerception = random(0, 200);
  }

  DNA mutate() {
    if (random(1) < mr) {
      foodWeight += random(-0.1, 0.1);
    }
    if (random(1) < mr) {
      poisonWeight += random(-0.1, 0.1);
    }
    if (random(1) < mr) {
      foodPerception += random(-100, 100);
      foodPerception = max(0, foodPerception);
      foodPerception = min(foodPerception, 200);
    }
    if (random(1) < mr) {
      poisonPerception += random(-100, 100);
      poisonPerception = max(0, poisonPerception);
      poisonPerception = min(poisonPerception, 200);
    }

    return this;
  }

  DNA copy() {
    DNA dna = new DNA();
    dna.foodWeight = foodWeight;
    dna.poisonWeight = poisonWeight;
    dna.foodPerception = foodPerception;
    dna.poisonPerception = poisonPerception;
    return dna;
  }
}
