//+------------------------------------------------------------------+
//|                                              MTFA_STF_Sample.mq4 |
//|                                   Copyright 2019, ARC LAB PTE.LTD|
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, ARC LAB PTE.LTD"
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

int start()
{
   int counted_bar = IndicatorCounted();
   int limit = Bars- counted_bar;
  
   //売買シグナルの作成
	for(int i = 0; i < limit; i++)
	{
		// 買いシグナルのバッファ
		BuySignal[i] = EMPTY_VALUE;
		// 売りシグナルのバッファ
		SellSignal[i] = EMPTY_VALUE;
	   
// -----------------------------------------------------
// ロジックを変更する場合主にここから下を修正
// -----------------------------------------------------

          
      double rsi1  = iRSI(NULL,0,14,PRICE_CLOSE,i);
      double rsi2  = iRSI(NULL,0,14,PRICE_CLOSE,i+1);
		
		//LOWシグナルの条件
		if(rsi1 >= 70 && rsi2 < 70 && (Close[i] - Open[i]) >= (High[i]-Low[i])*0.8)
		{
		   SellSignal[i] = iHigh(NULL,0,i) + Point * 10;
		}
		//HIGHシグナルの条件
		if(rsi1 <= 30 && rsi2 > 30 && (Open[i] - Close[i]) > 0.8*(High[i] - Low[i]))
		{
		   BuySignal[i] = iLow(NULL,0,i) - Point * 10;
		}
		
// -----------------------------------------------------
// ロジックを変更する場合主にここから上を修正
// -----------------------------------------------------
		
   }
   return(0);
}
   
   
   
   /*
   
   
   */
   
  /*
iOpen(NULL,PERIOD_M1,1)
以下で、例文の値の意味を詳細に説明します。
iOpen()
→（）の内側にある情報を基に、始値の値を計算する
NULL
→ EA又はチャートで現在指定している通貨ペア
PERIOD_M1
→ 1分足の値を取得
1
→ 現在のローソク足から1本前の値
*/