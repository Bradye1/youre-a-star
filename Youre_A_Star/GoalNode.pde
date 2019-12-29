public class GoalNode extends Node {
  
  final color GOAL_NODE_COLOR = color(201, 28, 16);

  
  public GoalNode(int xpos, int ypos, int newRadius) {
    super(xpos, ypos, newRadius);
    this.myColor = GOAL_NODE_COLOR;
  }
  
  public void drawNode() {
    rectMode(RADIUS);
    fill(GOAL_NODE_COLOR);
    rect(this.x, this.y, radius, radius);
  }
}