
color brighten(color c, int brighter) {
  int c3 = c & 255;
  int c2 = (c >> 8) & 255;
  int c1 = (c >> 16) & 255;
  
  c1 = constrain(c1 + brighter, 0, 255);
  c2 = constrain(c2 + brighter, 0, 255);
  c3 = constrain(c3 + brighter, 0, 255);
  
  return color(c1, c2, c3);
}

int circleButton(float x, float y, float diam, int state, color c, int press) {
  
  int pressed = 0;
  float radius = diam / 2;
  
  if (state == 1) {
    fill(c);
  } else {
    fill(80);
  }
  
  stroke(c);
  if (dist(x, y, mouseX, mouseY) <= radius) {
    stroke(brighten(c, 50));
    if (press == 1) {
      pressed = 1;
    }
  }
  
  circle(x, y, diam);
  
  return pressed;
}

void clearButton(float x, float y, float diam, Graph g, int press) {
 
  fill(80);
  noStroke();
  circle(x, y, diam);
  
  float radius = diam / 2;
  
  stroke(120);
  if (dist(x, y, mouseX, mouseY) <= radius) {
    stroke(180);
    if (press == 1) {
      g.reset();
    }
  }
  
  line(x - radius / 2, y + radius / 2, x + radius / 2, y - radius / 2);
  line(x - radius / 2, y - radius / 2, x + radius / 2, y + radius / 2);
  
  
}
