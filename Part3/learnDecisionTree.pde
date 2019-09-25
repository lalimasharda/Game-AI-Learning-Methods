ArrayList<Example> examples;
ArrayList<String> attributes;

void readData()
{
  examples = new ArrayList<Example>();
  attributes = new ArrayList<String>();
  
  String lines[] = loadStrings("behaviourData.txt");
  for (String line : lines)
  {
    String sp1[]=line.split(",");
    String sp2[]=sp1[0].split("-");
    if (sp2[1].equals("1") || sp2[1].equals("2") || sp2[1].equals("3") || sp2[1].equals("11") || sp2[1].equals("12"))
      sp2[1] = "11";
    if (sp2[1].equals("26") || sp2[1].equals("6") || sp2[1].equals("5") || sp2[1].equals("7"))
      sp2[1] = "6";
    if (sp2[1].equals("8") || sp2[1].equals("9") || sp2[1].equals("10"))
      sp2[1] = "10";
    if (sp2[1].equals("13") || sp2[1].equals("15") || sp2[1].equals("17") || sp2[1].equals("25") || sp2[1].equals("16") || sp2[1].equals("24") || sp2[1].equals("14") || sp2[1].equals("18"))
      sp2[1] = "16";
    if (sp2[1].equals("19") || sp2[1].equals("20") || sp2[1].equals("21") || sp2[1].equals("22") || sp2[1].equals("23"))
      sp2[1] = "23";

    float dist = Float.parseFloat(sp2[2]);
    if (dist<=500 && dist>300)
      sp2[2]="400";
    else if (dist<=300 && dist>100)
      sp2[2]="200";
    else if (dist>500)
      sp2[2]="500";
    else
      sp2[2]="100";

    Example ex = new Example(sp1[1], sp2[0], sp2[1], sp2[2]);
    examples.add(ex);
  }

  attributes = new ArrayList<String>();
  attributes.add("status");
  attributes.add("id");
  attributes.add("distance");
}

MultiDecision maketree(ArrayList<Example> examples, List<String> attributes, MultiDecision decNode)
{
  //println("maketree called");
  float initialentropy=entropy(examples);

  if (initialentropy<=0 || attributes.isEmpty())
  {
    int wanderc=0, pursuec=0, eatc=0, endc=0, dancec=0, followc26=0;
    for (Example e : examples)
    {
      if (e.action.equalsIgnoreCase("wander"))
        wanderc+=1;
      else if (e.action.equalsIgnoreCase("pursue"))
        pursuec+=1;
      else if (e.action.equalsIgnoreCase("eat"))
        eatc+=1;
      else if (e.action.equalsIgnoreCase("end"))
        endc+=1;
      else if (e.action.equalsIgnoreCase("dance"))
        dancec+=1;
      else if (e.action.equalsIgnoreCase("follow26"))
        followc26+=1;
    }

    String act;
    if (wanderc>pursuec && wanderc>eatc && wanderc>endc && wanderc>dancec && wanderc>followc26)
      act="wander";
    else if (wanderc<pursuec && pursuec>eatc && pursuec>endc && pursuec>dancec && pursuec>followc26)
      act="pursue";
    else if (wanderc<eatc && pursuec<eatc && eatc>endc && eatc>dancec && eatc>followc26)
      act="eat";
    else if (wanderc<endc && pursuec<endc && eatc<endc && endc>dancec && endc>followc26)
      act="end";
    else if (wanderc<dancec && pursuec<dancec && eatc<dancec && endc<dancec && dancec>followc26)
      act="dance";
    else
      act="followc26";

    decNode.action = act;
    //println(decNode.action);
    decNode.hasleaf = true;
    return decNode;
  }

  int exampleCount = examples.size();
  float bestInfoGain = 0;
  String bestSpltAtr ="";
  Map<String, ArrayList<Example>> bestSets = new HashMap<String, ArrayList<Example>>();

  for (String attr : attributes)
  {
    Map<String, ArrayList<Example>> sets = splitByAttribute(examples, attr);
    float overallEntr = entropyOfSets(sets, exampleCount);
    float infoGain = initialentropy - overallEntr;
    //println("init ent" + initialentropy);
    //println("overall ent" + overallEntr);
    

    if (infoGain>bestInfoGain)
    {
      bestInfoGain = infoGain;
      bestSpltAtr = attr;
      bestSets = sets;
    }
  }
  
  decNode.testValue = bestSpltAtr;
  //println(decNode.testValue);
  List<String> newattributes = new ArrayList<String>(attributes);
  newattributes.remove(bestSpltAtr);

  for (String key : bestSets.keySet())
  {
    //println("bestspltattr" + bestSpltAtr);
    String attrval = bestSets.get(key).get(0).getValue(bestSpltAtr);
    //println("attrval"+attrval);
    MultiDecision daughter = new MultiDecision();
    decNode.daughterNodes.put(attrval, daughter);

    maketree(bestSets.get(key), newattributes, daughter);
  }
  return decNode;
}

float entropy(ArrayList<Example> examples)
{
  float ent=0;

  int exCount = examples.size();

  if (exCount == 0)
    return 0;
  Map<String, Integer> actionTallies = new HashMap<String, Integer>();
  
  for (Example ex : examples)
  {
    if(!actionTallies.containsKey(ex.action))
    {
      actionTallies.put(ex.action,0);
    }
    int cnt = actionTallies.get(ex.action);
    actionTallies.put(ex.action, cnt+=1);
  }
  int actionCount=actionTallies.size();
  if (actionCount<=1)  
    return 0;

  float proportion;
  for (String action : actionTallies.keySet())
  {
    int actiontally = actionTallies.get(action);
    proportion = (float)actiontally/ (float)exCount;
    ent -= proportion*log2(proportion);
  }
  //println("ent", ent);
  return ent;
}

float log2(float proportion)
{
  return (float)(Math.log(proportion)/Math.log(2));
}

Map<String, ArrayList<Example>> splitByAttribute(ArrayList<Example> examples, String attr)
{
  Map<String, ArrayList<Example>> sets = new HashMap<String, ArrayList<Example>>();
  for (Example ex : examples)
  {
    if(!sets.containsKey(ex.getValue(attr)))
    {
      sets.put(ex.getValue(attr),new ArrayList<Example>());
    }
    sets.get(ex.getValue(attr)).add(ex);
  }
  return sets;
}


float entropyOfSets(Map<String, ArrayList<Example>> sets, int exampleCount)
{
  float ent=0;
  float proportion;
  for (String key : sets.keySet())
  {
    proportion = (float)sets.get(key).size()/(float)exampleCount;
    ent -= proportion*entropy(sets.get(key));
  }
  return ent;
}

class Example
{
  String action;
  String status;
  String id;
  String distance;

  Example(String action, String status, String id, String distance)
  {
    this.action=action;
    this.status=status;
    this.id=id;
    this.distance=distance;
  }

  String getValue(String attribute)
  {
    if (attribute.equalsIgnoreCase("status"))
      return status;
    else if (attribute.equalsIgnoreCase("id"))
      return id;
    else if (attribute.equalsIgnoreCase("distance"))
      return distance;

    return null;
  }
}
