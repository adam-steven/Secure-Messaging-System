//check if this header has already been included
#ifndef MIO_H
//include the header
#define MIO_H

#include <linux/ioctl.h>

//create a struct for transporting the rotation amount
typedef struct motor_rotate {
	int repeatAmount;
} motor_rotate;

//define the driver calls
#define IOCTL_WRITE_CLOCKWISE 0x65
#define IOCTL_WRITE_COUNTER_CLOCKWISE 0x66

//define the driver names
#define  DEVICE_NAME "steppermotor"
#define  CLASS_NAME  "motorcls"

#endif
