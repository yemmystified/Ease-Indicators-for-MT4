//|                                                        Price.mq4 |
//|                                                     Yemmystifyed |
//|                                                    @Yemmystifyed |
//+------------------------------------------------------------------+
#property icon "\\Images\\watcher.ico"
#property copyright "Copyright 2022, @Yemmystifyed"
#property link      "@Yemmystifyed"
#property version   "1.00"
#property strict
#property description "Displays the Current market Price"
#property indicator_chart_window



bool   Bid_Ask_Colors = true; //Alternate Color
extern color  FontColor = C'202,202,202';  //Change Font Color
extern int    FontSize= 35; //Default font size
extern string FontType="Monotype Corsiva"; //Change Font Type
int    BaseCorner=3; //Choose Base Corner (1-4)
int LastDigitDiff = 10;


double        Old_Price;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("Market_Price_LabelA");
   ObjectDelete("Market_Price_LabelB");
   return(0);
  }

//+------------------------------------------------------------------+
//|                  Displays current price on chart                 |
//+------------------------------------------------------------------+
int start()
  {
   int DigitOffset = FontSize - 8;
//string BidA, BidB, Base_Price; //checked
   string BidA, Base_Price;
   if(Bid_Ask_Colors == True)
     {
      if(Bid > Old_Price)
         FontColor = C'255,150,150'; ;
      if(Bid < Old_Price)
         FontColor = clrGray;
      Old_Price = Bid;
     }

   Base_Price = DoubleToStr(Bid, Digits);   // Full base as string
   int SLength = StringLen(Base_Price);


   BidA = StringSubstr(Base_Price, 0, SLength); //unchecked

   ObjectCreate("Market_Price_LabelA", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Market_Price_LabelA", BidA, FontSize, FontType, FontColor);
   ObjectSet("Market_Price_LabelA", OBJPROP_CORNER, BaseCorner);
   ObjectSet("Market_Price_LabelA", OBJPROP_XDISTANCE, 10);
   ObjectSet("Market_Price_LabelA", OBJPROP_YDISTANCE, -10);
   ObjectSet("Market_Price_LabelA", OBJPROP_HIDDEN, true);


   return(0);

  }
//+------------------------------------------------------------------+
