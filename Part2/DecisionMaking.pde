
boolean nearEdges()
{
  if ((width - obj[0].Location.x)<=100 || (width - obj[0].Location.y)<=100 || (obj[0].Location.x)<=100 || (obj[0].Location.y)<=100)
    return true;
  else
    return false;
}

boolean nearDoor()
{
  if (findClosestNode(obj[0].Location) == 7 || findClosestNode(obj[0].Location)==19)
    return true;
  else
    return false;
}

boolean nearInnerWalls()
{
  boolean flag = false;
  if ((550 - obj[0].Location.x)<=20 || (obj[0].Location.x - 600)<=20)
  {
    if ((obj[0].Location.y>=0 && obj[0].Location.y<=200) || (obj[0].Location.y>=300 && obj[0].Location.y<=600) || (obj[0].Location.y>=700 && obj[0].Location.y<=1000))
      flag = true;
    else
      flag=false;
  } else if ((400 - obj[0].Location.y)<=20 || (obj[0].Location.y - 450)<=20)
  {
    if ((obj[0].Location.x>=600 && obj[0].Location.x<=1000))
      flag = true;
    else
      flag=false;
  } else
    flag = false;

  return flag;
}
