//2018/May/04 11:56 PM
//Zhaocheng Li

/*game design: ask user on console to see if user want to continue or stop, while showing the total points the user has. If the user says to continue, automatically, randomly generate random point and sum it up by the rule. Loop over and over until the user says to stop.*/

/*idea: to it to another level --- let 3 players play and find a winner*/

import java.util.*;
import java.util.concurrent.TimeUnit;

public class Blackjack{
	//blobal variables
	static int tot = 1000000;
	static int bet = 0;
	
	
	public static void main(String[] args){
		Scanner scan = new Scanner(System.in);
		Random rand = new Random(); 
		Power_up(scan, rand);
	}
	
	public static void Power_up(Scanner scan, Random rand){
		System.out.println("Welcome! Do you want to play blackjack?: Yes/No");
		String res=scan.next();
		//System.out.println(res.toUpperCase()=="YES");//false
		//NOTICE: .toUpperCase() create a new object;
		if (res.toUpperCase().equals("YES")){
			System.out.println("Let's play!");
			Bet(scan, rand);
		}
		
		else if (res.toUpperCase().equals("NO")){
			System.out.println("Bye! Hope to see you soon!");
			System.exit(0);
		}
		
		else{
			while(!res.toUpperCase().equals("YES") && !res.toUpperCase().equals("NO")){
				System.out.println("Implicit command: please try again");
				Power_up(scan,rand);
			
			}
		}
	}
	
	public static void Bet(Scanner scan, Random rand){
		System.out.println("Conguatulation! You have entered the game as a millionair!");
		System.out.println("Money available: "+tot);
		System.out.println("Please bet, the min. bet = 300, the max. bet = 5k");
		bet = scan.nextInt();
		while (bet<300 || bet>5000){
			System.out.println("Wrong amount: the bet must be above or euqal to the min. bet, and be below or equal to the max. bet");
			bet = scan.nextInt();
		}
		System.out.println("You bet for this round: $"+bet);
		Shuffle(scan, rand);
	}
	
	public static void Shuffle(Scanner scan, Random rand){
		System.out.print("Shuffling the cards ");
		int uc1=0;
		int uc2=0;
		int dc1=0;
		int dc2=0;
		String u1="";
		String u2="";
		String d1="";
		String d2="X"; //covered at this moment;
		try{
			
			for (int i=0;i<6;i++){
				//TimeUnit.SECONDS.sleep(1);
				System.out.print(". ");
				Thread.sleep(1000);
				//TimeUnit.SECONDS.sleep(1);
			}
			System.out.print("\n");
			System.out.println("Starting drawing cards:");
			Thread.sleep(1000);			
			uc1=rand.nextInt(13)+1;
			u1=Cards(uc1);
			System.out.print("First Card for you: ");
			Thread.sleep(3000);
			System.out.println(u1);	
			Thread.sleep(1000);
			dc1=rand.nextInt(13)+1;
			d1=Cards(dc1);
			System.out.print("First Card for dealer: ");
			Thread.sleep(3000);
			System.out.println(d1);
			Thread.sleep(1000);
			uc2=rand.nextInt(13)+1;
			u2=Cards(uc2);
			System.out.print("Second Card for you :");
			Thread.sleep(3000);
			System.out.println(u2);
			dc2=rand.nextInt(13)+1;
			Thread.sleep(1000);
			System.out.print("Second Card for dealer :");
			Thread.sleep(3000);
			System.out.println(d2);
			user_play(scan,u1,u2);
		}
		catch (InterruptedException e){
			System.out.println("Interrupted! Shuffling failed");
			e.printStackTrace();
		}

	}
	
	public static String Cards(int draw){
		String out="";
		if (draw==1){
			out = "A";
		}
		else if (draw==2){
			out = "2";
		}
		else if (draw==3){
			out = "3";
		}
		else if (draw==4){
			out = "4";
		}
		else if (draw==5){
			out = "5";
		}
		else if (draw==6){
			out = "6";
		}
		else if (draw==7){
			out = "7";
		}	
		else if (draw==8){
			out = "8";
		}
		else if (draw==9){
			out = "9";
		}
		else if (draw==10){
			out = "10";
		}
		else if (draw==11){
			out = "J";
		}
		else if (draw==12){
			out = "Q";
		}
		else if (draw==13){
			out = "K";
		}
		return out;
	}
	
	public static int value(String out){
		int val=0;
		if (out=="A"){
			val=11;
		}
		else if (out=="2"){
			val=2;
		}
		else if (out=="3"){
			val=3;
		}
		else if (out=="4"){
			val=4;
		}
		else if (out=="5"){
			val=5;
		}
		else if (out=="6"){
			val=6;
		}
		else if (out=="7"){
			val=7;
		}
		else if (out=="8"){
			val=8;
		}
		else if (out=="9"){
			val=9;
		}
		else if (out=="10" || out=="J" || out=="Q" || out=="K"){
			val=10;
		}
		return val;
	}	
	
	public static void user_play(Scanner scan, String u1, String u2){
		int u1_val=0;
		int u2_val=0;
		int tot_val=0;
		System.out.println("User two-card combo: "+u1+" "+u2);
		u1_val=value(u1);
		u2_val=value(u2);
		tot_val=u1_val+u2_val;
		if ((u1=="A" || u2=="A") && (tot_val>21)){
			tot_val=tot_val-10;
		}
		System.out.println("Total value:" +tot_val);
		if (tot_val>21){
			System.out.println("Greater than 21, you BUST!");
		}
		else if (tot_val==21){
			System.out.println("Blackjack!!!");
		}
		else{
			System.out.println("Player options: Stand, Hit, or Double?");
			String res = scan.next();
			if (res.toUpperCase().equals("STAND")){
				System.out.println("Stand");
			}
			
			else if (res.toUpperCase().equals("HIT")){
				System.out.println("Hit");
			}
			
			else if (res.toUpperCase().equals("DOUBLE")){
				System.out.println("Doubles");
			}
		}
	}
	
	public static void dealer_play(String move, )
}



