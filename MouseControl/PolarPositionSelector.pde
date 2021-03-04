

void mousePressed() {
  Selector.checkDraging(mouseX, mouseY);
}
void mouseReleased() {
  Selector.dragRelease();
}
void mouseWheel(MouseEvent event) {
  int e = int(event.getCount());
  if (e != 0) {
    Selector.setHeight(int(e));
  }
}

class PolarPositionSelector {
  PVector Position;
  float  diam =  (h + abs(Constrains.minHeight)+10)/2;
  float activeAreaDiam = 600;
    float activeAreaMinDiam = 80;
  int lastChange;
  boolean heightChanged = false;
  boolean draging = false;

  PolarPositionSelector() {
    Position = new PVector(width/2, (height/2) - activeAreaMinDiam);
    draging = true;
    dragRelease();
    
  }
  void update() {
    // rapid changes possible with mouse wheel can flood the buffer, so a timer us used here
    if (lastChange>millis()-300 && heightChanged) {
      heightChanged = false;
      setPolarPosition();
    }
    display();
  }
  void display() {
    fill(100);
    arc(width/2, height/2, activeAreaDiam, activeAreaDiam, PI, TWO_PI);
    fill(255);
    ellipse(height/2, width/2, activeAreaMinDiam*2, activeAreaMinDiam*2);
    fill(255, 0, 0);
    ellipse(Position.x, Position.y, diam, diam);
    if (draging) {
      if (pointInArea(mouseX, mouseY)) {
        drag();
      }
    }
  }

  void checkDraging(int X, int Y) {
    if (pointInCircle(X, Y, Position.x, Position.y, diam / 2)) {
      draging = true;
    } else {
      draging = false;
    }
  }
  void setHeight(int i) {
    heightChanged = true;
    h += i;
    h = constrain(h, Constrains.minHeight, Constrains.maxHeight); 
    diam =  (h + abs(Constrains.minHeight)+10)/2; // this is just for visual representation
    lastChange = millis();
  }
  void dragRelease() {
    if (draging) {
      draging = false;
      float stretch = dist(Position.x, Position.y, width/2, height/2);
      stretch = map(stretch, activeAreaMinDiam, activeAreaDiam/2, Constrains.minStretch, Constrains.maxStretch);
      float rotation = (90+degrees(atan2(width/2-Position.x, height/2-Position.y)));
      s = int(stretch);
      r = int(rotation);
      setPolarPosition();
    }
  }
  boolean pointInArea(float x, float y) {
    if (dist(x, y, width/2, height/2) <= activeAreaDiam/2 && dist(x, y, width/2, height/2) >= activeAreaMinDiam && y < height/2) { 
      return true;
    } else {
      return false;
    }
  }

  boolean pointInCircle(float x, float y, float a, float b, float r) {
    if (dist(x, y, a, b) <= r ) { // add minimum distance here too 
      return true;
    } else {
      return false;
    }
  }
  void drag() {
    Position.x = mouseX;
    Position.y = mouseY;
  }
}
