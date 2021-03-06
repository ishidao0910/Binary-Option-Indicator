//+------------------------------------------------------------------+
//|                    	Copyright 2018, MetaQuotes Software Corp. |
//|                                         	https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link  	"https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window //インジケータをチャート上に表示する
#property indicator_buffers 3 //インジケータのバッファを2つ用意
#property indicator_color1 Magenta //1つ目のインジケータを赤色に設定
#property indicator_color2 Aqua //2つ目のインジケータを青色に設定
#property indicator_color3 White
#property indicator_width1 3 //1つ目のインジケータの太さを3に設定
#property indicator_width2 3 //2つ目のインジケータの太さを3に設定
#property indicator_width3 2
double ArrowUp[];//上矢印
double ArrowDown[];//下矢印
double ThumbUp[];
input int MAPeriod = 288; //5分足で6時間分の計算
/*
input int RSIPeriod=14;//RSI計算期間
input double RSILine1=70;//下矢印を表示するライン
input double RSILine2=30;//上矢印を表示するライン
input int MINUTE=0;//勝率計算
*/
//+------------------------------------------------------------------+
//| Custom indicator initialization function                     	|
//+------------------------------------------------------------------+
int OnInit() //初期化関数
  {
//--- indicator buffers mapping
  //下矢印
  SetIndexBuffer(0, ArrowDown);//バッファを用意
  SetIndexStyle(0, DRAW_ARROW); //矢印を出す
  SetIndexArrow(0, 234); //矢印を下矢印に設定
  SetIndexEmptyValue(0, 0.0);
 
  //上矢印
  SetIndexBuffer(1, ArrowUp); //バッファを用意
  SetIndexStyle(1, DRAW_ARROW); //矢印を出す
  SetIndexArrow(1, 233); //矢印を上矢印に設定
  SetIndexEmptyValue(1, 0.0);
 
  SetIndexBuffer(2, ThumbUp); //バッファを用意
  SetIndexStyle(2, DRAW_ARROW); //矢印を出す
  SetIndexArrow(2, 67); //矢印を上矢印に設定
  SetIndexEmptyValue(2, 0.0);
 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                          	|
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
   int limit=Bars-IndicatorCounted();
   double sumdown=0;
   double sumup=0;
   double windown=0;
   double winup=0;
  
   for(int i=limit-1; i>=0; i--)
  	{
  	//インジケータの計算
  	
  	//double max = High[iHighest(NULL,0,MODE_HIGH,100,i+1)];
  	//double min = Low[iLowest(NULL,0,MODE_LOW,100,i+1)];

  	if(/*High[i+1] >= max && */EntitySize(i+1) > Average(MAPeriod,i+1) * 2 && (Close[i+1]-Open[i+1])>0 && ((High[i+1] - Close[i+1]) > 4*(Close[i+1] - Open[i+1]) || Close[i+1] == High[i+1]))
     	{
     	ArrowDown[i] = High[i] + 19 * Point;
     	}
  	else if(/*Low[i+1] <= min && */EntitySize(i+1) > Average(MAPeriod,i+1)*2 && (Open[i+1]-Close[i+1])>0 && ((Close[i+1] - Low[i+1]) > 4*(Open[i+1] - Close[i+1]) || Close[i+1] == Low[i+1]))
     	{
     	ArrowUp[i] = Low[i] - 19 * Point;
     	}
 	
  	if(ArrowDown[i]!=0)
     	{
     	sumdown++;
     	if(Open[i]>Close[i])
        	{
        	windown++;
        	ThumbUp[i] = High[i]+24 * Point;
        	}
     	}
  	else if(ArrowUp[i]!=0)
     	{
     	sumup++;
     	if(Open[i]<Close[i])
        	{
        	winup++;
        	ThumbUp[i] = Low[i] - 24 *Point;
        	}
     	}
     	
  	
  	
  	}
   if((sumdown)!=0 && sumup!=0)
  	{  
  	double win_rate=100*(windown+winup)/(sumdown+sumup);
  	double win_rate_down=100*(windown)/sumdown;
  	double win_rate_up=100*winup/sumup;
  	Print("矢印合計:",sumdown+sumup, " 勝ち矢印数:", windown+winup, " 負け矢印数:", sumdown+sumup-windown-winup, " 勝率:", win_rate,"%");
  	Print("下矢印勝率:",win_rate_down, "%"," 上矢印勝率:", win_rate_up,"%");
  	}
//--- return value of prev_calculated for next call
   return(rates_total);
  }
 
 
 
  //一定期間における移動平均線を計算
 
  double Average(int MAperiod,int shift){
   double mah = iMA(NULL, 0, MAperiod, 0, MODE_SMA, PRICE_HIGH, shift);
   double mal = iMA(NULL, 0, MAperiod, 0, MODE_SMA, PRICE_LOW, shift);
   return(MathAbs(mah-mal));
   }
  
//そして計算したロウソク足の大きさを計算する関数を作ります
  double EntitySize(int shift){
   double diff = iLow(Symbol(),0,shift) - iHigh(Symbol(),0,shift);
   return(MathAbs(diff));
   }
   
   //ここで出しているのはエントリー足の高値安値の幅だから、バカでかいひげをつけたときとかももれなく反応してしまうので、実体の大きさを使う方がいいかも。
  
 // MathAbsは絶対値を返す関数
 
 // 最後に計算したいロウソク足の大きさが平均に対してどれくらいの大きさをつけたか、条件分岐の式を書いてあげたら表現完了
 // if(EntitySize(i)*int mag > Average(30,i) && draw == true)
 
 // magには整数を入れることで実体に対して何倍の大きさをつけたかを表現することができる




