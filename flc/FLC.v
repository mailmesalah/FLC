module FuzzyController
(
input[7:0] Error, 
input[7:0] ErrorChange,
 
output [7:0] DCMotor
);

wire [7:0] ErFuzzyPL, ErFuzzyPS, ErFuzzyZ, ErFuzzyNS, ErFuzzyNL, ErChFuzzyPL, ErChFuzzyPS, ErChFuzzyZ, ErChFuzzyNS, ErChFuzzyNL, OutFuzzyPL, OutFuzzyPS, OutFuzzyZ, OutFuzzyNS, OutFuzzyNL;

	Fuzzification F1(Error, ErFuzzyPL, ErFuzzyPS, ErFuzzyZ, ErFuzzyNS, ErFuzzyNL);
	Fuzzification F2(ErrorChange, ErChFuzzyPL, ErChFuzzyPS, ErChFuzzyZ, ErChFuzzyNS, ErChFuzzyNL);

	RuleBase RB(ErFuzzyPL, ErFuzzyPS, ErFuzzyZ, ErFuzzyNS, ErFuzzyNL, ErChFuzzyPL, ErChFuzzyPS, ErChFuzzyZ, ErChFuzzyNS, ErChFuzzyNL, OutFuzzyPL, OutFuzzyPS, OutFuzzyZ, OutFuzzyNS, OutFuzzyNL);

	Defuzzification DF(OutFuzzyPL, OutFuzzyPS, OutFuzzyZ, OutFuzzyNS, OutFuzzyNL, DCMotor);

endmodule

module Fuzzification
(
input[7:0] CrispData, 
 
output [7:0] FuzzyPL,
output [7:0] FuzzyPS,
output [7:0] FuzzyZ,
output [7:0] FuzzyNS,
output [7:0] FuzzyNL
);

function [7:0] Divide;

input [7:0]a,b; 

reg [7:0] a1,b1,product;
integer i;

begin	
	a1=a;
	b1=b;
	product=0;
	for(i=0;i<8;i=i+1)
	begin
		product={product[6:0],a1[7]};
		a1[7:1]=a[6:0];
		product=product-b1;
		if(product[7]==1)
		begin
			a1[0]=0;
			product=product+b1;
		end
		else
		begin
			a1[0]=1;
		end
	end
	Divide=a1;
end
endfunction


function [7:0] Trapezoidal;

input [7:0]X,a,b,c,d; 


reg [7:0] slope1;
reg [7:0] slope2;

begin	

	if(X<=a)
	begin
		Trapezoidal=8'b00000000;
	end

	else if(X<b)
	begin
		slope1=Divide(8'b11111111,(b-a));
		Trapezoidal=(X-a)*slope1;
	end

	else if(X<=c)
	begin
		Trapezoidal=8'b11111111;	
	end

	else if(X<=d)
	begin
		slope2=Divide(8'b11111111,(d-c));
		Trapezoidal=8'b11111111-((X-c)*slope2);
	end	

	else 
	begin
		Trapezoidal=8'b00000000;
	end
end
endfunction

assign FuzzyNL=Trapezoidal(CrispData,8'b0,8'b0,8'b00101010,8'b01010101);//a=0,b=0,c=2A,d=55
assign FuzzyNS=Trapezoidal(CrispData,8'b00101010,8'b01010101,8'b01010101,8'b01111111);//a=2A,b=55,c=55,d=7F
assign FuzzyZ =Trapezoidal(CrispData,8'b01010101,8'b01111111,8'b01111111,8'b10101010);//a=55,b=7F,c=7F,d=AA
assign FuzzyPS=Trapezoidal(CrispData,8'b01111111,8'b10101010,8'b10101010,8'b11011010);//a=7F,b=AA,c=AA,d=DA
assign FuzzyPL=Trapezoidal(CrispData,8'b10101010,8'b11011010,8'b11111111,8'b11111111);//a=AA,b=DA,c=FF,d=FF

endmodule

module RuleBase
(
input [7:0] ErPL,
input [7:0] ErPS,
input [7:0] ErZ,
input [7:0] ErNS,
input [7:0] ErNL,

input [7:0] ErChPL,
input [7:0] ErChPS,
input [7:0] ErChZ,
input [7:0] ErChNS,
input [7:0] ErChNL,

output [7:0] OutPL,
output [7:0] OutPS,
output [7:0] OutZ,
output [7:0] OutNS,
output [7:0] OutNL
);

function automatic[7:0] Min;
input [7:0]a,b; 

begin
	
	if(a>b)
	begin
		Min=b;
	end

	else 
	begin
		Min=a;
	end
	
end
endfunction

function automatic[7:0] Max;
input [7:0]a,b; 

begin
	
	if(a>b)
	begin
		Max=a;
	end

	else 
	begin
		Max=b;
	end
	
end
endfunction


assign OutPL =Max(Max(Max(Min(ErPL,ErChPS),Min(ErPL,ErChPL)),Max(Min(ErPS,ErChPS),Min(ErPL,ErChPL))),Max(Min(ErZ,ErChPS),Min(ErZ,ErChPL))); 
assign OutPS =Max(Max(Max(Min(ErNS,ErChPS),Min(ErNS,ErChPL)),Min(ErNL,ErChPL)),Min(ErNL,ErChPS));
assign OutZ  =Min(ErZ,ErChZ);
assign OutNS =Max(Max(Max(Min(ErPL,ErChNL),Min(ErPL,ErChNS)),Min(ErPS,ErChNL)),Min(ErPS,ErChNS));
assign OutNL =Max(Max(Max(Max(Max(Max(Max(Max(Max(Min(ErPL,ErChPS),Min(ErPS,ErChZ)),Min(ErZ,ErChNL)),Min(ErZ,ErChNS)),Min(ErNS,ErChNL)),Min(ErNS,ErChNS)),Min(ErNS,ErChZ)),Min(ErNL,ErChNL)),Min(ErNL,ErChNS)),Min(ErNL,ErChZ));

endmodule

module Defuzzification
(
input [7:0] fuzzyPL,
input [7:0] fuzzyPS,
input [7:0] fuzzyZ,
input [7:0] fuzzyNS,
input [7:0] fuzzyNL,

output [7:0] CrispData
);

wire [7:0]sum,product;

function [7:0] Divide;

input [7:0]a,b; 

reg [7:0] a1,b1,product;
integer i;

begin	
	a1=a;
	b1=b;
	product=0;
	for(i=0;i<8;i=i+1)
	begin
		product={product[6:0],a1[7]};
		a1[7:1]=a[6:0];
		product=product-b1;
		if(product[7]==1)
		begin
			a1[0]=0;
			product=product+b1;
		end
		else
		begin
			a1[0]=1;
		end
	end
	Divide=a1;
end
endfunction



assign product=(fuzzyPL*8'b10000100)+(fuzzyPS*8'b10000010)+(fuzzyZ*8'b00000000)+(fuzzyNS*8'b00000100)+(fuzzyNL*8'b00000010);
assign sum=fuzzyPL+fuzzyPS+fuzzyZ+fuzzyNS+fuzzyNL;
assign CrispData=Divide(product,sum);

endmodule

