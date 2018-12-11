
/*
*NOTE: I used a 1 dimensional array instead of a 2d array due to the fact that it is
*faster to loop through it
*/
//the sand for the sandpile
int [] sand;
//a list of indexes of the cells greater than 3
int[] greaterThan4;
//an array that is a copy of greaterThan4 to prevent issues with the array being edited while being acessed
int[] copy;
//is the sandpile finished?
boolean stable = false;
int size;
//a value that keeps track of the next empty index of the greaterThan4 array to add another element
int index;
//like copy, this is another variable which is a copy of index to prevent editing while acessing issues
int z = 1;
//number of times the pile is toppled
int iters = 0;

void setup() {
  //initialization
  size(1000, 1000, P2D);
  sand = new int[width*height];
  size = width;
  index = 1;
  greaterThan4 = new int[width*height];
  greaterThan4[0] = greaterThan4[0] = ((((size-1)/2) * size) + ((size-1)/2));
  sand[greaterThan4[0]] = 1000000;
  copy = new int[width*height];
}

void draw() {
  //draw code
  render();
  //optional line to save each frame to a file in order to make a video with Tools > Movie Maker
  saveFrame("Images/Out_####.png");
}

void topple() {
  int iters = 0;
  while(!stable) {
      iters ++;
      //it is stable until reported unstable by if statements below
      stable = true;
      //update the copy
      for(int i = 0; i < z; i ++) {
        copy[i] = greaterThan4[i];
      }
      //loop through the elements of the greaterThan4 array that have been set
      for(int ii = 0; ii < z; ii ++) {
        int i = copy[ii];
        if(sand[i] >= 4) {
          //edit cells affected by toppling of each cell
          int num = sand[i];
          int k = (num - (num%4))/4;
          
          sand[i-1] += k;
          sand[i+1] += k;
          sand[i-size] += k;
          sand[i+size] += k;
          sand[i] -= k*4;
          
          //for each "if" statement below, it is a check if the tiles affected by the toppling of the current tile
          //checking if the original cell is below 4 (to prevent duplicates in greaterThan4)
          if(sand[i-1] <= k+3) {
            //set the element in the array
            greaterThan4[index] = (i-1);
            //add to the index
            index ++;
            //the sandpile becomes unstable
            stable = false;
          }
          if(sand[i+1] <= k+3) {
            greaterThan4[index] = (i+1);
            index ++;
            stable = false;
          }
          if(sand[i-size] <= k+3) {
            greaterThan4[index] = (i-size);
            index ++;
            stable = false;
          }
          if(sand[i+size] <= k+3) {
            greaterThan4[index] = (i+size);
            index ++;
            stable = false;
          } 
        }
      }
      //set the copies and reset the index because all information relating to the tiles greater than 4 is irrelivant after toppling those tiles
      z = index;
      index = 0;
      //take a temporary exit from the loop to update the frame
      if(iters == 100) {
        break;
      }
    }
}

void render() {
  topple();
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int num = sand[x*size + y];
      color col = color(0, 0, 0);

      switch(num) {
      case 0:
        col = color(255, 255, 0);
        break;
      case 1:
        col = color(0, 185, 63);
        break;
      case 2:
        col = color(0, 104, 255);
        break;
      case 3:
        col = color(122, 0, 229);
        break;
      }

      pixels[x+y*width] = col;
    }
  }
  updatePixels();
}
