class Graph{
  
  float edges[][] = new float[26][26];
  ArrayList<Node> nodes=new ArrayList<Node>();
  
  Graph()
  {
    for(int i=0;i<26;i++)
    {
      for(int j=0;j<26;j++)
      {
        edges[i][j]=-99;
      }
    }
    readFiles();
  }
  
  public void readFiles()
  {
    String nodelines[] = loadStrings("roomnodes.txt");
    String edgelines[] = loadStrings("roomedges.txt");
    //int i=0;
    for(String line:nodelines)
    {
      String text[]=line.split(" ");
      String name = text[0];
      float xc=Float.parseFloat(text[1]);
      float yc=Float.parseFloat(text[2]);
      
      nodes.add(new Node(name,xc,yc));
      //println(nodes.get(i++).name);
      
    }
    for(String line:edgelines)
    {
      String text[]=line.split(" ");
      int name1 = Integer.parseInt(text[1]);
      int name2 = Integer.parseInt(text[2]);
      float dist=Float.parseFloat(text[3]);
      
      edges[(name1)-1][(name2)-1]=dist;
      nodes.get((name1)-1).addAdjacentCity(Integer.toString(name2));
    }
    
  }
}
