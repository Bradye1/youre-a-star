public class Node implements Comparable {
  protected int x;
  protected int y;
  protected int radius;
  protected int gCost; // distance from starting node
  protected int hCost; // distance from goal node
  protected int fCost; // gCost + hCost
  protected Node parent;
  protected boolean canTraverse;
  protected color myColor;
  protected final int CAN_TRAVERSE_COLOR = 255;
  protected final int CANNOT_TRAVERSE_COLOR = 0;
  
  
  // default constructor
  public Node(int xpos, int ypos, int newRadius) {
    this.radius = newRadius;
    this.x = xpos;
    this.y = ypos;
    this.canTraverse = true;
    this.myColor = CAN_TRAVERSE_COLOR;
  }
  
  public void updateFCost() {
    this.fCost = this.hCost + this.gCost;
  }
  
  public int getFCost() {
    return this.fCost;
  }
  
  public void setHCost(int newHCost) {
    this.hCost = newHCost;
    updateFCost();
  }
  
  public int getHCost() {
    return this.hCost;
  }
  
  public void setGCost(int newGCost) {
    this.gCost = newGCost;
    updateFCost();
  }
  
  public int getGCost() {
    return this.gCost;
  }
  
  public void setTraversal(boolean traverse) {
    this.canTraverse = traverse;
    if (this.canTraverse) {
      this.myColor = CAN_TRAVERSE_COLOR;
    }
    else {
      this.myColor = CANNOT_TRAVERSE_COLOR;
    }
  }
  
  public boolean getTraversal() {
    return this.canTraverse;
  }
  
  public void setParent(Node parentNode) {
    this.parent = parentNode;
  }
  
  public Node getParent() {
    return this.parent;
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
  
  public void setColor(color c) {
    this.myColor = c;
  }
  
  public void resetColor() {
    this.setTraversal(this.canTraverse);
  }
  
  public boolean containsPoint(int xpos, int ypos) {
    return (this.x - this.radius <= xpos && this.x + this.radius > xpos && this.y - radius <= ypos && this.y + radius > ypos);
  }
  
  public int compareTo(Object node) {
    
    if (this.fCost > ((Node)node).getFCost()) {
      return 1; // bigger F Cost
    }
    else if (this.fCost > ((Node)node).getFCost()) {
      return -1; // smaller F Cost
    }
    
    return 0; // same F Cost
  }
  
  public void drawNode() {
    rectMode(RADIUS);
    fill(this.myColor);
    rect(this.x, this.y, radius, radius);
  }
  
}