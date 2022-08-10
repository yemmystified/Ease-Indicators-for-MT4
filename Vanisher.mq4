//+------------------------------------------------------------------+
//|                                                     Vanisher.mq4 |
//|                                                     Yemmystifyed |
//|                                                    @Yemmystifyed |
//+------------------------------------------------------------------+
#property icon "\\Images\\watcher.ico"
#property copyright "Copyright 2022, @Yemmystifyed"
#property link      "@Yemmystifyed"
#property version   "1.01"
#property strict
#property indicator_chart_window


#property description "Set Visibility of top right button to false but still be able to use keys"
#property description "Press I on Keyboard to hide trade levels"
#property description "Press O on Keyboard to show trade levels"


string show_button = "toggle"; //button string identifier
extern bool isVisible = false; // toggle visibility

//Keys to toggle trade line visibility
#define KEY_I              73
#define KEY_O              79
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   if(isVisible == true)
     {
      // Create a Button to show or hide the Monthly TF candles
      ObjectCreate(0, show_button, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, show_button, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, show_button, OBJPROP_XSIZE, 20);
      ObjectSetInteger(0, show_button, OBJPROP_YDISTANCE, 0);
      ObjectSetInteger(0, show_button, OBJPROP_YSIZE, 20);
      ObjectSetInteger(0, show_button, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSet(show_button, OBJPROP_COLOR, clrOrangeRed);
      ObjectSet(show_button, OBJPROP_SELECTABLE, false);
      ObjectSet(show_button, OBJPROP_HIDDEN, isVisible);
      ObjectSetText(show_button, "O", 4, "Arial Black", clrRed);
      //--- define font
      ObjectSetString(0,show_button,OBJPROP_FONT,"Arial Black");
      //--- define font size
      ObjectSetInteger(0,show_button,OBJPROP_FONTSIZE,10);
      ObjectSetInteger(0, show_button, OBJPROP_STATE, false);
     }
   else
     {

     }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| The function enables/disables trading levels display mode.       |
//+------------------------------------------------------------------+
bool ChartShowTradeLevelsSet(const bool value,const long chart_ID=0)
  {
//--- reset the error value
   ResetLastError();
//--- set property value
   if(!ChartSetInteger(chart_ID,CHART_SHOW_TRADE_LEVELS,0,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }


//+------------------------------------------------------------------+
//| ChartEvent function for object clicked                           |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event identifier
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {



   bool button_state = ObjectGet(show_button, OBJPROP_STATE); // To get the state of the button Pressed/Released

//--- the mouse has been clicked on the graphic object
//if(id==CHARTEVENT_OBJECT_CLICK)
   if(id==CHARTEVENT_OBJECT_CLICK || id == CHARTEVENT_KEYDOWN)
     {
      //--- Show Candles when button has been clicked
      //if(sparam==show_button && button_state == false)
      if((sparam==show_button && button_state == false) || int(lparam) == KEY_I)
        {
         ChartShowTradeLevelsSet(false,0);
         ObjectSetText(show_button, "I", 11, "Arial Black", clrLime);
         ObjectSet(show_button, OBJPROP_COLOR, clrLime);
         //--- define font
         ObjectSetString(0,show_button,OBJPROP_FONT,"Arial Black");
         //--- define font size
         ObjectSetInteger(0,show_button,OBJPROP_FONTSIZE,10);
         ObjectSetString(0, show_button, OBJPROP_TOOLTIP, "Enable Trade Levels!");

        }
      //--- Hide Candles when button has been clicked
      //if(sparam==show_button && button_state == true)
      else
         if((sparam==show_button && button_state == true) || int(lparam) == KEY_O)
           {
            ObjectSetText(show_button, "O", 11, "Arial Black", clrOrangeRed);
            ObjectSet(show_button, OBJPROP_COLOR, clrOrangeRed);
            //--- define font
            ObjectSetString(0,show_button,OBJPROP_FONT,"Arial Black");
            //--- define font size
            ObjectSetInteger(0,show_button,OBJPROP_FONTSIZE,10);
            ObjectSetString(0, show_button, OBJPROP_TOOLTIP, "Disable Trade Levels!");
            ChartShowTradeLevelsSet(true,0);


           }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

   ObjectsDeleteAll(0, show_button);
   return(0);
  }
//+------------------------------------------------------------------+
