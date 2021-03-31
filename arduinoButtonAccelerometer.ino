int led = 13;
int button = 12;
const int pinOfX = A0;
const int pinOfY = A1;
const int pinOfZ = A2;
const int GND = A4;  
const int PowerPIN = A5;

boolean drawModeOn = false;

void setup() {
pinMode(led, OUTPUT);
pinMode(button, INPUT);
Serial.begin(9600);
digitalWrite(led, LOW);
pinMode(GND , OUTPUT);     
pinMode(PowerPIN , OUTPUT);     
digitalWrite(GND , LOW);   // configuring the GND pin as LOW  
digitalWrite(PowerPIN , HIGH); // configuring the power pin HIGH (5V/3.3V) 
}

void loop(){ 
/*if(Serial.available() > 0) {
char ledState = Serial.read();
if(ledState == '1'){
digitalWrite(led, HIGH);
}
if(ledState == '0'){
digitalWrite(led, LOW);
}
}*/
int buttonState = digitalRead(button);

  
if (buttonState == HIGH){
    
    drawModeOn = !drawModeOn; //Swtich Drawmode

    //LED ON/OFF
    if(drawModeOn) { 
      digitalWrite(led, HIGH);
      Serial.println("on"); //Send to Processing
    }
     else {  
      digitalWrite(led, LOW);
      Serial.println("off"); //Send to Processing
    }

    
      
    delay(300);
  }
  
   // It prints the values of the sensors  
  if (drawModeOn == true){ 
      Serial.print(analogRead(pinOfX));   // print a tab between values:     
      Serial.print("\t");    
      Serial.print(analogRead(pinOfY));     
      Serial.print("\t");     
      Serial.print(analogRead(pinOfZ));     
      Serial.println();
  // It delays before next reading 
  delay(100);
  }
}
