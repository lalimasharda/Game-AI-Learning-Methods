  
  boolean nearEdges()
  {
    if((width - ob.Location.x)<=100 || (width - ob.Location.y)<=100 || (ob.Location.x)<=100 || (ob.Location.y)<=100)
      return true;
    else
      return false;
  }
  
  boolean nearDoor()
  {
    if(findClosestNode(ob.Location).equalsIgnoreCase("7") || findClosestNode(ob.Location).equalsIgnoreCase("19"))
      return true;
    else
      return false;
  }
  
  boolean nearInnerWalls()
  {
    boolean flag = false;
    if((550 - ob.Location.x)<=20 || (ob.Location.x - 600)<=20)
    {
      if((ob.Location.y>=0 && ob.Location.y<=200) || (ob.Location.y>=300 && ob.Location.y<=600) || (ob.Location.y>=700 && ob.Location.y<=1000))
        flag = true;
      else
        flag=false;
    }
    else if((400 - ob.Location.y)<=20 || (ob.Location.y - 450)<=20)
    {
      if((ob.Location.x>=600 && ob.Location.x<=1000))
        flag = true;
      else
        flag=false;
    }
    else
      flag = false;
  
  return flag;
  }
