
JSONObject lines2json(Line lines[]) {
  JSONObject out = new JSONObject();
  
  for (int i = 0; i < lines.length; i++) {
    JSONArray line = new JSONArray();
    
    for (int j = 0; j < lines[i].points.size(); j++) {
      PVector p = lines[i].points.get(j);
      line.append(p.x);
      line.append(p.y);
    }
    
    out.setJSONArray("line_" + str(i), line);
  }
  
  return out;
}

float r5(float input) {
  float fac = 100000;
  return round((input*fac)) / fac;
}

PVector[] lin_interp(ArrayList<PVector> p, int numSteps, PVector axes, PVector startAxes) {
  
  if (p.size() == 0) {
    return new PVector[0]; 
  } else if (p.size() == 1) {
    PVector out[] = new PVector[numSteps];
    for (int i = 0; i < out.length; i++) {
      out[i] = new PVector(p.get(0).x, p.get(0).y); 
    }
    return out;
  }
  
  //int stepsPerPoint = int((float) numSteps / (float) (p.size() - 1));
  //PVector arr[] = new PVector[numSteps];
  
  //int num = 0;
  //for (int i = 1; i < p.size(); i++) {
  //  PVector p1 = p.get(i - 1);
  //  PVector p2 = p.get(i);
    
  //  for (int j = 0; j < stepsPerPoint; j++) {
  //    float x = map(j, 0, stepsPerPoint, p1.x, p2.x);
  //    float y = map(j, 0, stepsPerPoint, p1.y, p2.y);
  //    arr[j + stepsPerPoint*(i - 1)] = new PVector(x, y);
  //    num++;
  //  }
  //}
  
  PVector arr[] = new PVector[numSteps];
  
  float stepSize = (axes.x - startAxes.x) / (numSteps - 1); // numSteps - 1 so we start at 0 and end at 1
  
  for (int j = 0; j < numSteps; j++) {
    int index = p.size();
    float x = j * stepSize;
    for (int i = 0; i < p.size(); i++) {
      if (x < p.get(i).x) {
        index = i;
        break;
      }
    }
    if (index == 0) {
      arr[j] = p.get(0).copy();
    } else if (index == p.size()) {
      arr[j] =  p.get(p.size() - 1).copy();
    } else {
      PVector p1 = p.get(index - 1);
      PVector p2 = p.get(index);
      float tempx = x;
      float y = map(x, p1.x, p2.x, p1.y, p2.y);
      arr[j] =  new PVector(tempx, y);
    }
  }
  
  
  return arr;
}

JSONObject lines2json_step(Line lines[], int lineSteps, PVector axes, PVector startAxes) {
  JSONObject out = new JSONObject();
  
  for (int i = 0; i < lines.length; i++) {
    JSONArray line = new JSONArray();
    
    PVector interp[] = lin_interp(lines[i].points, lineSteps, axes, startAxes);
    
    for (int j = 0; j < interp.length; j++) {
      line.append(interp[j].x);
      line.append(interp[j].y);
    }
    
    out.setJSONArray("line_" + str(i), line);
  }
  
  return out;
}

Line[] json2lines(String path, int numLines) {
  JSONObject in = loadJSONObject(path);
  Line lines[] = new Line[numLines];
  
  for (int i = 0; i < lines.length; i++) {
    JSONArray line = in.getJSONArray("line_" + str(i));
    lines[i] = new Line();
    
    for (int j = 0; j < line.size(); j += 2) {
      float x = line.getFloat(j);
      float y = line.getFloat(j + 1);
      lines[i].add(new PVector(x, y));
    }
  }
  
  return lines;
}

class Graph {

  PVector pos;
  int size;
  float right;
  float left;
  float up;
  float down;
  Line lines[];
  int numLines;
  int currentLine;
  PVector axes;
  PVector axesStart;

  int dark = 80;
  int light = 180;

  color colors[] = {
    color(0x5F, 0xBF, 0xF9), 
    color(0xF3, 0x92, 0x37), 
    color(0xD6, 0x32, 0x30), 
    color(0x7D, 0xCe, 0x82), 
  };
  
  float diams[] = {
    6,
    10,
    14,
    18
  };


  Graph(float x, float y, int _size) {
    this.pos = new PVector(x, y);
    this.size = _size;
    this.lines = new Line[4];
    for (int i = 0; i < this.lines.length; i++) {
     this.lines[i] = new Line(); 
    }
    this.currentLine = 0;

    this.axes = new PVector(1, 1);
    this.axesStart = new PVector(0, 0);

    this.right = this.pos.x + this.size;
    this.left = this.pos.x;
    this.up = this.pos.y;
    this.down = this.pos.y + this.size;
  }

  void ticks(int numTicks) {
    float step = (float) size / numTicks;
    strokeWeight(1);
    stroke(dark);
    fill(dark);
    for (int i = 1; i < numTicks; i++) {
      line(this.pos.x + i * step, this.pos.y, this.pos.x + i * step, this.pos.y + this.size);
      line(this.pos.x, this.pos.y + i * step, this.pos.x + this.size, this.pos.y + i * step);


      pushMatrix();
      translate(this.pos.x + i * step - 15, this.pos.y + this.size + 30);
      rotate(-PI/4);
      String tm = nf((1.0 / numTicks) * i, 0, 2);
      text(tm, 0, 0);
      popMatrix();

      tm = nf(1 - (1.0 / numTicks) * i, 0, 2);
      text(tm, this.pos.x - 40, this.pos.y + i * step + 5);
    }
  }

  // Screen to coordinate
  PVector s2c(float x, float y) {
    float outx = map(x, this.pos.x, this.pos.x + this.size, this.axesStart.x, this.axesStart.x + this.axes.x); 
    float outy = map(y, this.pos.y + this.size, this.pos.y, this.axesStart.y, this.axesStart.y + this.axes.y); 

    return new PVector(outx, outy);
  }

  PVector c2s(PVector in) {
    float outx = map(in.x, this.axesStart.x, this.axesStart.x + this.axes.x, this.pos.x, this.pos.x + this.size); 
    float outy = map(in.y, this.axesStart.y + this.axes.y, this.axesStart.y, this.pos.y, this.pos.y + this.size); 

    return new PVector(outx, outy);
  }

  void mousePos(int numTicks, int press) {
    float step = (float) size / numTicks;
    if (mouseX < this.right + 40 && mouseX > this.left - 40 && mouseY > this.up - 40 && mouseY < this.down + 40) {

      float closeX = 10000;
      float closeY = 10000;

      float x = 0;
      float y = 0;

      for (int i = 0; i < numTicks + 1; i++) {
        float tickx = this.pos.x + i * step;
        float ticky = this.pos.y + i * step;
        if (abs(mouseX - tickx) < closeX) {
          closeX = abs(mouseX - tickx);
          x = tickx;
        }
        if (abs(mouseY - ticky) < closeY) {
          closeY = abs(mouseY - ticky);
          y = ticky;
        }
      }

      if (press == 1) {
        // we'll add multi-line support later
        this.lines[currentLine].add(this.s2c(x, y));
      }

      fill(dark);
      noStroke();

      circle(x, y, 20);
    }
  }

  void drawLines() {
    noFill();
    for (int i = 0; i < this.lines.length; i++) {
      Line line = this.lines[i];
      stroke(this.colors[i % this.colors.length]);
      strokeWeight(2);
      for (int j = 0; j < line.points.size(); j++) {
        PVector p2 = this.c2s(line.points.get(j));
        circle(p2.x, p2.y, diams[i]);
        if (j > 0) {
          PVector p1 = this.c2s(line.points.get(j - 1));

          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }
  }
  
  void lineSelect(int press) {
    float ystep = this.size / this.lines.length;
    for (int i = 0; i < this.lines.length; i++) {
      int me = circleButton(this.pos.x / 2, this.pos.y + ystep / 2 + ystep * i, 
                            ystep / 4, int(currentLine == i), this.colors[i], press);
      if (me == 1) currentLine = i;
    }
  }

  void draw(int press) {

    int numTicks = 10;
    this.ticks(numTicks);
    stroke(255);
    strokeWeight(2);
    noFill();
    rect(this.pos.x, this.pos.y, this.size, this.size);
    
    this.lineSelect(press);
    this.mousePos(numTicks, press);
    this.drawLines();
  }
  
  void reset() {
    for (int i = 0; i < this.lines.length; i++) {
      this.lines[i].reset();
    }
  }
  
  void save(String file1, String file2) {
    JSONObject output = lines2json(this.lines);
    saveJSONObject(output, file1);
    output = lines2json_step(this.lines, 100, this.axes, this.axesStart);
    saveJSONObject(output, file2);
  }
  
  void load(String file) {
    Line lin[] = json2lines(file, this.lines.length);
    this.lines = lin;
  }
}
