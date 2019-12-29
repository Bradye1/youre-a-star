import java.util.PriorityQueue; // for min heap
import java.util.Stack; // for maze generation

int radius = 7;
int diameter = radius * 2;
int startNodeX = 50;
int startNodeY = 100;
int goalNodeX = 500;
int goalNodeY = 300;
// Need these two variables because the width might not be divisible by the diameter
int actualWidth;
int actualHeight;

boolean start = false;
boolean complete = false;

final int NODE_ADJACENT_DISTANCE = 10;
final int NODE_DIAGONAL_DISTANCE = 14;
StartNode startNode;
GoalNode goalNode;
Node currNode;

ArrayList<Node> nodeList;
ArrayList<Room> roomList;
PriorityQueue<Node> open;
PriorityQueue<Node> closed;
Stack<Room> roomsToCheck = new Stack<Room>(); // Room corner coords
ArrayList<PVector> doorList = new ArrayList<PVector>(); // Wall door coords

/*
public enum Direction {
  ABOVE,
  BELOW,
  LEFTHAND,
  RIGHTHAND,
  ABOVERIGHTHAND,
  ABOVELEFTHAND,
  BELOWRIGHTHAND,
  BELOWLEFTHAND 
}
*/

public enum Direction {
  ABOVE,
  BELOW,
  LEFTHAND,
  RIGHTHAND,
}
  
public enum Orientation {
  HORIZONTAL,
  VERTICAL
}
  
void setup() {
  size(800, 800);
  frameRate(60);
  
  actualWidth = width - (width % radius*2);
  actualHeight = height - (height % radius*2);
  
  // Create nodes and put them in grid
  nodeList = new ArrayList<Node>();
  for (int i = 0; i < width/(radius * 2); i++) {
    for (int j = 0; j < height/(radius * 2); j++) {
      Node node = new Node(i * radius * 2  + radius, j * radius * 2 + radius, radius);
      nodeList.add(node);
      node.drawNode();
    }
  }
  
  // define start node
  Node tempNode = getNode(startNodeX, startNodeY);
  startNode = new StartNode(tempNode.getX(), tempNode.getY(), radius);
  nodeList.remove(tempNode);
  nodeList.add(startNode);
  
  //define goal node
  tempNode = getNode(goalNodeX, goalNodeY);
  goalNode = new GoalNode(tempNode.getX(), tempNode.getY(), radius);
  nodeList.remove(tempNode);
  nodeList.add(goalNode);
  
  // Initialize costs for every node
  initHCosts();
  initGCosts();
  
  // Create Heaps
  open = new PriorityQueue<Node>();
  closed = new PriorityQueue<Node>();
  
  // add start node to open heap
  open.add(startNode);
  
  
  // Rooms setup
  roomList = new ArrayList<Room>();
  drawBorders();
  
  
  /*
  // neigbors test: change color of startNode neighbors
  for (Node neighbor : getNeighbors(startNode)) {
    neighbor.setColor(color(0, 0, 255));
  }
  */
  
}

void draw() {
  background(255);
  
  // Maze algorithm
  if (!roomsToCheck.empty()) { //<>//
    Room currRoom = roomsToCheck.pop();
    currRoom.splitRoom();
  }
  
  
  // draw all of the nodes
  for (Node node : nodeList) {
    node.drawNode();
  }
  
  // Generate Walls
  
  
  if (start) {
    // start of A* algorithm
    if (!complete) {
      updateColors();
      currNode = open.poll(); // get next node to evaluate (lowest F Cost)
      closed.add(currNode);
      
      // see if this is the goal node
      if (currNode == goalNode) {
        drawFinalPath();
        complete = true;
      }
      
      for (Node neighbor : getNeighbors(currNode)) {
        if (!neighbor.getTraversal() || closed.contains(neighbor)) {
          continue;
        }
        
        // if new path to neighbor is shorter or if node hasn't been found yet
        if (!open.contains(neighbor) || currNode.getGCost() + getDistance(currNode, neighbor) < neighbor.getGCost()) {
          
          // update cost of neighbor
          neighbor.setGCost(currNode.getGCost() + getDistance(currNode, neighbor));
          neighbor.setParent(currNode);
          if (!open.contains(neighbor)) {
            open.add(neighbor);
          }
        }
      }
    }
    else {
      //println("Done!");
    }
  }
  
}

public void updateColors() {
  for (Node openNode : open) {
    openNode.setColor(color(3, 255, 247));
  }
  
  for (Node closedNode : closed) {
    closedNode.setColor(color(0, 105, 101));
  }
}

public void drawFinalPath() {
  Node pathNode = goalNode.parent;
  while (pathNode != startNode) {
    pathNode.setColor(color(119, 2, 173));
    pathNode = pathNode.getParent();
  }
}

public void drawBorders() {
  Room startRoom = new Room(0, 0, actualWidth, 0, 0, actualHeight, actualWidth, actualHeight);
  startRoom.drawWalls();
  roomList.add(startRoom);
  roomsToCheck.push(startRoom);
  
  /* before adding Rooms:
  (new Wall(0, 0, width, 0)).build(); // top wall
  (new Wall(0, 0, 0, height)).build(); // left wall
  (new Wall(0, height, width, height)).build(); // bottom wall //<>//
  (new Wall(width, height, width, 0)).build(); // right wall
  */
}

// gets a node at a specific point
public Node getNode(int x, int y) {
  //out of bounds
  if (x < 0 || x > width || y < 0 || y > height) {
    return null;
  }
  /* We need this next if statement because if we ask for a node at position (width, height)
  *  but the height or width isn't divisible by the node diameter, then we need to just return
  *  the node at the edge, or else we will get a null pointer, since no node will contain the point
  */
  if (x > actualWidth || y > actualHeight) {
    x = Math.min(x, actualWidth);
    y = Math.min(y, actualHeight);
  }
  for (Node node : nodeList) {
    if (node.containsPoint(x, y)) {
      return node;
    }
  }
  return null;
}

// get the neighbor of a node in a particular Direction
public Node getNeighbor(Node node, Direction dir) {
  switch(dir) {
    case ABOVE: return getNode(node.getX(), node.getY() - radius * 2);
    case BELOW: return getNode(node.getX(), node.getY() + radius * 2);
    case LEFTHAND: return getNode(node.getX() - radius * 2, node.getY());
    case RIGHTHAND: return getNode(node.getX() + radius * 2, node.getY());
    //case ABOVELEFTHAND: return getNode(node.getX() - radius * 2, node.getY() - radius * 2);
    //case ABOVERIGHTHAND: return getNode(node.getX() + radius * 2, node.getY() - radius * 2);
    //case BELOWLEFTHAND: return getNode(node.getX() - radius * 2, node.getY() + radius * 2);
   // case BELOWRIGHTHAND: return getNode(node.getX() + radius * 2, node.getY() + radius * 2);
    default: return node; // shouldn't ever happen
  }
}

// return an array containing the (up to 8) neighbors of the given node
public Node[] getNeighbors(Node node) {
  ArrayList<Node> neighbors = new ArrayList<Node>();
  // get every neighbor by iterating through Direction enum
  for (Direction dir : Direction.values()) {
    Node tempNode = getNeighbor(node, dir);
    if (tempNode != null) {
      neighbors.add(tempNode);
    }
  }
  Node[] n = new Node[neighbors.size()];
  return neighbors.toArray(n);
}

public void initHCosts() {
  for (Node node : nodeList) {
    // divide by radius * 2 to compensate for the fact that we're
    // working with pixel position. If we didn't do this, the cost
    // from one node to another would be something huge like 200
    node.setHCost(getDistance(node, goalNode) / (radius * 2));
  }
}

public void initGCosts() {
  for (Node node : nodeList) {
    node.setGCost(100000);
  }
  startNode.setGCost(0);
}

public int getDistance(Node node1, Node node2) {
  int xDist = Math.abs(node1.getX() - node2.getX());
  int yDist = Math.abs(node1.getY() - node2.getY());
  
  if (xDist > yDist) {
    return (NODE_DIAGONAL_DISTANCE * yDist) + (NODE_ADJACENT_DISTANCE * (xDist - yDist));
  }
  else {
    return (NODE_DIAGONAL_DISTANCE * xDist) + (NODE_ADJACENT_DISTANCE * (yDist - xDist));
  }
}

// TODO handle mouse out of range
// TODO add feature to restart with current boarders still there
void mouseDragged() {
  if (mouseButton == LEFT) {
    getNode(mouseX, mouseY).setTraversal(false);
  }
  else if (mouseButton == RIGHT) {
    getNode(mouseX, mouseY).setTraversal(true);
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    getNode(mouseX, mouseY).setTraversal(false);
  }
  else if (mouseButton == RIGHT) {
    getNode(mouseX, mouseY).setTraversal(true);
  }
}

void keyPressed() {
  if (key == ' ') {
    println("space");
    start = !start;
  }
  if (key == 'k') {
    println("Info:");
    println("mouseX: " + mouseX);
    println("mouseY: " + mouseY);
  }
}