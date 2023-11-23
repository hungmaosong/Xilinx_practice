/*
 * main.c
 *
 *  Created on: 2020�~2��3��
 *      Author: user
 */


#include <stdio.h>
#include <xgpio.h>
#include "xparameters.h"
#include "sleep.h"

#define Green 0
#define Yellow 1
#define Red 2

void simple_delay(int simple_delay)
{
   volatile int i = 0;
   for (i = 0; i < simple_delay; i++)
      ;
}

int main()
{
   XGpio gpio0, gpio1;
   int led = 0;
   int switch_data;
   int button_data;

   int timer;
   int state;

   XGpio_Initialize(&gpio0, XPAR_AXI_GPIO_0_DEVICE_ID); // initialize input XGpio variable
   XGpio_Initialize(&gpio1, XPAR_AXI_GPIO_1_DEVICE_ID); // initialize output XGpio variable

   XGpio_SetDataDirection(&gpio0, 1, 0x0); // set first channel tristate buffer to output (LED)
   XGpio_SetDataDirection(&gpio0, 2, 0xF); // set second channel tristate buffer to input (switch)

   XGpio_SetDataDirection(&gpio1, 1, 0xF); // set first channel tristate buffer to input (button)
   
   //reset(button0)
   while (1)
   {
      button_data = XGpio_DiscreteRead(&gpio1, 1); // get button data
      switch_data = = XGpio_DiscreteRead(&gpio0, 2); // get switch data
      if (button_data == 0b00001)
      {
         if (switch_data == 0b00000001)
         {
            state = Green;
            timer = 7;
            break;
         }
         else
         {
            state = Green;
            timer = 15;
            break;
         }
      }
   }
   
   while(1){
      switch_data = XGpio_DiscreteRead(&switch_gpio, 1) // get switch data

      if(switch_data & 0b00000001 == 0)
      {
         simple_delay(100000000);

         timer--;
         if(timer == 0)
         {
            if(state == Green)
            {
               state = Yellow;
               timer = 1;
            }
            else if (state == Yellow)
            {
               state = Red;
               timer = 8;
            }
            else
            {
               state = Green;
               timer = 7;
            }            
         }
      }
      else
      {
         simple_delay(100000000);

         timer--;
         if (timer == 0)
         {
            if (state == Green)
            {
               state = Yellow;
               timer = 1;
            }
            else if (state == Yellow)
            {
               state = Red;
               timer = 16;
            }
            else
            {
               state = Green;
               timer = 15;
            }
         }
      }
      
     
   }
   return 0;
}
