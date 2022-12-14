//+------------------------------------------------------------------+
//|                                                     Easekeys.mq4 |
//|                                                     Yemmystifyed |
//|                                                    @Yemmystifyed |
//+------------------------------------------------------------------+
#property icon "\\Images\\watcher.ico"
#property copyright "Copyright 2022, @Yemmystifyed"
#property link      "@Yemmystifyed"
#property version   "1.00"
#property strict
#property description "Zoom in (+) and out (-) with UP and DOWN direction on KeyBoard"
#property description "Cycle through TimeFrames with LEFT <> RIGHT direction on KeyBoard"
#property description "Press Z to create a Rectangle"
#property description "Press Y to activate the a Period Seperator"
#property description "Press X to create a Trendline"
#property description "Press V to create a Vertical Line"
#property description "Press H to create a Horizontal Line"
#property description "Press A to create a Text"
#property description "Press Q to create a Price Arrow"
#property description "Press S to take a screenshot of the current Chart it will be stored in the (Analysis) Data File Folder"
#property description "Press D to delete all Objects"


#property indicator_chart_window


string AnalysisFolder = "Analysis/"; //
string timedate = "``" +  IntegerToString(TimeDay(TimeCurrent())) + "-" +
                  IntegerToString(TimeMonth(TimeCurrent())) +
                  "-" + IntegerToString(TimeYear(TimeCurrent()))
                  + "``"+
                  IntegerToString(TimeHour(TimeCurrent())) + "h" +
                  IntegerToString(TimeMinute(TimeCurrent())) + "m" +
                  IntegerToString(TimeSeconds(TimeCurrent()), 2) + "s" + "``"
                  ;
string screenshot;
string comment = "Screenshot has been made into Data Folder directory - " + "MQL4/File/";

//for timezone offset calculation information
double hoursecs = 3600;
int OffSet = (int) MathAbs((TimeCurrent() - TimeLocal()) / hoursecs);     // Hoursecs is double|



#define KEY_RIGHT          39
#define KEY_LEFT           37
#define KEY_UP             38
#define KEY_DOWN           40
#define KEY_A              65
#define KEY_C              67
#define KEY_D              68
#define KEY_F              70
#define KEY_H              72
#define KEY_S              83
#define KEY_V              86
#define KEY_X              88
#define KEY_Y              89
#define KEY_Z              90
#define KEY_Q              81
#define KEY_TAB            9
#define KEY_K              75







//+------------------------------------------------------------------+
//|                                                                  |
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
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id == CHARTEVENT_KEYDOWN)
     {
      switch(int(lparam))
        {
         case KEY_UP:// Zoom into Chart
            zoomIn();
            break;

         case KEY_DOWN:// Zoom out of Chart
            zoomOut();
            break;

         case KEY_LEFT:// Cycle through periods in Descending order
            periodBefore();
            break;

         case KEY_RIGHT:// Cycle through periods in Ascending order
            periodNext();
            break;
         case KEY_D://Delete all objects on chart
            ObjectsDeleteAll(0,  "Rectangle_obj ");
            ObjectsDeleteAll(0,  "Trendline_obj ");
            ObjectsDeleteAll(0,  "Hline_obj ");
            ObjectsDeleteAll(0,  "Vline_obj ");
            ObjectsDeleteAll(0,  "Text_obj ");
            ObjectsDeleteAll(0,  "Arrow_obj ");


            break;
         case KEY_A://Place a Text Object on chart
            TextCreate(0,"Text_obj " + string(rand()), 0, TimeCurrent(), Ask,"Text", "Impact",20,C'49,49,49', 0.0, ANCHOR_LEFT_UPPER, true,true,InpHidden_OBJ,0);

            break;
         case KEY_K:// Displays the Broker/ server time, local time and the difference between them
            Alert("Time Current - Server - " + (string)TimeCurrent());
            Alert("Time Local " + (string)TimeLocal());
            Alert("The Time difference between the server or brokers time and your local time is --> " + (string)OffSet);
            break;
         case KEY_Q://Place a Left Price Label on chart
            ArrowCreate(0,"Arrow_obj " + string(rand()), 0, TimeCurrent(), Ask, 5, ANCHOR_BOTTOM, clrCrimson,0, 5, true,true,InpHidden_OBJ,0);

            break;
         case KEY_S:// Make a screenshot of current chart

            screenshot= AnalysisFolder + Symbol()+ stringMTF(Period())+ timedate;
            WindowScreenShot(screenshot + ".png",1362, 621, 0, -1, -1);
            Comment(comment + AnalysisFolder);
            break;
         case KEY_C:// Remove all Chart Comments
            Comment("");
            break;
         case KEY_Y://Activate or Deactivate Period Seperator on chart
            if(ChartGetInteger(0,CHART_SHOW_PERIOD_SEP)== 0)
              {
               ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, 1);
              }
            else
              {
               ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, 0);
              }
            break;
         case KEY_V://Place a Vertical Line on chart
            VLineCreate(0,"Vline_obj " + string(rand()), 0,TimeCurrent(), clrCrimson, line_style,line_width,true,true,InpHidden_OBJ,0);
            break;
         case KEY_H://Place a Horizontal Line on chart
            HLineCreate(0,"Hline_obj " + string(rand()), 0, Ask, clrCrimson, line_style,line_width,true,true,InpHidden_OBJ,0);
            break;

         case KEY_Z:   //This is to draw a rectangle
           {
            drawRec();

           }
         break;

         case KEY_X:   //This is to draw a Trendline
           {
            drawTrendLine();
           }
         break;
         case KEY_TAB: //Disable and Enable Chart Autoscroll and Shift
            if((ChartGetInteger(0,CHART_AUTOSCROLL)== 0 && ChartGetInteger(0,CHART_SHIFT)== 0)
               || (ChartGetInteger(0,CHART_AUTOSCROLL)== 0 && ChartGetInteger(0,CHART_SHIFT)== 1)
              )
              {
               ChartSetInteger(0, CHART_AUTOSCROLL, 1);
               ChartSetInteger(0, CHART_SHIFT, 1);
              }
            else
              {
               ChartSetInteger(0, CHART_SHIFT, 0);
               ChartSetInteger(0, CHART_AUTOSCROLL, 0);
              }
            break;
        }
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------+

// Cycle through periods in descending order
void periodBefore()
  {
//---
   if(ChartPeriod(0)==PERIOD_M5)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_M15)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M5);
      return;
     }
   if(ChartPeriod(0)==PERIOD_M30)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M15);
      return;
     }
   if(ChartPeriod(0)==PERIOD_H1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M30);
      return;
     }
   if(ChartPeriod(0)==PERIOD_H4)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_H1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_D1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_H4);
      return;
     }
   if(ChartPeriod(0)==PERIOD_W1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_D1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_MN1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_W1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_M1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_MN1);
      return;
     }
   if(GetLastError()>0)
     {
      Print("Error  (",GetLastError(),") ");
     }
   ResetLastError();
//---
  }
//+------------------------------------------------------------------+


// Cycle through periods in ascending order
void periodNext()
  {
//---
   if(ChartPeriod(0)==PERIOD_M1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M5);
      return;
     }
   if(ChartPeriod(0)==PERIOD_M5)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M15);
      return;
     }
   if(ChartPeriod(0)==PERIOD_M15)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M30);
      return;
     }
   if(ChartPeriod(0)==PERIOD_M30)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_H1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_H1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_H4);
      return;
     }
   if(ChartPeriod(0)==PERIOD_H4)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_D1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_D1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_W1);
      return;
     }
   if(ChartPeriod(0)==PERIOD_W1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_MN1);
      return;
     }
   if(ChartPeriod(0)>=PERIOD_MN1)
     {
      ChartSetSymbolPeriod(0,_Symbol,PERIOD_M1);
      return;
     }
   if(GetLastError()>0)
     {
      Print("Error  (",GetLastError(),") ");
     }
   ResetLastError();
//---
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zoomIn()
  {
//---
   if(ChartGetInteger(0,CHART_SCALE) == 0)
     {
      ChartSetInteger(0,CHART_SCALE,1);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 1)
     {
      ChartSetInteger(0,CHART_SCALE,2);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 2)
     {
      ChartSetInteger(0,CHART_SCALE,3);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 3)
     {
      ChartSetInteger(0,CHART_SCALE,4);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 4)
     {
      ChartSetInteger(0,CHART_SCALE,5);
      return;
     }
   if(GetLastError()>0)
     {
      Print("Error  (",GetLastError(),") ");
     }
   ResetLastError();
//---
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zoomOut()
  {
//---
   if(ChartGetInteger(0,CHART_SCALE) == 5)
     {
      ChartSetInteger(0,CHART_SCALE,4);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 4)
     {
      ChartSetInteger(0,CHART_SCALE,3);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 3)
     {
      ChartSetInteger(0,CHART_SCALE,2);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 2)
     {
      ChartSetInteger(0,CHART_SCALE,1);
      return;
     }
   if(ChartGetInteger(0,CHART_SCALE) == 1)
     {
      ChartSetInteger(0,CHART_SCALE,0);
      return;
     }
   if(GetLastError()>0)
     {
      Print("Error  (",GetLastError(),") ");
     }
   ResetLastError();
//---
  }
//+------------------------------------------------------------------+

//Draw Rectangle
void drawRec()
  {
   string name = "Rectangle_obj " + IntegerToString(MathRand() + 100,0,' ');

   y = y_coor + 9*y_rect + 10*x_step;
   ChartXYToTimePrice(0, x_coor + x_step, y, window, date_1, price_1);
   y = y_coor + 10*y_rect + 11*x_step;
   ChartXYToTimePrice(0, x_coor + 2*x_size, y, window, date_2, price_2);
   RectangleCreate(0,name,0,date_1,price_1,date_2,price_2,rect_color,rect_style,rect_width,true,true,true,InpHidden_OBJ,0);
  }

// Draw TrendLine
void drawTrendLine()
  {
   string name = "Trendline_obj " + IntegerToString(MathRand() + 100,0,' ');

   y = y_coor + 16*y_rect + 17*x_step;
   ChartXYToTimePrice(0, x_coor + x_step, y, window, date_1, price_1);
   ChartXYToTimePrice(0, x_coor + 2*x_size, y, window, date_2, price_2);
   TrendCreate(0,name,0,date_1,price_1,date_2,price_2,line_color,line_style,line_width,InpBackRect,true,false,false,InpHidden_OBJ,0);

  }





// Location of Objects on Screen
extern int x_coor = 10;    // Coordinate X
extern int y_coor = 20;    // Coordinate Y
int x_size = 220;
int y_size = 30;
int x_step = 6;
int y_panl = 20;
int x_rect = 17;
int y_rect = 30;
int y_line = 6;

// Rectangle and Trendline Options
extern color            rect_color =  C'49,49,49';    // Border Color (Rectangle)
extern ENUM_LINE_STYLE  rect_style =  STYLE_SOLID;    // Border Style (Rectangle)
extern int              rect_width =  1;              // Border Width (Rectangle)

extern color            line_color =  clrCrimson;     // TrendLine Color
extern ENUM_LINE_STYLE  line_style =  STYLE_SOLID;    // TrendLine Style
extern int              line_width =  1;              // TrendLine Width

// Data
datetime date_1     = 0;
double   price_1  = 0;
datetime date_2     = 0;
double   price_2  = 0;
int      window   = 0;
int      x        = 0;
int      y        = 0;

//Booleans
bool              InpHidden_OBJ     =  false;
bool              InpBackRect       =  false;


//+------------------------------------------------------------------+
//|      DRAW RECTANGLE                                              |
//+------------------------------------------------------------------+
bool RectangleCreate(const long            chart_ID=0,
                     const string          name="Rectangle",
                     const int             sub_window=0,
                     datetime              time1=0,
                     double                price1=0,
                     datetime              time2=0,
                     double                price2=0,
                     const color           clr=clrRed,
                     const ENUM_LINE_STYLE style=STYLE_SOLID,
                     const int             width=1,
                     const bool            fill=true,
                     const bool            back=true,
                     const bool            selection=true,
                     const bool            hidden=true,
                     const long            z_order=0)
  {
   ResetLastError();

   if(ObjectFind(name) == -1)
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2);

   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true);
  }
//+------------------------------------------------------------------+
//|       Delete Rectangle                                           |
//+------------------------------------------------------------------+
bool RectangleDelete(const long   chart_ID=0,
                     const string name="Rectangle")
  {
   ResetLastError();
   if(ObjectFind(chart_ID,name) >= 0)
      ObjectDelete(chart_ID,name);

   return(true);
  }
//+------------------------------------------------------------------+
//|       Create TrendLine                                           |
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,
                 const string          name="TrendLine",
                 const int             sub_window=0,
                 datetime              time1=0,
                 double                price1=0,
                 datetime              time2=0,
                 double                price2=0,
                 const color           clr=clrCrimson,
                 const ENUM_LINE_STYLE style=STYLE_SOLID,
                 const int             width=1,
                 const bool            back=false,
                 const bool            selection=true,
                 const bool            ray_left=false,
                 const bool            ray_right=false,
                 const bool            hidden=true,
                 const long            z_order=0)
  {

   ResetLastError();

   if(ObjectFind(name) == -1)
      ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY,ray_left);
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);

   return(true);
  }
//+------------------------------------------------------------------+
//| Delete TrendLine                                                 |
//+------------------------------------------------------------------+
bool TrendDelete(const long   chart_ID=0,
                 const string name="TrendLine")
  {

   ResetLastError();

   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": There has been an error which is = ",GetLastError());
      return(false);
     }

   return(true);
  }


//+------------------------------------------------------------------+
//| Create the vertical line                                         |
//+------------------------------------------------------------------+
bool VLineCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="VLine",      // line name
                 const int             sub_window=0,      // subwindow index
                 datetime              time=0,            // line time
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- if the line time is not set, draw it via the last bar
   if(!time)
      time=TimeCurrent();
//--- reset the error value
   ResetLastError();
//--- create a vertical line
   if(!ObjectCreate(chart_ID,name,OBJ_VLINE,sub_window,time,0))
     {
      Print(__FUNCTION__,
            ": failed to create a vertical line! Error code = ",GetLastError());
      return(false);
     }

   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }


//+------------------------------------------------------------------+
//| Create the horizontal line                                       |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="HLine",      // line name
                 const int             sub_window=0,      // subwindow index
                 double                price=0,           // line price
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- if the price is not set, set it at the current Bid price level
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- create a horizontal line
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price))
     {
      Print(__FUNCTION__,
            ": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }





//+------------------------------------------------------------------+
//| Creating Text object                                             |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // chart's ID
                const string            name="Text",              // object name
                const int               sub_window=0,             // subwindow index
                datetime                time=0,                   // anchor point time
                double                  price=0,                  // anchor point price
                const string            text="Text",              // the text itself
                const string            font="Arial",             // font
                const int               font_size=10,             // font size
                const color             clr=clrRed,               // color
                const double            angle=0.0,                // text slope
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                const bool              back=false,               // in the background
                const bool              selection=false,          // highlight to move
                const bool              hidden=true,              // hidden in the object list
                const int               xPos = 50,
                const int               yPos = 50,
                const long              z_order=0)                // priority for mouse click

  {
//--- set anchor point coordinates if they are not set
   ChangeTextEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the object by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//ObjectSetInteger(chart_ID,name, OBJPROP_XDISTANCE, xPos);
//ObjectSetInteger(chart_ID,name, OBJPROP_YDISTANCE, yPos);
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeTextEmptyPoint(datetime &time,double &price)
  {


//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_ASKHIGH);
  }




//+------------------------------------------------------------------+
//| Create the arrow                                                 |
//+------------------------------------------------------------------+
bool ArrowCreate(const long              chart_ID=0,           // chart's ID
                 const string            name="Arrow",         // arrow name
                 const int               sub_window=0,         // subwindow index
                 datetime                time=0,               // anchor point time
                 double                  price=0,              // anchor point price
                 const uchar             arrow_code=5,       // arrow code
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor point position
                 const color             clr=clrCrimson,           // arrow color
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style
                 const int               width=5,              // arrow size
                 const bool              back=true,           // in the background
                 const bool              selection=true,       // highlight to move
                 const bool              hidden=true,          // hidden in the object list
                 const long              z_order=0)            // priority for mouse click
  {
//--- set anchor point coordinates if they are not set
   ChangeArrowEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create an arrow
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return(false);
     }
//--- set the arrow code
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set the arrow color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set the arrow's size
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the arrow by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }




//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeArrowEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }


// Method to use the period symbol as used in MT$
string stringMTF(int perMTF)
  {
   if(perMTF==0)
      perMTF=_Period;
   if(perMTF==1)
      return(" M1");
   if(perMTF==5)
      return(" M5");
   if(perMTF==15)
      return(" M15");
   if(perMTF==30)
      return(" M30");
   if(perMTF==60)
      return(" H1");
   if(perMTF==240)
      return(" H4");
   if(perMTF==1440)
      return(" D1");
   if(perMTF==10080)
      return(" W");
   if(perMTF==43200)
      return(" MN");
   if(perMTF== 2 || 3  || 4  || 6  || 7  || 8  || 9 ||        ///
      10 || 11 || 12 || 13 || 14 || 16 || 17 || 18)
      return("M"+(string)_Period);
//------
   return("Period Error");
  }
//+------------------------------------------------------------------+
