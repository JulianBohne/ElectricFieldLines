
import java.util.Iterator;

Range range(int to){
  return new Range(to);
}

Range range(int from, int to){
  return new Range(from, to);
}

Range range(int from, int to, int step){
  return new Range(from, to, step);
}

class Range implements Iterable<Integer>{
  
  private int current;
  private int to;
  private int step;
  
  Range(int to){
    this(0, to, 1);
  }
  
  Range(int from, int to){
    this(from, to, 1);
  }
  
  Range(int from, int to, int step){
    if(step == 0) throw new IllegalArgumentException("Step can't be 0");
    this.current = from;
    this.to = to;
    this.step = step;
  }
  
  public Iterator<Integer> iterator(){
    return new RangeIterator();
  }
  
  class RangeIterator implements Iterator<Integer>{
    public boolean hasNext(){
      return current != to && ((step < 0) ^ (current < to));
    }
    
    public Integer next(){
      int tmp = current;
      current += step;
      return tmp;
    }
  }
}
