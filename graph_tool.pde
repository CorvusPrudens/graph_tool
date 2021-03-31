
Graph graph;
int gsize = 500;
int pressed = 0;
PImage icon;
PImage icon2;

String pfile = "output/points.json";
String step_pfile = "output/curves.json";

void setup() {
  size(1000, 800);
  icon = loadImage("icon.png");
  icon2 = loadImage("upload_icon.png");

  graph = new Graph((width - gsize) / 2.0, (height - gsize) / 2.0, gsize, 20);
}

void draw() {
  background(42);
  graph.draw(pressed);
  clearButton(width - 75, height - 75, 50, graph, pressed);

  int save = circleButton(width - 150, height - 75, 50, 0, color(80), pressed);
  if (save == 1) {
    graph.save(pfile, step_pfile);
  }
  image(icon, width - 150 - 12, height - 75 - 12, 25, 25);
  int load = circleButton(width - 225, height - 75, 50, 0, color(80), pressed);
  if (load == 1) {
    graph.load(pfile);
  }
  image(icon2, width - 225 - 12, height - 75 - 12, 25, 25);
  pressed = 0;
}

void mousePressed() {
  pressed = 1;
}
