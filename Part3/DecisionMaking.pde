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
