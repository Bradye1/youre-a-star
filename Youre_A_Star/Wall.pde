class Wall {
  
  private int x1;
  private int y1;
  private int x2;
  private int y2;
  private int myLength;
  private Orientation myOrientation;
  
  public Wall(int xpos1, int ypos1, int xpos2, int ypos2) {
    this.x1 = xpos1;
    this.y1 = ypos1;
    this.x2 = xpos2;
    this.y2 = ypos2;
    this.myLength = Math.abs(this.x1 - this.x2) + Math.abs(this.y1 - this.y2);
    this.myOrientation = (x1 == x2 ? Orientation.VERTICAL : Orientation.HORIZONTAL);
  }
  
  public void build() {
    
    if (this.myOrientation == Orientation.VERTICAL)
    {
      for (int i = Math.min(y1, y2); i < Math.max(y1, y2) && i < actualHeight; i+=radius*2) {
        getNode(this.x1, i).setTraversal(false);
      }
    }
    else {
      for (int j = Math.min(x1, x2); j < Math.max(x1, x2) && j < actualWidth; j+=radius*2) {
        getNode(j, this.y1).setTraversal(false);
      }
    }
  }
  
  // adds a door at position (x, y)
  // returns an array [x, y] if successful
  public int[] addDoor(int x, int y) {
    // check to make sure the point is in this wall
    if (Math.min(x1, x2) <= x && x <= Math.max(x1, x2) && Math.min(y1, y2) <= y && y <= Math.max(y1, y2)) {
      Node temp = getNode(x, y);
      temp.setTraversal(true);
      doorList.add(new PVector(x, y)); // Add to doorList
      return new int[] {x, y};
    }
    // point isn't in this wall
    return null;
  }
  
  // adds a door at a random position (within this wall)
  // returns an array [x, y] if successful
  public int[] addDoor() {
    return addDoor(int(random(Math.min(x1, x2), Math.max(x1, x2))), int(random(Math.min(y1, y2), Math.max(y1, y2))));
  }
  
  public int[] addDoorInMiddle() {
    if (this.myOrientation == Orientation.HORIZONTAL) {
      return addDoor(int(random(Math.min(x1, x2) + diameter, Math.max(x1, x2) - diameter)), int(random(Math.min(y1, y2), Math.max(y1, y2))));
    }
    else {
      return addDoor(int(random(Math.min(x1, x2), Math.max(x1, x2))), int(random(Math.min(y1, y2) + diameter, Math.max(y1, y2) - diameter)));
    }
  }
  
  public int getLength() {
    return myLength;
  }
  
  // Returns end points of the wall as an array of 2 PVectors
  public PVector[] getEndPoints() {
    return new PVector[] {new PVector(x1, y1), new PVector(x2, y2)};
  }
  
}
