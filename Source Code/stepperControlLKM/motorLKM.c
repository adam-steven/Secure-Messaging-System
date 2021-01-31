#include "motorio.h"

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
#include <linux/uaccess.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/gpio.h>
#include <linux/delay.h>
#include <linux/string.h>

static int DevBusy = 0;
static int MajorNum = 100;
static struct class*  ClassName = NULL;
static struct device* DeviceName = NULL;

motor_rotate mrotate;

//set gpio pins and step patterns
const int pinNums[4] = {17,18,27,22};
const int fullClockwise[4][4] = {{1,1,0,0},
								 {0,1,1,0},
								 {0,0,1,1},
								 {1,0,0,1}};

const int fullCounterClock[4][4] = {{1,0,0,1},							
									{0,0,1,1},								
									{0,1,1,0},
									{1,1,0,0}};


//allow for kernal access
static int motor_open(struct inode *inode, struct file *file){
	printk(KERN_INFO "motor: device_open(%p)\n", file);

	//indecate when the driver is busy
	if (DevBusy)
		return -EBUSY;

	DevBusy++;
	try_module_get(THIS_MODULE);
	return 0;
}

//allow for kernal release
static int motor_release(struct inode *inode, struct file *file){
	printk(KERN_INFO "motor: device_release(%p)\n", file);
	DevBusy--;

	module_put(THIS_MODULE);
	return 0;
}

//function to rotate the motor  clockwise
static void rotateClockwise(int amount)
{
	//amount 512 = full rotation , 256 = half rotation
	int steps;
	int numberOfAllocatedPins;
	int i,j,k;

	//get the number of steps and pin in the arrays
	steps = sizeof(fullClockwise) / sizeof(fullClockwise[0]);
	numberOfAllocatedPins = sizeof(pinNums) / sizeof(int);

	//loop through the sequence for "amount"
	for(i = 0; i < amount; i++){
		//loop through all the steps in the array
		for(j = 0; j < steps; j++)
		{
			//loop through all the pins in the array
			for(k = 0; k < numberOfAllocatedPins; k++)
				//set the current pins value to the current steps equivilant pin value 
				gpio_set_value(pinNums[k], fullClockwise[j][k]);
			//delay for 0.00001 milliseconds
			msleep(0.00001);
		}
	}

}

//function to rotate the motor counter clockwise
static void rotateCounterClockwise(int amount)
{
	//amount 512 = full rotation , 256 = half rotation
	int steps;
	int numberOfAllocatedPins;
	int i,j,k;

	//get the number of steps and pin in the arrays
	steps = sizeof(fullCounterClock) / sizeof(fullCounterClock[0]);
	numberOfAllocatedPins = sizeof(pinNums) / sizeof(int);

	//loop through the sequence for "amount"
	for(i = 0; i < amount; i++){
		//loop through all the steps in the array
		for(j = 0; j < steps; j++)
		{
			//loop through all the pins in the array
			for(k = 0; k < numberOfAllocatedPins; k++)
				//set the current pins value to the current steps equivilant pin value 
				gpio_set_value(pinNums[k], fullCounterClock[j][k]);
			//delay for 0.00001 milliseconds
			msleep(0.00001);
		}
	}
}

//communication interface with user application
static int device_ioctl(struct file *file, unsigned int cmd, unsigned long arg) {	

	printk("motor: Device IOCTL invoked : 0x%x - %u\n", cmd, cmd);

	//case which operation was called
	switch (cmd) {
		//for call clockwise function 
		case IOCTL_WRITE_CLOCKWISE:
			copy_from_user(&mrotate, (motor_rotate *)arg, sizeof(motor_rotate));
			rotateClockwise(mrotate.repeatAmount);
			break;
		//for call counter clockwise function 
		case IOCTL_WRITE_COUNTER_CLOCKWISE:
			copy_from_user(&mrotate, (motor_rotate *)arg, sizeof(motor_rotate));
			rotateCounterClockwise(mrotate.repeatAmount);
			break;
		//for inncorect arguments
		default:
			printk("motor: command format error\n");
	}

	return 0;
}

//holds pointers to functions defined by the driver
struct file_operations fops = {
	.unlocked_ioctl = device_ioctl,
	.owner = THIS_MODULE,
	.open = motor_open,
	.release = motor_release,
};

//LKM initilisation sequence
int __init motor_init(void){
	int numberOfAllocatedPins;
	int i;

	//register the device major number
	MajorNum = register_chrdev(0, DEVICE_NAME, &fops);
	if (MajorNum < 0) {
		printk(KERN_ALERT "motor: failed to register a major number\n");
		return MajorNum;
	}
	printk(KERN_INFO "motor: registered with major number %d\n", MajorNum);

	//register the device driver
	ClassName = class_create(THIS_MODULE, CLASS_NAME);
	if (IS_ERR(ClassName)) {
		unregister_chrdev(MajorNum, DEVICE_NAME);
		printk(KERN_ALERT "motor: Failed to register device class\n");
		return PTR_ERR(ClassName);
	}
	printk(KERN_INFO "motor: device class registered\n");

	//create the device driver
	DeviceName = device_create(ClassName, NULL, MKDEV(MajorNum, 0), NULL, DEVICE_NAME);
	if (IS_ERR(DeviceName)) {
		class_destroy(ClassName);
		unregister_chrdev(MajorNum, DEVICE_NAME);
		printk(KERN_ALERT "motor: Failed to create the device\n");
		return PTR_ERR(DeviceName);
	}
	printk(KERN_INFO "motor: device class created\n");
	
	//request all gpio pins needed
	numberOfAllocatedPins = sizeof(pinNums) / sizeof(int);
	for(i = 0; i < numberOfAllocatedPins; i++){
		gpio_request(pinNums[i], "A" + i);
		gpio_direction_output(pinNums[i], 0);
	}

    printk(KERN_INFO "motor: lkm loaded\n");
    return 0;
}

//LKM exit sequence
void __exit motor_exit(void){
	int numberOfAllocatedPins;
	int i;

	//unregister and destory the divice driver and major number
	device_destroy(ClassName, MKDEV(MajorNum, 0));
	class_unregister(ClassName);
	class_destroy(ClassName);
	unregister_chrdev(MajorNum, DEVICE_NAME);

	//free all gpio pins taken
	numberOfAllocatedPins = sizeof(pinNums) / sizeof(int);
	for(i = 0; i < numberOfAllocatedPins; i++){
		gpio_set_value(pinNums[i], 0);
			gpio_free(pinNums[i]);
	}

	printk(KERN_INFO "motor: lkm unloaded\n");
}
module_init(motor_init);
module_exit(motor_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("ADAM STEVEN");
MODULE_DESCRIPTION("Stepper Motor Control Module");
MODULE_VERSION("0.3");

//version log
	//v0.1 basic motor rotation on start up
	//v0.2 ioctl inplementation
	//v0.3 speed improvements

