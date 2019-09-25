class MultiDecision
{
  Map<String,MultiDecision> daughterNodes = new HashMap<String,MultiDecision>();//node value,node state
  String testValue;
  String action;
  boolean hasleaf = false;

  MultiDecision getBranch(Map<String,String> monstate)
  {
    //println("daughterNodes.get(monstate.get(testValue)),monstate.get(testValue), testvalue "+daughterNodes.get(monstate.get(testValue))+" "+monstate.get(testValue)+" "+testValue);
    if(daughterNodes.get(monstate.get(testValue)) == null)
    {
      MultiDecision newD = new MultiDecision();
      newD.action = "end";
      newD.hasleaf = true;
      return (newD);
    }
    else
      return daughterNodes.get(monstate.get(testValue));
  }
  
  MultiDecision makeDecision(Map<String,String> monstate)
  {
    MultiDecision branch = getBranch(monstate);

    if(this.daughterNodes.size()==0 || hasleaf)
    {
      //println("branch.action"+this.action);
      return this;
    }
    else
    {
      //println("branch.testValue"+branch.testValue);
      return branch.makeDecision(monstate);
    }
  }
}
