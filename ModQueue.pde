//Modified Queue class acts like a circular queue, but no information is ever removed.
//Rows of pixels corresponding to a frequency band are added to the end of the queue.
//Rows are displayed newest to oldest, at the top of the window. 

class ModQueue {
  int queueWidth;
  int queueDepth;
  float[][] queue;

  boolean full = false;
  int row = 0;

  ModQueue(int x, int y) {
    queueWidth = x;
    queueDepth = y;
    queue = new float[y][x];
  }

  float getValue(int x, int y) {
    return queue[y][x];
  }

  int numEntries() {
    int entries;
    if (!full) {
      entries = row + 1;
    } else {
      entries = queueDepth;
    }
    return entries;
  }

  int getNewest() {
    return row;
  }

  int getPrevious(int currentRow) {
    int previous;
    if (currentRow == 0) {
      previous = queueDepth-1;
    } else {
      previous = currentRow-1;
    }
    return previous;
  }
  
  int getNext(int currentRow){
    int next;
    if(currentRow == queueDepth-1){
      next = 0;
    } else {
      next = row +1;
    }
    return next;
  }

  void insert(float[] element) {
    row++;
    if (row==queueDepth) {
      row = 0;
    }
    if (this.numEntries() == queueDepth) {
      full = true;
    }
    arrayCopy(element, queue[row]);
  }

  void display(int x, int y) {
    int currentRow = row;
    push();
    colorMode(HSB, 360, 256, 256);
    for (int i = 0; i< this.numEntries(); i++) {
      for (int j = 0; j < bands; j++) {
        int fillColour = round(map(queue[currentRow][j], 0, 0.025, 0, 270));
        stroke((270-fillColour), 255, 255);
        point(x+j, y+i);
      }
      currentRow = getPrevious(currentRow);
    }
    pop();
  }
  
  
  float[][] getQueueSlice(int n){
    float[][] slice = new float[n][bands];
    
    int newestRow = this.getNewest();
    arrayCopy(queue[newestRow], slice[0]);
    
    for(int i = 1; i<n; i++){
      newestRow = this.getPrevious(newestRow);
      arrayCopy(queue[newestRow], slice[i]);
    }  
    return slice;
  }
}
