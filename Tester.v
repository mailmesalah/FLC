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



assign product=(fuzzyPL*8'b0)+(fuzzyPS*8'b0)+(fuzzyZ*8'b0)+(fuzzyNS*8'b0)+(fuzzyNL*8'b0);
assign sum=fuzzyPL+fuzzyPS+fuzzyZ+fuzzyNS+fuzzyNL;
assign CrispData=Divide(product,sum);

endmodule


