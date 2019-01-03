#include <XBee.h>
#include <SoftwareSerial.h>
#include <Servo.h>
#define MAX_FRAME_DATA_SIZE 12


XBee xbee = XBee();
XBeeResponse response = XBeeResponse();
Rx16Response rx16 = Rx16Response();
Servo MOTEUR1;
Servo MOTEUR2;
Servo SE1;
Servo SE2;
Servo SE3;
Servo SE4;
Servo SE5;
Servo SE6;

int M1 = 90;
int M2 = 90;
int angle = 0;
int vitesse = 0;
int pos1 = 90;
int pos2 = 20;
int pos3 = 0;
int pos4 = 180;
int pos5 = 90;
int pos6 = 20;
uint8_t rssi = 0;
uint8_t mode = 0;
uint8_t value_b1 = 0;
uint8_t value_b2 = 0;


void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
  xbee.setSerial(Serial1);
  MOTEUR1.attach(4);
  MOTEUR2.attach(5);
  SE1.attach(6);
  SE2.attach(7);
  SE3.attach(8);
  SE4.attach(9);
  SE5.attach(10);
  SE6.attach(11);

  SE1.write(pos1);
  SE2.write(pos2);
  SE3.write(pos3);
  SE4.write(pos4);
  SE5.write(pos5);
  SE6.write(pos6);
}


void loop() {
  xbee.readPacket();

  if (xbee.getResponse().isAvailable()) {
    if (xbee.getResponse().getApiId() == RX_16_RESPONSE) {
      xbee.getResponse().getRx16Response(rx16);

      rssi = rx16.getRssi();
      mode = rx16.getData(0);
      value_b1 = rx16.getData(1);
      value_b2 = rx16.getData(2);

      switch (mode) {
      case 0 : // Arrêt
        arret();
        break;
      case 1 : // Moteurs Vitesse
        moteurs_vitesse();
        break;
      case 2 : // Moteurs Angle
        moteurs_angle();
        break;
      case 3 : // Servo 1
        servo1();
        break;
      case 4 : // Servo 2
        servo2();
        break;
      case 5 : // Servo 3
        servo3();
        break;
      case 6 : // Servo 4
        servo4();
        break;
      case 7 : // Servo 5
        servo5();
        break;
      case 8 : // Servo 6
        servo6();
        break;
      }

      MOTEUR1.write(M1);
      MOTEUR2.write(M2);

    }
  }
}

void arret() {
  M1 = 90;
  M2 = 90;

  Serial.println("Arret");
}

void moteurs_vitesse() {
  vitesse = value_b2;

  Serial.print("Vitesse : ");
  Serial.println(vitesse);
}

void moteurs_angle() {
  angle = value_b2 + value_b1;

  Serial.print("Angle : ");
  Serial.println(angle);

  if ((angle >= 0) && (angle <= 90)) {
    M1 = 100 + 0.2 * vitesse;
    M2 = round( ( ((vitesse * angle) + 30000) )/300 );
  }
  if ((angle > 90) && (angle <= 180)) {
    M1 = round( ( (-(3 * vitesse * angle) + (540 * vitesse) + 89000) )/890);
    M2 = 100 + 0.2 * vitesse;
  }
  if ((angle > 180) && (angle <= 270)) {
    M1 = round( ( (-(vitesse * angle ) + (181 * vitesse) + 35600) )/445);
    M2 = 80 - 0.2 * vitesse;
  }
  if ((angle > 270) && (angle <= 359)) {
    M1 = 80 - 0.2 * vitesse;
    M2 = round( ( ((vitesse * angle) - (359 * vitesse)+35200) )/440);
  }

  if (vitesse == 0) {
    M1 = 90;
    M2 = 90;
  }

  Serial.print("Valeur au moteur 1 : ");
  Serial.println(M1);
  Serial.print("Valeur au moteur 2 : ");
  Serial.println(M2);
}

void servo1() {
  pos1 = value_b2;
  SE1.write(pos1);

  Serial.print("La valeur du servo1 est de : ");
  Serial.print(pos1);
  Serial.println(" degre.");
}

void servo2() {
  pos2 = value_b2;
  SE2.write(pos2);

  Serial.print("La valeur du servo2 est de : ");
  Serial.print(pos2);
  Serial.println(" degre.");
}

void servo3() {
  pos3 = value_b2;
  SE3.write(pos3);

  Serial.print("La valeur du servo3 est de : ");
  Serial.print(pos3);
  Serial.println(" degre.");
}

void servo4() {
  pos4 = value_b2;
  SE4.write(pos4);

  Serial.print("La valeur du servo4 est de : ");
  Serial.print(pos4);
  Serial.println(" degre.");
}

void servo5() {
  pos5 = value_b2;
  SE5.write(pos5);

  Serial.print("La valeur du servo5 est de : ");
  Serial.print(pos5);
  Serial.println(" degre.");
}

void servo6() {
  pos6 = value_b2;
  SE6.write(pos6);

  Serial.print("La valeur du servo6 est de : ");
  Serial.print(pos6);
  Serial.println(" degre.");
}


