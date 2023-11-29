#include <stdio.h>
#include <xgpio.h>
#include "xparameters.h"
#include "sleep.h"

int main()
{
   XGpio gpio0, gpio1;
   int button_data = 0;
   int switch_data = 0;

   XGpio_Initialize(&gpio0, XPAR_AXI_GPIO_0_DEVICE_ID);	//initialize input XGpio variable
   XGpio_Initialize(&gpio1, XPAR_AXI_GPIO_1_DEVICE_ID);	//initialize output XGpio variable

   XGpio_SetDataDirection(&gpio0, 1, 0x0);			//set first channel tristate buffer to output (LED)
   XGpio_SetDataDirection(&gpio0, 2, 0xF);			//set second channel tristate buffer to input (switch)

   XGpio_SetDataDirection(&gpio1, 1, 0xF);		//set first channel tristate buffer to input (button)

   while(1){
      switch_data = XGpio_DiscreteRead(&gpio0, 2);	//get switch data

      XGpio_DiscreteWrite(&gpio0, 1, switch_data);	//write switch data to the LEDs

      button_data = XGpio_DiscreteRead(&gpio1, 1);	//get button data

      //print message dependent on whether one or more buttons are pressed
      if(button_data == 0b00000){} //do nothing

      else if(button_data == 0b00001)
         xil_printf("button 0 pressed\n\r");

      else if(button_data == 0b00010)
         xil_printf("button 1 pressed\n\r");

      else if(button_data == 0b00100)
         xil_printf("button 2 pressed\n\r");

      else if(button_data == 0b01000)
         xil_printf("button 3 pressed\n\r");

      else if(button_data == 0b10000)
              xil_printf("button 4 pressed\n\r");

      else
         xil_printf("multiple buttons pressed\n\r");

      usleep(200000);			//delay

   }
   return 0;
}
