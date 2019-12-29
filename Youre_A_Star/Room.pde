public class Room {
  
  private Wall topWall;
  private Wall leftWall;
  private Wall bottomWall;
  private Wall rightWall;
  private PVector bottomLeft;
  private PVector topRight;
  private final int MAX_ROOM_LENGTH = 5 * diameter;
  private final int MAX_TRIES = 10;
  
  public Room(int tlX, int tlY, int trX, int trY, int blX, int blY, int brX, int brY) {
    topWall = new Wall(tlX, tlY, trX, trY);
    leftWall = new Wall(tlX, tlY, blX, brY);
    bottomWall = new Wall(blX, blY, brX, brY);
    rightWall = new Wall(brX, brY, trX, trY);
    
    bottomLeft = new PVector(blX, blY);
    topRight = new PVector(trX, trY);
    
    // Add this to roomsList automatically when new room is made
    roomList.add(this);
  }
  
  public Room(float tlX, float tlY, float trX, float trY, float blX, float blY, float brX, float brY) {
    this((int)tlX, (int)tlY, (int)trX, (int)trY, (int)blX, (int)blY, (int)brX, (int)brY);
  }
  
  public void drawWalls() {
    topWall.build();
    leftWall.build();
    bottomWall.build();
    rightWall.build();
  }
  
  /*
  *  Returns two corners of the room an array of size 2, structured like so:
  *  [PVector(bottomLeftX, bottomLeftY), PVector(topRightX, topRightY)]
  */
  /*
  private PVector[] getCorners() {
    return new PVector[] {bottomLeft, topRight};
  }
  */
  
  /* Splits room by adding a wall inside the room based on these restrictions:
  *  - wall cannot be placed next to another wall
  *  - wall cannot be in the same x or y coord as any door
  *  - if a wall cannot be placed after 3 attempts, return
  */
  public void splitRoom() {
    // Make sure room can be split
    if (topWall.getLength() < 5 * diameter && rightWall.getLength() < 5 * diameter) {
      println("Room too small to be split!");
      return;
    }
    
    // See if the room is longer horizontally or vertically
    boolean horizontal = topWall.getLength() >= rightWall.getLength();
    boolean collision;
    Wall newWall;
    int tries = 0;
    // If longer horizontally, split room with vertical wall
    if (horizontal) {
      int wallX;
      do {
        wallX = (int)random(bottomLeft.x + (2 * diameter), topRight.x - (2 * diameter)); // Use 2 so it can't be next to another wall
        collision = false;
        if ( getNode(wallX, (int)startNode.y).getX() == getNode((int)startNode.x, (int)startNode.y).getX() || 
             getNode(wallX, (int)goalNode.y).getX() == getNode((int)goalNode.x, (int)goalNode.y).getX() ) {
               collision = true;
        } else {
          for (PVector door : doorList) {
            if (getNode(wallX, (int)door.y).getX() == getNode((int)door.x, (int)door.y).getX()) {
              collision = true;
            }
          }
        }
        tries++;
      } while (collision && tries < MAX_TRIES);
      
      if (collision) { // could not split room
        return;
      }
      
      newWall = new Wall(wallX, (int)bottomLeft.y, wallX, (int)topRight.y);
    }
    // It's longer vertically, so split with a horizontal wall
    else {
      int wallY;
      do {
        wallY = (int)random(topRight.y + (3 * diameter), bottomLeft.y - (3 * diameter)); // Use 2 so it can't be next to another wall
        collision = false;
        if ( getNode((int)startNode.x, wallY).getY() == getNode((int)startNode.x, (int)startNode.y).getY() || 
             getNode((int)startNode.x, wallY).getY() == getNode((int)goalNode.x, (int)goalNode.y).getY() ) {
               collision = true;
        } else {
          for (PVector door : doorList) {
            if (getNode((int)door.x, wallY).getY() == getNode((int)door.x, (int)door.y).getY()) {
              collision = true;
            }
          }
        }
        tries++;
      } while (collision && tries < MAX_TRIES);
      
      if (collision) { // could not split room
        return;
      }
      
      newWall = new Wall((int)bottomLeft.x, wallY, (int)topRight.x, wallY);
    }
    
    // Wall is created, so now build it
    newWall.build();
    
    // Add door (doorList is updated internally in Wall class)
    newWall.addDoorInMiddle();
    
    /* Create and add new rooms to roomsToCheck stack if the following is true:
    *  - Length and width are both greater than or equal to MAX_ROOM_LENGTH
    */
    if (horizontal && bottomLeft.y - topRight.y >= MAX_ROOM_LENGTH) {
      float newWallX = newWall.getEndPoints()[0].x;
      // Check left room
      if (bottomLeft.x + MAX_ROOM_LENGTH <= newWallX) {
        Room leftRoom = new Room(bottomLeft.x, topRight.y, newWallX, topRight.y, bottomLeft.x, bottomLeft.y, newWallX, bottomLeft.y);
        roomsToCheck.push(leftRoom);
      }
      // Check right room
      if (newWall.getEndPoints()[0].x + MAX_ROOM_LENGTH <= topRight.x) {
        Room rightRoom = new Room(newWallX, topRight.y, topRight.x, topRight.y, newWallX, bottomLeft.y, topRight.x, bottomLeft.y);
        roomsToCheck.push(rightRoom);
      }
    }
    else if (!horizontal && topRight.x - bottomLeft.x >= MAX_ROOM_LENGTH) {
      float newWallY = newWall.getEndPoints()[0].y;
      // Check bottom room
      if (bottomLeft.y - MAX_ROOM_LENGTH >= newWallY) {
        Room bottomRoom = new Room(bottomLeft.x, newWallY, topRight.x, newWallY, bottomLeft.x, bottomLeft.y, topRight.x, bottomLeft.y);
        roomsToCheck.push(bottomRoom);
      }
      // Check top room
      if (newWallY - MAX_ROOM_LENGTH >= topRight.y) {
        Room topRoom = new Room(bottomLeft.x, topRight.y, topRight.x, topRight.y, bottomLeft.x, newWallY, topRight.x, newWallY);
        roomsToCheck.push(topRoom);
      }
    }
  }
  
}
