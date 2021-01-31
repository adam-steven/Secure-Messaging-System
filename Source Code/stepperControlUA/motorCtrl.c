#include "motorio.h"

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <string.h>

motor_rotate mrotate;

int main(int argc, char *argv[]) {

	int fd, ret;

	//access the LKM created stepper motor device drivers
	fd = open("//dev//steppermotor", O_RDWR);
	//check if the driver does not exit
	if (fd < 0) {
		printf("Can't open device file: %s\n", DEVICE_NAME);
		exit(-1);
	}

	if (argc > 1) {

		//proceed the second argument passed is "clockwise"
		if (!strncmp(argv[1], "clockwise", 10)) {
			//pass GPIO struct with IO control
			memset(&mrotate, 0, sizeof(mrotate));
			//convert the third argument string to int and save it in mrotate.h
			mrotate.repeatAmount = strtol(argv[2], NULL, 10);
			//call "IOCTL_WRITE_CLOCKWISE" in the LKM and mrotate
			ret = ioctl(fd, IOCTL_WRITE_CLOCKWISE, &mrotate);
		}

		//proceed the second argument passed is "anticlockwise"
		if (!strncmp(argv[1], "anticlockwise", 13)) {
			//pass GPIO struct with IO control
			memset(&mrotate, 0, sizeof(mrotate));
			//convert the third argument string to int and save it in mrotate.h
			mrotate.repeatAmount = strtol(argv[2], NULL, 10);
			//call "IOCTL_WRITE_COUNTER_CLOCKWISE" in the LKM and mrotate
			ret = ioctl(fd, IOCTL_WRITE_COUNTER_CLOCKWISE, &mrotate);
		}

	}

	close(fd);

	return 0;
}

