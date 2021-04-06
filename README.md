# imageProcessingArduino

### Github basics 

Install Git on your computer

Clone the Github repository with following command `git clone https://github.com/ellahyvarinen/imageProcessingArduino.git`

#### Pulling the latest version from Github
Locate to the folder in Terminal i.e. `cd Desktop/imageProcessingArduino`  
`git pull` pulls the latest version  


#### Pushing changes to Github

`git add .` adds all the changes to Git  
`git add filename.pde` adds the specific file to Git  
`git commit -m 'add message here'` adds the commit message  
`git push -u origin main` pushes the commit to Github  


### Drawing line example
```
void setup() {  
  size(640, 360);  
  background(0);  
  stroke(255);  
  strokeWeight(10);  
}  
  
void draw() {  
  //if (mousePressed == true) {}  
  line(mouseX, mouseY, pmouseX, pmouseY);  
}  
```
