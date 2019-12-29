public class StartNode extends Node {
  
  final color STARTER_NODE_COLOR = color(0, 255, 42);

  public StartNode(int xpos, int ypos, int newRadius) {
    super(xpos, ypos, newRadius);
    this.myColor = STARTER_NODE_COLOR;
  }
  
  public void drawNode() {
    rectMode(RADIUS);
    fill(STARTER_NODE_COLOR);
    rect(this.x, this.y, radius, radius);
  }
}