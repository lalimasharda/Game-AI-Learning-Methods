//float starttime;
//float currenttime;
int d = 30;
int x = 50;
int y = 50;
float rod = 40;
float ros = 5;
float charmaxvel = 3;
float maxRotation = PI / 16;
float ttt = 5;
float ttr = 2;
float aod = PI / 4;
float aos = PI / 32;
int counter = 0;
int tilewidth = 50;
int tileheight = 50;
float maxPrediction = 5;
ArrayList<PVector> Crumbs;

Graph g;
float edgelist[][] = new float[26][26];
ArrayList<Node> nodelist=new ArrayList<Node>();
int x1 = 50, y1 = 50;


void drawBreadCrumbs() {
  int i;

  for (i = 0; i < Crumbs.size(); i++) {
    fill(150, 0, 200);
    ellipse(Crumbs.get(i).x, Crumbs.get(i).y, 5, 5);
  }

  //ob.drawMyChar();
}

void drawRoom() {
  rectMode(CORNERS);

  // house flooring
  fill(255);
  rect(0, 0, 1000, 1000);

  // draw furniture
  fill(0, 0, 255);
  rect(200, 150, 300, 350);
  rect(800, 250, 1000, 400);
  rect(750, 600, 900, 700);


  // boundary walls
  fill(0);
  rect(0, 0, 25, 1000);
  rect(975, 0, 1000, 1000);
  rect(0, 0, 1000, 25);
  rect(975, 0, 1000, 1000);

  // interior walls
  rect(550, 0, 600, 200);
  rect(550, 300, 600, 600);
  rect(550, 700, 600, 1000);
  rect(550, 400, 1000, 450);


  for (Node node : nodelist) {
    float x = (float)node.loc.x;
    float y = (float)node.loc.y;
    stroke(200, 0, 0);
    strokeWeight(4);
    noFill();
    rectMode(CORNERS);
    rect(x, y, (x + 50), (y + 50));
    fill(0);
    text(node.name, x + 20, y + 20);
  }
}

void drawTileMap() {
  stroke(0);
  strokeWeight(0);
  int i, j;
  for (i = 0; i <= 1000; i += tilewidth) {
    line(i, 0, i, 1000);
  }
  for (j = 0; j <= 1000; j += tileheight) {
    line(0, j, 1000, j);
  }
}

int findClosestNode(PVector loc) {
  int newNode = -1;
  double minDistance = 10000;

  for (Node node : nodelist)
  {
    PVector newloc=node.loc;
    float dis=sqrt(sq(loc.x-newloc.x)+sq(loc.y-newloc.y));
    if (dis<minDistance)
    {
      minDistance=dis;
      newNode=Integer.parseInt(node.name);
    }
  }

  return newNode;
}

Path findAStarPath(PriorityQueue pq, String destination) {
  boolean flag = false;
  float distanceCovered = 0.0;
  Node prevCity;
  Path path = null;

  // expanded or visited nodes list
  List<String> visited = new ArrayList<String>();

  // open nodes list
  List<String> open = new ArrayList<String>();

  while (pq.size() > 0) {
    path = pq.remove();

    String lastnode = path.path.getLast();
    distanceCovered = path.distance;

    if (lastnode.equalsIgnoreCase(destination)) {
      path.distance = distanceCovered;
      flag = true;
      break;
    }
    Node c = nodelist.get(Integer.parseInt(lastnode)-1);

    open.remove(c.name);

    LinkedList<String> prevPath = path.path;

    if (!visited.contains(c.name))
      visited.add(c.name);

    prevCity = c;
    for (int i = 0; i < c.neighbours.size(); i++) {
      Node a = nodelist.get(Integer.parseInt(c.neighbours.get(i))-1);

      if (!visited.contains(a.name)) {

        Path newPath = new Path();
        newPath.path = new LinkedList<String>(prevPath);
        float prevdistance = edgelist[Integer.parseInt(prevCity.name)-1][Integer.parseInt(a.name)-1];
        //println("prevdist = "+ prevdistance);

        newPath.path.add(a.name);
        newPath.distance = prevdistance + distanceCovered;

        Node g = nodelist.get(Integer.parseInt(destination)-1);

        // heuristic #1: Euclidean distance
        float hValue = sqrt(sq(a.loc.x - g.loc.x) + sq((a.loc.y - g.loc.y)));

        // heuristic #2 : Manhattan Distance
        // double hValue=Math.abs((a.latitude-g.latitude)+(a.longitude-g.longitude));

        newPath.heuristicDistance = newPath.distance + hValue;
        // add adjacent to open list and priority queue
        open.add(a.name);
        pq.insert(newPath);
      }
    }
  }

  if (path == null || flag == false) {
    return null;
  } else {

    return path;
  }
}
