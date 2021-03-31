
void swap(ArrayList<PVector> p, int p1, int p2) {
  PVector temp = p.get(p1).copy();
  p.get(p1).x = p.get(p2).x;
  p.get(p1).y = p.get(p2).y;
  
  p.get(p2).x = temp.x;
  p.get(p2).y = temp.y;
}

// small to big
void selectionSort(ArrayList<PVector> p, int sortBy) {
  if (p.size() < 2) {
    return;
  }
  boolean done = false;

  while (!done) {
    done = true;

    for (int i = 1; i < p.size(); i++) {
      PVector p1 = p.get(i - 1);
      PVector p2 = p.get(i);

      switch (sortBy) {
      case 0: // x
        {
          if (p1.x > p2.x) {
             swap(p, i - 1, i);
             done = false;
          }
          break;
        }
      case 1: // y
        {
          if (p1.y > p2.y) {
             swap(p, i - 1, i);
             done = false;
          }
          break;
        }
      }
    }
  }
}

class Line {

  ArrayList<PVector> points;

  Line() {
    this.points = new ArrayList<PVector>();
  }

  int check(PVector p) {
    for (int i = 0; i < this.points.size(); i++) {
      PVector other = this.points.get(i);
      if (p.x == other.x && p.y == other.y) {
        return i;
      }
    }
    return -1;
  }

  void organize() {
  }

  void add(PVector other) {
    int same = this.check(other);
    if (same == -1) {
      this.points.add(other);
    } else {
      this.points.remove(same);
    }
    selectionSort(this.points, 0);
  }

  void reset() {
    for (int i = this.points.size() - 1; i > -1; i--) {
      this.points.remove(i);
    }
  }
}
