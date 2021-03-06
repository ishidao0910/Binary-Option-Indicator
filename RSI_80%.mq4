//+------------------------------------------------------------------+
//|                                              RSI_80%.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_color1 Magenta
#property indicator_width1 2
#property indicator_color2 Yellow
#property indicator_width2 2

double BuySignal[];
double SellSignal[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorBuffers(2);

	SetIndexStyle(0, DRAW_ARROW);
	SetIndexArrow(0, 233);
	SetIndexBuffer(0, BuySignal);
	SetIndexLabel(0, "BuySignal");

	SetIndexStyle(1, DRAW_ARROW);
	SetIndexArrow(1, 234);
	SetIndexBuffer(1, SellSignal);
	SetIndexLabel(1, "SellSignal");
		
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
{
   int counted_bar = IndicatorCounted();
   int limit = Bars- counted_bar;
  
	for(int i = 0; i < limit; i++)
	{
		BuySignal[i] = EMPTY_VALUE;
		SellSignal[i] = EMPTY_VALUE;
	   


          
      double rsi1  = iRSI(NULL,0,14,PRICE_CLOSE,i);
      double rsi2  = iRSI(NULL,0,14,PRICE_CLOSE,i+1);
		
		if(rsi1 >= 70 && rsi2 < 70 && (Close[i] - Open[i]) >= (High[i]-Low[i])*0.8)
		{
		   SellSignal[i] = iHigh(NULL,0,i) + Point * 10;
		}
		if(rsi1 <= 30 && rsi2 > 30 && (Open[i] - Close[i]) > 0.8*(High[i] - Low[i]))
		{
		   BuySignal[i] = iLow(NULL,0,i) - Point * 10;
		}
   }
   return(0);
}