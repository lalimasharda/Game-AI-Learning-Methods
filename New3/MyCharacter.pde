
class MyCharacter{
    color mychar;
    PVector Location, Velocity, Acceln;
    float Orientation, characterRotation = 0, steering_angular = 0;

    ///////////////////////////////// DRAW
    ///////////////////////////////// CHARACTER/////////////////////////////////////

    void drawMyChar() {
      int x = 34;
      translate(Location.x, Location.y);
      rotate(Orientation);

      fill(mychar);
      stroke(0);
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
        goalspeed = maxvel;
      } else {
        goalspeed = maxvel * (distval / rod);
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
    
    
    /////////////////////////////////CHARACTER WANDER/////////////////////////////////////
   
   public int wander()
   {
     return ((int) (Math.random()*(26 - 1))) + 1;
     
   }
   
    ///////////////////////////////// UPDATE
    ///////////////////////////////// CHARACTER/////////////////////////////////////

    void updateChar() {
      float delt = (float) 0.8;

      Location = Location.add(PVector.mult(Velocity, delt));
      Velocity = Velocity.add(Acceln.mult(delt));
      Orientation += characterRotation * delt;
      characterRotation += steering_angular * delt;

      if (counter == 5) {
        Crumbs.add(new PVector(Location.x, Location.y));
        counter = 0;
      }
      
      source = findClosestNode(ob.Location);

      
    }

  }
