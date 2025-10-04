#include <PID_v1.h>

const int trigPin = 9;    // Trig pin of the ultrasonic sensor (Yellow)
const int echoPin = 10;   // Echo pin of the ultrasonic sensor (Orange)
const int servoPin = 11;  // Servo Pin for MG996R

float Kp = 2.5;            // Proportional Gain
float Ki = 0.005;           // Integral Gain
float Kd = 0.5;            // Derivative Gain
double Setpoint, Input, Output, ServoOutput;                                       

PID myPID(&Input, &Output, &Setpoint, Kp, Ki, Kd, DIRECT); // Initialize PID
Servo myServo;                                             // Initialize Servo

const float beamLength = 39.0;  // Length of the beam in cm
const float neutralAngle = 37.0; // Neutral angle (parallel to ground) in degrees
const float maxAngle = 110.0;     // Maximum servo angle for tilting up (toward sensor)
const float minAngle = 0.0;      // Minimum servo angle for tilting down (toward end of beam)

void setup() {
  Serial.begin(9600);                            // Begin Serial communication
  myServo.attach(servoPin);                      // Attach the Servo to pin
  stopMotor();                                   // Start with the motor stopped

  Input = readPosition();                        // Get initial ball position
  
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);                                       
  myPID.SetMode(AUTOMATIC);                      // Set PID to AUTOMATIC mode
  myPID.SetOutputLimits(-70, 70);                // Output limits for servo angle adjustment
}

void loop() {
  delay(10);
  Setpoint = 18;                                 // Desired position (Setpoint) in cm
  Input = readPosition();                        // Get current ball position from sensor
  
  myPID.Compute();                               // Compute the PID output

  // Adjust servo angle based on the ball position
  if (Input > Setpoint) {
    // Ball is closer to the far end of the beam, increase servo angle to tilt toward the sensor
    ServoOutput = neutralAngle + abs(Output);    // Tilt the beam up
  } else {
    // Ball is closer to the ultrasonic sensor, decrease servo angle to tilt toward the end
    ServoOutput = neutralAngle - abs(Output);    // Tilt the beam down
  }
  
  // Constrain the servo angle to a valid range (between minAngle and maxAngle)
  ServoOutput = constrain(ServoOutput, minAngle, maxAngle);  
  myServo.write(ServoOutput);                    // Set the servo to balance the beam
  
  Serial.print("Servo Output (degrees): ");
  Serial.println(ServoOutput);
}

void stopMotor() {
  myServo.write(neutralAngle);  // Set servo to neutral (37 degrees), the balanced position
}

float readPosition() {
  delay(10);                                // Small delay for ultrasonic sensor reading      
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);
  float distance = duration * 0.034 / 2;    // Calculate distance in cm

  // Ensure the ball position is within the valid range (0 to beamLength)
  if (distance > beamLength || distance <= 0) {
    distance = beamLength;                  // Cap the distance to the length of the beam
  }
  
  Serial.print("Distance (cm): ");
  Serial.println(distance);
  return distance;
}