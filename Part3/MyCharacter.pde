
class MyCharacter{
    color mychar;
    boolean monster;
    PVector Location, Velocity, Acceln;
    float Orientation, characterRotation = 0, steering_angular = 0;
    Task btree;
    int pathindex;
    int charsource, chardest;
    boolean targetIsSet;
    Blackboard blackboard;
    
    Path capturedpath;
    
    MyCharacter(float x, float y, color c, boolean monster)
    {
      this.mychar=c;
      this.monster=monster;
      this.Location = new PVector(x,y);
      this.Velocity = new PVector(0,10);
      this.Acceln = new PVector(0,0);
      this.Orientation = 0;
      this.pathindex=1;
      this.targetIsSet = false;
      if(monster)
        this.charsource = 13;
      else
        this.charsource = 1;
      this.chardest = charsource;
      
      blackboard = new Blackboard();
      
    }
    
    void setBTree(Task btree)
    {
      this.btree=btree;
    }

    ///////////////////////////////// DRAW
    ///////////////////////////////// CHARACTER/////////////////////////////////////

    void drawMyChar() {
      int x = 33;
      translate(Location.x, Location.y);
      rotate(Orientation);

      fill(mychar);
      stroke(mychar);
      ellipse(0, 0, d, d);
      triangle(0, -(x / 2), 0, (x / 2), (d), 0);
      rotate(-Orientation);
      translate(-Location.x, -Location.y);
    }

    ///////////////////////////////// ARRIVE
    ///////////////////////////////// CHARACTER/////////////////////////////////////

    void arrive(PVector targetpos) {

      PVector direction = PVector.sub(targetpos, Location);

      float goalspeed;
      PVector goalvelocity = direction;
      float distval = direction.mag();

      if (distval < ros) {
        goalspeed = 0;
      } else if (distval > rod) {
        goalspeed = charmaxvel;
      } else {
        goalspeed = charmaxvel * (distval / rod);
      }

      goalvelocity = goalvelocity.normalize();
      goalvelocity.mult(goalspeed);

      Acceln = PVector.sub(goalvelocity, Velocity);
      Acceln.div(ttt);
    }

    ///////////////////////////////// MAP TO
    ///////////////////////////////// RANGE/////////////////////////////////////

    float mapToRange(float rot) {
      float r = rot % (TWO_PI);
      if (abs(r) <= PI)
        return r;
      else if (abs(r) > PI)
        return (r - TWO_PI);
      else
        return (r + TWO_PI);
    }

    ///////////////////////////////// ALIGN
    ///////////////////////////////// CHARACTER/////////////////////////////////////

    void AlignChar(PVector TargetLoc) {
      float targetort = atan2(TargetLoc.y - Location.y, TargetLoc.x - Location.x);
      float rot = targetort - Orientation;
      rot = mapToRange(rot);
      float rot_size = abs(rot);
      float goalRotation;

      if (rot_size < aos) {
        goalRotation = 0;
      } else if (rot_size > aod) {
        goalRotation = maxRotation;
      } else {
        goalRotation = maxRotation * (rot_size / aod);
      }

      goalRotation *= (rot / abs(rot));
      steering_angular = goalRotation - characterRotation;
      steering_angular = steering_angular / ttr;
    }
    
    /////////////////////////////////PURSUE///////////////////////////////////////////////
    PVector pursue(MyCharacter target)
    {
      PVector direction = PVector.sub(target.Location,Location);
      float distance = direction.mag();
      float prediction;
      float speed = Velocity.mag();
      
      if(speed <= (distance/maxPrediction))
      {
        prediction = maxPrediction;
      }
      else
      {
        prediction = distance/speed;
      }
      
      PVector newtarget = PVector.add(target.Location,target.Velocity.mult(prediction));
      
      return newtarget;
    }
    /////////////////////////////////CHARACTER WANDER/////////////////////////////////////
   
   public int wander()
   {
     return ((int) (Math.random()*(26 - 1))) + 1;
     
   }
   
   public void startWander()
   {
    PVector newLocation2, newLocation3;
    if((chardest == charsource) || !targetIsSet)
    {
      pathindex=1;
      chardest = wander();
      targetIsSet=true;
    }
    newLocation2 = nodelist.get(chardest-1).loc;
    
    
    Path path;
    PriorityQueue pq = new PriorityQueue();
  
    charsource = findClosestNode(Location);
    Node start = nodelist.get(charsource-1);
    path = new Path();

    path.path.add(start.name);
    path.distance = 0.0;

    pq.insert(path);
    //Path capturedpath;

    capturedpath = findAStarPath(pq, Integer.toString(chardest));
    newLocation3 = newLocation2;
    
    //println("Hello" + capturedpath.path.get(0));
    if (targetIsSet) {
      if (capturedpath != null && pathindex < capturedpath.path.size()) {
        newLocation3 = nodelist.get(Integer.parseInt(capturedpath.path.get(pathindex))-1).loc;
      }
      
      AlignChar(newLocation3);
      arrive(newLocation3);

      updateChar();
      if(!monster)
        counter += 1;
      
      if(capturedpath==null)
      {
        
      }
      else
      {
        if (PVector.dist(Location, newLocation3) <= 30 && pathindex < (capturedpath.path.size() - 1)) {
          //print(pathindex);
          pathindex += 1;
        }

        if (Location.equals(newLocation2))  {
          pathindex = 1;
          targetIsSet=false;
          capturedpath = new Path();
          //println();
        }
        if(pathindex > capturedpath.path.size())
        {
          pathindex=1;
          capturedpath = new Path();
        }
      }
      

    }
    
  }
   
    ///////////////////////////////// UPDATE
    ///////////////////////////////// CHARACTER/////////////////////////////////////

    void updateChar() {
      float delt = (float) 0.8;

      Location = Location.add(PVector.mult(Velocity, delt));
      Velocity = Velocity.add(Acceln.mult(delt));
      Orientation += characterRotation * delt;
      characterRotation += steering_angular * delt;

      if (counter == 5 && monster==false) {
        Crumbs.add(new PVector(Location.x, Location.y));
        counter = 0;
      }
      
      charsource = findClosestNode(Location);
      

    }
    
    void scaledown()
    {
      translate(width/2, height/2);
      scale(0.5);
      drawMyChar();
      //translate(-width/2, -height/2);

    }

  }
