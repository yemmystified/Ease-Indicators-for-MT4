//+------------------------------------------------------------------+
//|                                                       Marker.mq4 |
//|                                                     Yemmystifyed |
//|                                                    @Yemmystifyed |
//+------------------------------------------------------------------+
#property icon "\\Images\\watcher.ico"
#property copyright "Copyright 2022, @Yemmystifyed"
#property link      "@Yemmystifyed"
#property version   "1.00"
#property description "Watermarks your chart with the Symbol and Current TimeFrame"
#property strict
#property indicator_chart_window

//---- extern parameters
extern ENUM_BASE_CORNER BASE_CORNER = CORNER_LEFT_UPPER; //Choose Base Corner
extern string FontName           = "Impact";  // Type Desired Font Name
extern color colour              = C'49, 49, 49'; // Choose Color
extern int FontSize              = 50; // Change Font Size
extern int PosX                  = 50; // Choose X Position
extern int PosY                  = 50; // Choose Y Position

//---- data
string Pair = "Symbol";
string tf;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   switch(Period())
     {
      case PERIOD_M1:
         tf="M1";
         break;
      case PERIOD_M5:
         tf="M5";
         break;
      case PERIOD_M15:
         tf="M15";
         break;
      case PERIOD_M30:
         tf="M30";
         break;
      case PERIOD_H1:
         tf="H1";
         break;
      case PERIOD_H4:
         tf="H4";
         break;
      case PERIOD_D1:
         tf="D1";
         break;
      case PERIOD_W1:
         tf="W1";
         break;
      case PERIOD_MN1:
         tf="MN1";
         break;
      default:
         tf="UNKNOWN TF";
         break;
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
   backGround(Pair, Symbol() + "," + tf, FontSize, FontName, colour, PosX, PosY);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|          Method creation for Label                               |
//+------------------------------------------------------------------+
void backGround(string obj, string text, int fontSize, string fontName, color bcolour, int xPos, int yPos)
  {
   ObjectCreate(0,obj, OBJ_LABEL, 0, 0, 0);
   ObjectSetString(0,obj,OBJPROP_TEXT, text);
   ObjectSetInteger(0,obj,OBJPROP_COLOR,bcolour);
   ObjectSetString(0,obj,OBJPROP_FONT,fontName);
   ObjectSetInteger(0,obj,OBJPROP_FONTSIZE,fontSize);
   ObjectSetInteger(0,obj, OBJPROP_CORNER, BASE_CORNER);
   ObjectSetInteger(0,obj, OBJPROP_XDISTANCE, xPos);
   ObjectSetInteger(0,obj, OBJPROP_YDISTANCE, yPos);
   ObjectSetInteger(0,obj, OBJPROP_BACK, true);
   ObjectSet(obj, OBJPROP_HIDDEN, true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

   ObjectsDeleteAll(0, Pair);
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
