import java.util.HashMap;
import java.util.List;
static final int FAIL = 0;
static final int SUCCESS = 1;
PFont f;
float p;
MyCharacter[] obj;

void settings()
{
  size(1000, 1000);
}
void setup()
{

  g = new Graph();
  obj = new MyCharacter[2];
  obj[0] = new MyCharacter(50, 50, color(0, 0, 0), false);
  obj[1] = new MyCharacter(100, 600, color(255, 0, 0), true);
  Crumbs = new ArrayList<PVector>();
  f = createFont("Arial", 16, true);
  p=obj[1].Orientation;

  obj[1].blackboard.put("Monster", obj[1]);
  obj[1].blackboard.put("Enemy", obj[0]);
  obj[0].blackboard.put("Monster", obj[0]);
  obj[0].blackboard.put("Enemy", obj[1]);

  List<Task> tasklist1=new ArrayList<Task>();
  List<Task> tasklist4=new ArrayList<Task>();
  List<Task> selector_tasks1=new ArrayList<Task>();
  List<Task> selector_tasks2=new ArrayList<Task>();
  List<Task> sequence_tasks1=new ArrayList<Task>();

  tasklist1.add(new hasArrived(obj[1].blackboard));
  tasklist1.add(new Eat(obj[1].blackboard));
  tasklist1.add(new End(obj[1].blackboard));

  tasklist4.add(new Wander(obj[1].blackboard));
  tasklist4.add(new followPath(obj[1].blackboard));
  //tasklist4.add(new Wander(obj[0].blackboard));

  selector_tasks2.add(new Sequence(tasklist1, obj[1].blackboard));
  selector_tasks2.add(new Pursue(obj[1].blackboard));

  sequence_tasks1.add(new charInRange(obj[1].blackboard));
  sequence_tasks1.add(new Sequence(selector_tasks2, obj[1].blackboard));
  sequence_tasks1.add(new Dance(obj[1].blackboard));

  selector_tasks1.add(new Sequence(sequence_tasks1, obj[1].blackboard));
  selector_tasks1.add(new RandomSelector(tasklist4, obj[1].blackboard));

  obj[1].setBTree(new Selector(selector_tasks1, obj[1].blackboard));
}

void draw()
{
  //save("Image3.jpg");
  background(255);
  edgelist=g.edges;
  nodelist=g.nodes;
  drawRoom();
  drawTileMap();
  drawBreadCrumbs();
  obj[0].drawMyChar();
  obj[1].drawMyChar();

  if (nearDoor())// slow down when you are passing through a door
  {
    charmaxvel=1;
  } else
  {
    charmaxvel=3;
  }
  if (nearEdges())// change color
  {
    obj[0].mychar = color(100, 100, 200);

  } else
  {
    obj[0].mychar = color(0, 0, 0);
  }

  if (!obj[0].targetIsSet)
  {

    obj[0].targetIsSet=true;
    obj[0].startWander();
    obj[0].targetIsSet=false;
  }

  obj[1].btree.execute();
  obj[1].updateChar();
  obj[0].updateChar();
}


abstract class Task {
  Blackboard blackboard;
  abstract int execute();
}

class Blackboard {
  HashMap<String, Object> lookup;

  Blackboard() {
    lookup = new HashMap<String, Object>();
  }

  public Object get(String key) {
    return lookup.get(key);
  }

  public void put(String key, Object val) {
    lookup.put(key, val);
  }
}

class followPath extends Task
{
  followPath(Blackboard bb)
  {
    this.blackboard=bb;
  }
  int execute()
  {

    textFont(f, 16);                  
    fill(0, 200, 0);                  

    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    println("Following path to 26!", mon.Location.x, mon.Location.y);  
    mon.mychar = color(100, 0, 200);
    PVector newLocation2, newLocation3;
    mon.chardest = 26;
    if (!mon.targetIsSet)
    {
      mon.pathindex=1;
      mon.targetIsSet=true;
    }
    newLocation2 = nodelist.get(mon.chardest-1).loc;


    Path path;
    PriorityQueue pq = new PriorityQueue();

    mon.charsource = findClosestNode(mon.Location);
    Node start = nodelist.get(mon.charsource-1);
    path = new Path();

    path.path.add(start.name);
    path.distance = 0.0;

    pq.insert(path);

    mon.capturedpath = findAStarPath(pq, Integer.toString(mon.chardest));
    newLocation3 = newLocation2;

    if (mon.targetIsSet) {
      if (mon.capturedpath != null && mon.pathindex < mon.capturedpath.path.size()) {
        newLocation3 = nodelist.get(Integer.parseInt(mon.capturedpath.path.get(mon.pathindex))-1).loc;
      }

      mon.AlignChar(newLocation3);
      mon.arrive(newLocation3);

      mon.updateChar();
      if (!mon.monster)
        counter += 1;

      if (mon.capturedpath==null)
      {
        //no path
      } else
      {
        if (PVector.dist(mon.Location, newLocation3) <= 40 && mon.pathindex < (mon.capturedpath.path.size() - 1)) {
          mon.pathindex += 1;
        }

        if (mon.Location.equals(newLocation2)) {
          mon.pathindex = 1;
          mon.targetIsSet=false;
          mon.capturedpath = new Path();
          mon.mychar = color(255, 0, 0);
        }
        if (mon.pathindex > mon.capturedpath.path.size())
        {
          mon.pathindex=1;
          mon.capturedpath = new Path();
          mon.mychar = color(255, 0, 0);
        }
      }
    }
    text("!", mon.Location.x, mon.Location.y); 

    return SUCCESS;
  }
}

class Wander extends Task
{
  Wander(Blackboard bb)
  {
    this.blackboard=bb;
  }

  int execute()
  {
    //add wander quote
    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    MyCharacter ch = (MyCharacter) blackboard.get("Enemy");

    textFont(f, 16);                  
    fill(0, 200, 0);                         
    
    if (!mon.targetIsSet)
    {
      mon.targetIsSet=true;
      mon.startWander();
      mon.targetIsSet=false;
    }

    return SUCCESS;
  }
}

class Dance extends Task
{
  Dance(Blackboard bb)
  {
    this.blackboard=bb;
  }

  int execute()
  {
    //animate or add dance quote
    textFont(f, 16);                  
    fill(0, 200, 0);                   

    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    println("Dancing", mon.Location.x, mon.Location.y);
    //translate(mon.Location.x,mon.Location.y);
    rotate(p);
    scale(1);
    mon.drawMyChar();

    rotate(-p);
    p=p+5;
    
    return SUCCESS;
  }
}

class Eat extends Task
{
  Eat(Blackboard bb)
  {
    this.blackboard=bb;
  }
  int execute()
  {
    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    MyCharacter ch = (MyCharacter) blackboard.get("Enemy");

    textFont(f, 16);                  
    fill(0, 200, 0);                   
    println("Eating!", mon.Location.x, mon.Location.y);   
    //animate - scale down
    ch.scaledown();
    
    return SUCCESS;
  }
}

class hasArrived extends Task
{
  hasArrived(Blackboard bb)
  {
    this.blackboard=bb;
  }
  int execute()
  {
    textFont(f, 16);                 
    fill(0, 200, 0);                 
    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    MyCharacter ch = (MyCharacter) blackboard.get("Enemy");
    
    if (PVector.dist(mon.Location, ch.Location)<=100)
    {
      println("I am clooose!", mon.Location.x, mon.Location.y);   
      return SUCCESS;
    } else
      return FAIL;
  }
}

class charInRange extends Task
{
  charInRange(Blackboard bb)
  {
    this.blackboard=bb;
  }
  int execute()
  {
    textFont(f, 16);                  
    fill(0, 200, 0);  
    int status = SUCCESS;

    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    MyCharacter ch = (MyCharacter) blackboard.get("Enemy");

    if (PVector.dist(mon.Location, ch.Location)<200)
    {
      println("I can smell you!", mon.Location.x, mon.Location.y);   
      status = SUCCESS;
    }
    if (status==SUCCESS)
      blackboard.put("ClosestDistance", addTarget(mon, ch));
    else
      return FAIL;
    return SUCCESS;
  }

  PVector addTarget(MyCharacter mons, MyCharacter chars)
  {
    return PVector.sub(chars.Location, mons.Location);
  }
}
class Pursue extends Task {

  Pursue(Blackboard bb)
  {
    this.blackboard=bb;
  }

  int execute()
  {
    textFont(f, 16);                  
    fill(0, 200, 0);                    

    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    MyCharacter ch = (MyCharacter) blackboard.get("Enemy");


    println("I see you and I am coming for you!", mon.Location.x, mon.Location.y);  
    PVector target = pursue(mon, ch, blackboard);
    mon.AlignChar(target);
    mon.arrive(target);
    mon.updateChar();
    text("!", mon.Location.x, mon.Location.y);   
    return SUCCESS;
  }


  PVector pursue(MyCharacter mons, MyCharacter chars, Blackboard blackboard)
  {
    PVector direction = (PVector) blackboard.get("ClosestDistance");
    float distance = direction.mag();
    float prediction;
    float speed = mons.Velocity.mag();

    if (speed <= (distance/maxPrediction))
    {
      prediction = maxPrediction;
    } else
    {
      prediction = distance/speed;
    }

    PVector newtarget = PVector.add(chars.Location, chars.Velocity.mult(prediction));

    return newtarget;
  }
}

class End extends Task {

  End(Blackboard bb)
  {
    this.blackboard=bb;
  }

  int execute()
  {
    MyCharacter mon = (MyCharacter) blackboard.get("Monster");
    MyCharacter ch = (MyCharacter) blackboard.get("Enemy");
    text("LETS FINISH THIS!", mon.Location.x, mon.Location.y);  
    setup();
    text("!", mon.Location.x, mon.Location.y);  

    return SUCCESS;
  }
}


class Sequence extends Task {
  List<Task> tsklst;

  Sequence(List<Task> tsklst, Blackboard bb) {
    this.tsklst=tsklst;
    this.blackboard = bb;
  }

  int execute()
  {
    for (Task tasks : tsklst)
    {
      if (tasks.execute()==SUCCESS)
      {
        continue;
      } else
        return FAIL;
    }
    return SUCCESS;
  }
}


class Selector extends Task {
  List<Task> tsklst;

  Selector(List<Task> tsklst, Blackboard bb) {
    this.tsklst=tsklst;
    this.blackboard = bb;
  }

  int execute()
  {
    for (Task tasks : tsklst)
    {
      if (tasks.execute()==SUCCESS)
        return SUCCESS;
    }
    return FAIL;
  }
}

class RandomSelector extends Task
{
  List<Task> tsklst;

  RandomSelector(List<Task> tsklst, Blackboard bb) {
    this.tsklst=tsklst;
    this.blackboard = bb;
  }

  int execute()
  {
    while (true)
    {
      Task child = randomchoice();
      int result = child.execute();
      if (result==SUCCESS)
        return SUCCESS;
    }
  }

  Task randomchoice()
  {
    return(tsklst.get((int) (Math.random()*(tsklst.size() - 1))));
  }
}
