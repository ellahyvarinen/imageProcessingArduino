int led = 13;
int button = 12;

boolean drawModeOn = false;

void setup() {
pinMode(led, OUTPUT);
pinMode(button, INPUT);
Serial.begin(9600);
digitalWrite(led, LOW);
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
    Serial.println(drawModeOn); //Send to Processing

    //LED ON/OFF
    if(drawModeOn) { 
      digitalWrite(led, HIGH);
    }
     else {  
      digitalWrite(led, LOW);
    }

    drawModeOn = !drawModeOn; //Swtich Drawmode
    
    delay(300);
  }
}
