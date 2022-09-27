
module FuzzyController(
input Clock, 
input Reset, 

input[pDataWidth-1:0] Error, 
input[pDataWidth-1:0] ErrorChange,
 
input[pFuzzyWidth*pNoOfMembers-1:0] ErrorMembership, 
input[pFuzzyWidth*pNoOfMembers-1:0] ErrorChangeMembership,

input[pFuzzyWidth*pNoOfMembers-1:0] OutputMembership,

output reg [pDataWidth-1:0] DCMotor
);

parameter pDataWidth = 4;
parameter pFuzzyWidth = 3;
parameter pNoOfMembers = 7;



endmodule


module Fuzzification(
input Clock, 
input Reset, 

input[pDataWidth-1:0] Data, 
 
input[pFuzzyWidth*pNoOfMembers-1:0] Membership, 

output reg ValidOut,
output reg [pFuzzyWidth-1:0] FuzzyData
);

parameter pDataWidth = 4;
parameter pFuzzyWidth = 3;
parameter pNoOfMembers = 7;

reg [pDataWidth-1:0] fuzzyPL;
reg [pDataWidth-1:0] fuzzyPM;
reg [pDataWidth-1:0] fuzzyPS;
reg [pDataWidth-1:0] fuzzyZ;
reg [pDataWidth-1:0] fuzzyNS;
reg [pDataWidth-1:0] fuzzyNM;
reg [pDataWidth-1:0] fuzzyNL;

reg [pNoOfMembers-1:0] fuzzyResult;


fuzzyPL[pDataWidth-1:0]={'0',Membership[pFuzzyWidth*1-1:0]};
fuzzyPM[pDataWidth-1:0]={'0',Membership[pFuzzyWidth*2-1:pFuzzyWidth]};
fuzzyPS[pDataWidth-1:0]={'0',Membership[pFuzzyWidth*3-1:pFuzzyWidth*2]};
fuzzyZ[pDataWidth-1:0]={'0',Membership[pFuzzyWidth*4-1:pFuzzyWidth*3]};
fuzzyNS[pDataWidth-1:0]={'1',Membership[pFuzzyWidth*5-1:pFuzzyWidth*4]};
fuzzyNM[pDataWidth-1:0]={'1',Membership[pFuzzyWidth*6-1:pFuzzyWidth*5]};
fuzzyNL[pDataWidth-1:0]={'1',Membership[pFuzzyWidth*7-1:pFuzzyWidth*6]};




endmodule