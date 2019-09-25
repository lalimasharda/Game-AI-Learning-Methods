class Node{
  String name;
  float h;
  PVector loc;
  ArrayList<String> neighbours = new ArrayList<String>();
  
  Node(String name, float nx, float ny){
    this.name=name;
    this.loc=new PVector(nx,ny);
  }
  
  //here we add the adjacent cities and their distance from the current city
  public void addAdjacentCity(String nname)
  {
    neighbours.add(nname);
  }
}
