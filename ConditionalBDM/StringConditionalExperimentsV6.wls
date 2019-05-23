#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*String Conditional BDM.*)


(* ::Section:: *)
(*String BDM.*)


(* ::Input:: *)
(*SetDirectory[NotebookDirectory[]]*)


(* ::Input:: *)
(*D5 = <<"D5.m";*)


(* ::Text:: *)
(*Adding missing strings:*)


(* ::Input:: *)
(*D5=Flatten/@Append[D5,{{"000110100111",(5.21946101832149`*^-12)}}];*)
(*D5=Flatten/@Append[D5,{{"111001011000",(5.21946101832149`*^-12)}}];*)


(* ::Input:: *)
(*Table[HashStrings[D5[[i,1]]] = -Log[2,D5[[i,2]]],{i,Length@D5}];*)


(* ::Input:: *)
(*(* Table[HashStrings[D4[[i,1]]] = -Log[2,D4[[i,2]]],{i,Length@D4}]; *)*)


(* ::Input:: *)
(*(* Table[HashStrings[D3[[i,1]]] = -Log[2,D3[[i,2]]],{i,Length@D3}]; *)*)


(* ::Text:: *)
(*Strings of length 12 not appearing:*)


(* ::Input:: *)
(*N@HashStrings["000"]*)


(* ::Input:: *)
(*StringBDM[string_,len_:1]:= *)
(*N@Total[HashStrings[#[[1]]]+Log[2,#[[2]]]&/@Tally[If[TrueQ[StringLength[string]>12],StringPartition[string,12,len],{string}]]]*)


(* ::Chapter:: *)
(*Conditional String BDM.*)


(* ::Text:: *)
(*Functions to parse through shared members.*)


(* ::Input:: *)
(*NotIn[List[],rep_]:= List[]*)


(* ::Input:: *)
(*NotIn[x_,rep_]:=If[MemberQ[rep,x[[1]]],NotIn[x[[2;;]],rep],Prepend[NotIn[x[[2;;]],rep],x[[1]]]]*)


(* ::Input:: *)
(*Shrd[List[],rep_]:=List[]*)


(* ::Input:: *)
(*Shrd[x_,rep_]:= If[MemberQ[rep,x[[1]]],Prepend[Shrd[x[[2;;]],rep],x[[1]]],Shrd[x[[2;;]],rep]]*)


(* ::Input:: *)
(*RepM[x_,y_]:= If[x==y,1,x] (* Hack given that Log[1]=0 *)*)


(* ::Subsection:: *)
(*Conditional String BDM function.*)


(* ::Input:: *)
(*Remove[StringBDMC]*)


(* ::Input:: *)
(*StringBDMC[string_,string2_,len_:1]:= *)
(*N@Block[{ln= Min[12, StringLength[string2]]},*)
(*Block[{*)
(*part = StringPartition[string,ln,len],*)
(*part2 = StringPartition[string2,ln,len],*)
(*ay = Tally[StringPartition[string2,ln,len]]*)
(*},*)
(*Block[{t =Table[ny[ay[[i]][[1]]]=ay[[i]][[2]],{i,Length[ay]}]},*)
(*If[Length[Shrd[part, part2]]==0,StringBDM[string,len],*)
(*Total[(HashStrings[#[[1]]]+Log[2,#[[2]]])&/@Tally[NotIn[part, part2]]]*)
(*+ Total[Log[2,RepM[#[[2]],ny[#[[1]]]]]&/@Tally[Shrd[part, part2]]]*)
(*]*)
(*]*)
(*]*)
(*]*)


(* ::Input:: *)
(*StringBDMC["010101010101010101111","010",3]*)


(* ::Text:: *)
(*The next definition allows for setting a partition size.*)


(* ::Input:: *)
(*StringBDMC2[string_,string2_,partSize_,len_:1]:= *)
(*N@Block[{*)
(*part = StringPartition[string,partSize,len],*)
(*part2 = StringPartition[string2,partSize,len],*)
(*ay = Tally[StringPartition[string2,partSize,len]]*)
(*}, *)
(*Block[{t =Table[ny[ay[[i]][[1]]]=ay[[i]][[2]],{i,Length[ay]}]},*)
(*Total[(HashStrings[#[[1]]]+Log[2,#[[2]]])&/@Tally[NotIn[part, part2]]]*)
(*+ Total[Log[2,RepM[#[[2]],ny[#[[1]]]]]&/@Tally[Shrd[part, part2]]]*)
(*]*)
(*]*)
(**)


(* ::Input:: *)
(*StringBDMC2["010101010101010101111","000",3,3]*)


(* ::Section:: *)
(*Experiments.*)


(* ::Text:: *)
(*Lets start with a random string.*)


(* ::Input:: *)
(*SeedRandom[07082018]*)


(* ::Input:: *)
(*random[n_] := RandomInteger[{0,1},n]*)


(* ::Input:: *)
(*r1 = random[20]*)


(* ::Text:: *)
(*As expected, the conditional entropy and conditional BDM of this random string with itself should be 0.*)


(* ::Input:: *)
(*Statistics`Library`NConditionalEntropy[r1,r1]*)


(* ::Input:: *)
(*r1S = StringJoin[Map[ToString,r1]]*)


(* ::Input:: *)
(*StringBDMC[r1S,r1S,3]*)


(* ::Text:: *)
(*The partition size doesn't matter.*)


(* ::Input:: *)
(*Table[StringBDMC2[r1S,r1S,i,1],{i,20}]*)


(* ::Text:: *)
(*We can use a randomly generated string as a base to bigger strings. Conditional entropy should be now higher than zero with respect to the smaller, base string.*)


(* ::Input:: *)
(*rSmall = random[5]*)


(* ::Input:: *)
(*rLarge =Flatten[RandomChoice[{rSmall},4]]*)


(* ::Input:: *)
(*rSmallS = StringJoin[Map[ToString,rSmall]]*)


(* ::Input:: *)
(*rLargeS = StringJoin[Map[ToString,rLarge]]*)


(* ::Input:: *)
(*Statistics`Library`NConditionalEntropy[rLarge,rSmall]*)


(* ::Input:: *)
(*StringBDMC[rLargeS,rSmallS,StringLength[rSmallS]]*)


(* ::Subsection:: *)
(*Why Conditional BDM Works Over Different Partition Sizes, while Conditional Entropy Does Not. *)


(* ::Text:: *)
(*Now, I will analyze the behavior of conditional BDM and conditional Entropy over different partition sizes.*)


(* ::Input:: *)
(*ConditionalEntropyOfSize[s1_, s2_, pSize_, d_]:=Block[*)
(*{*)
(*p1 =Partition[s1,pSize,d],*)
(*p2 = Partition[s2,pSize,d]*)
(*},*)
(*Statistics`Library`NConditionalEntropy[p1,p2]*)
(*]*)


(* ::Text:: *)
(*We will generate a second random binary string. With high probability, we do not expect them to have shared information.   *)


(* ::Input:: *)
(*r2 = random[20]*)


(* ::Input:: *)
(*r2S= StringJoin[Map[ToString,r2]]*)


(* ::Input:: *)
(*Statistics`Library`NConditionalEntropy[r1,r2]*)


(* ::Text:: *)
(*However, we encounter a problem with the built in Mathematica conditional Entropy function.*)


(* ::Input:: *)
(*ConditionalEntropyOfSize[r1, r2, 5, 5]*)


(* ::Text:: *)
(*The value from above should not be zero. This is caused by the way  Mathematica computes entropy, lets look closer at each of the two strings:*)


(* ::Input:: *)
(*x=Map[StringJoin[ToString/@#]&,Partition[r1,5,5]]*)


(* ::Input:: *)
(*y =Map[StringJoin[ToString/@#]&,Partition[r2,5,5]]*)


(* ::Text:: *)
(*As we can see, each member are a different symbol therefore the inferred distributions are the same and each give no additional information over the other.*)


(* ::Text:: *)
(*I spent perhaps too much time trying to solve this problem, but I reached the conclusion that joint entropy is not defined for distributions with different alphabets, which is the case we have above. This is an important advantage of conditional BDM, as we are using the universal distribution with applies to all computable objects.*)


(* ::Text:: *)
(*For this reason, I will use the Normalized Compression Distance as a comparison point instead.*)


(* ::Subsection:: *)
(*Compared with Normalized Compression Distance.*)


(* ::Text:: *)
(*We can define the Normalized Compression Distance as follows:*)


(* ::Input:: *)
(*NCD[x_,y_]:=Block[{*)
(*cx = StringLength[Compress[x]],*)
(*cy=StringLength[Compress[y]],*)
(*cxy = StringLength[Compress[Join[x,y]]]*)
(*},*)
(*(cxy-Min[cx,cy])/Max[cx,cy]*)
(*]*)


(* ::Input:: *)
(*NCD[r1S,r1S]*)


(* ::Input:: *)
(*NCD[r1S,r2S]*)


(* ::Input:: *)
(*NCD[rLargeS,rSmallS]*)


(* ::Text:: *)
(*As shown in previous articles, NCD does not work very well on small strings but seems to be keeping the relationship we expect.*)


(* ::Input:: *)
(*StringBDMC[r1S,r2S,12]*)


(* ::Input:: *)
(*StringBDM[r1S,12]*)


(* ::Subsubsection:: *)
(*Conditional BDM over Two Randomly Generated Strings at Different Partitions Settings. *)


(* ::Text:: *)
(*Conditional BDM uses the entropy like behavior of BDM to compute its value. Given the difficulty of computing an approximation of K(x|y), which would require a CTM-like method using Turing Machines with inputs, Conditional BDM can be seen as a generalization of conditional Entropy over the space all computable objects, using the universal distribution as the base distribution.*)


(* ::Input:: *)
(*x = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*r1 =  StringJoin[Map[ToString,random[20]]],*)
(*r2= StringJoin[Map[ToString,random[20]]],*)
(*nPar = Length[Partition[r1,i,i]]*)
(*},*)
(*StringBDMC2[r1, r2, i, i]/nPar (* we divide between the approximate number of paritions.*)*)
(*]*)
(*,{j,5000}(* Number of samples *)*)
(*] //N*)
(*],{i,20}*)
(*]*)


(* ::Text:: *)
(*A  'hack' to make this work.*)


(* ::Input:: *)
(*StringBDM2[string_]:= *)
(*N@Total[HashStrings[#[[1]]]+Log[2,#[[2]]]&/@Tally[If[TrueQ[StringLength[string]>12],StringPartition[string,12],{string}]]]*)


(* ::Input:: *)
(*HashStrings[x_]:= StringBDM2[x]*)


(* ::Input:: *)
(*x1 = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*r1 =  StringJoin[Map[ToString,random[100]]],*)
(*r2= StringJoin[Map[ToString,random[100]]],*)
(*nPar =  Length[StringPartition[StringJoin[Map[ToString,random[100]]],i,i]]*)
(*},*)
(*StringBDMC2[r1, r2, i, i]/nPar (* we divide between the number of partitions.*)*)
(*]*)
(*,{j,15000} (* Number of samples *)*)
(*]//N*)
(*],{i,20}*)
(*]*)


(* ::Input:: *)
(*ListLinePlot[x1]*)


(* ::Subsubsection:: *)
(*We will now repeat the result over a biased distribution.*)


(* ::Input:: *)
(*f[x_]:=StringJoin[Map[ToString,x]]*)


(* ::Input:: *)
(*dist = PadRight[ConstantArray[1,3],20]*)


(* ::Input:: *)
(*x2 = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*r1 =  f[RandomChoice[dist, 100]],*)
(*r2= f[RandomChoice[dist, 100]],*)
(*nPar = Length[StringPartition[f[RandomChoice[dist, 100]],i,i]]*)
(*},*)
(*StringBDMC2[r1, r2, i, i]/nPar (* we divide between the number of partitions.*)*)
(*]*)
(*,{j,15000} (* Number of samples *)*)
(*]//N*)
(*],{i,20}*)
(*]*)


(* ::Input:: *)
(*ListLinePlot[x2]*)


(* ::Text:: *)
(*And now, both curves plotted together.*)


(* ::Input:: *)
(*ListLinePlot[{x1,x2}, *)
(*PlotStyle->{"97", Red},*)
(*PlotRangeClipping->False,*)
(*PlotMarkers->Automatic,*)
(*PlotLegends->*)
(*  Placed[LineLegend[{"Uniform","Biased"},*)
(*LegendFunction->(Framed[#,RoundingRadius->5]&),*)
(*LegendMargins->5],{0.80,0.23}],*)
(*AxesLabel->{None,"Normalized BDM Value"}]*)


(* ::Input:: *)
(*dist2 = PadRight[ConstantArray[1,5],20]*)


(* ::Input:: *)
(*x3 = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*r1 =  f[RandomChoice[dist2, 100]],*)
(*r2= f[RandomChoice[dist2, 100]],*)
(*nPar = Length[StringPartition[f[RandomChoice[dist, 100]],i,i]]*)
(*},*)
(*StringBDMC2[r1, r2, i, i]/nPar (* we divide between the number of partitions.*)*)
(*]*)
(*,{j,15000} (* Number of samples *)*)
(*]//N*)
(*],{i,20}*)
(*]*)


(* ::Input:: *)
(*dist3 = PadRight[ConstantArray[1,7],20]*)


(* ::Input:: *)
(*x4 = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*r1 =  f[RandomChoice[dist3, 100]],*)
(*r2= f[RandomChoice[dist3, 100]],*)
(*nPar = Length[StringPartition[f[RandomChoice[dist, 100]],i,i]]*)
(*},*)
(*StringBDMC2[r1, r2, i, i]/nPar (* we divide between the number of partitions.*)*)
(*]*)
(*,{j,15000} (* Number of samples *)*)
(*]//N*)
(*],{i,20}*)
(*]*)


(* ::Input:: *)
(*ListLinePlot[{x1,x2,x3, x4}, *)
(*PlotStyle->{"97", Red, Green, Cyan},*)
(*PlotRangeClipping->False,*)
(*PlotMarkers->Automatic,*)
(*PlotLegends->*)
(*  Placed[LineLegend[{"Uniform","Biased 3/20", "Biased 1/4", "Biased 7/20"},*)
(*LegendFunction->(Framed[#,RoundingRadius->4]&),*)
(*LegendMargins->5],{0.20,0.73}],*)
(*Frame->True,*)
(*FrameLabel->{"Partition Size","Normalised BDM Value"}*)
(*]*)


(* ::Text:: *)
(*We can see if the behavior changes by including overlapping.*)


(* ::Input:: *)
(*y = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*r1 =  StringJoin[Map[ToString,random[20]]],*)
(*r2= StringJoin[Map[ToString,random[20]]],*)
(*nPar = Length[Partition[r1,i,1]]*)
(*},*)
(*StringBDMC2[r1, r2, i, 1]/nPar*)
(*]*)
(*,{j,1000}(* Number of samples *)*)
(*] //N*)
(*],{i,20}*)
(*]*)


(* ::Input:: *)
(*ListLinePlot[y]*)


(* ::Text:: *)
(*As expected, the maximum value is where the transition from CTM to BDM, the drop is because we start using BDM instead of CTM for big partition sizes.*)


(* ::Subsubsection:: *)
(*Conditional BDM Over Biased Strings.*)


(* ::Text:: *)
(*Lets start with two random strings generated over a biased distribution.*)


(* ::Input:: *)
(*r1b =RandomChoice[{0,0,1},20]*)


(* ::Input:: *)
(*r2b = RandomChoice[{0,0,1},20]*)


(* ::Input:: *)
(*Statistics`Library`NConditionalEntropy[r1b,r2b]*)


(* ::Text:: *)
(*As I have shown that makes little sense to consider block entropy, In this little experiment I will focus on conditional BDM with partition size of 1.*)


(* ::Input:: *)
(*r1bS=StringJoin[Map[ToString,r1b]]*)


(* ::Input:: *)
(*r2bS=StringJoin[Map[ToString,r2b]]*)


(* ::Input:: *)
(*StringBDMC2[r1bS,r2bS,1,1]*)


(* ::Text:: *)
(*As shown bellow, this value is lower than the one's from unrelated strings, as they give us less information from each other.*)


(* ::Input:: *)
(*StringBDMC2[r1S,r2S,1,1]*)


(* ::Text:: *)
(*We can repeat this experiment over a big sample set to get an approximation to the expected quotient.*)


(* ::Input:: *)
(*f[x_]:=StringJoin[Map[ToString,x]]*)


(* ::Input:: *)
(*f[r1]*)


(* ::Input:: *)
(*x = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*dist = PadRight[ConstantArray[1,j],20]*)
(*},*)
(*Block[{*)
(*s=SeedRandom[RandomInteger[{0,999*10^9}]],*)
(*r1 = f[RandomChoice[dist, 20]],*)
(*r2= f[RandomChoice[dist, 20]],*)
(*(*Random unrelated String*)*)
(*rU =f[random[20]]*)
(*},(StringBDMC2[r1,r2,1,1]+1)/(StringBDMC2[r1,rU,1,1]+1)*)
(*]*)
(*]*)
(*,{i,15000}]*)
(*],{j,19}*)
(*]*)


(* ::Input:: *)
(*p1=ListLinePlot[x]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}*)


(* ::Input:: *)
(*PadRight[ConstantArray[1,20],20]*)


(* ::Text:: *)
(*Lets compare this behavior with Conditional Entropy.*)


(* ::Input:: *)
(*y = Table[*)
(*Mean[*)
(*Table[*)
(*Block[*)
(*{*)
(*dist = PadRight[ConstantArray[1,j],20]*)
(*},*)
(*Block[{*)
(*r1 = RandomChoice[dist, 20],*)
(*r2= RandomChoice[dist, 20],*)
(*(*Random unrelated String*)*)
(*rU =random[20]*)
(*},(Statistics`Library`NConditionalEntropy[r1,r2]+1)/(Statistics`Library`NConditionalEntropy[r1,rU]+1)*)
(*]*)
(*]*)
(*,{i,15000}]*)
(*],{j,19}*)
(*]*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*p2=ListLinePlot[y, PlotStyle->Red]*)


(* ::Text:: *)
(*Lets normalize and combine both plots.*)


(* ::Subsubsection:: *)
(*Trying to put legends on the plots.*)


(* ::Input:: *)
(*p1 = ListLinePlot[x/Max[x],PlotRange->{{0,19},{0.4,1}}, PlotLegends->"Conditional BDM"]*)


(* ::Input:: *)
(*x*)


(* ::Input:: *)
(*y*)


(* ::Input:: *)
(*Range[19,19+19]*)


(* ::Input:: *)
(*ListLinePlot[{y/Max[y],x/ Max[x]}, *)
(*PlotRange->{{1,19},{0.4,1}},*)
(*PlotStyle->{"97", Red},*)
(*PlotRangeClipping->False,*)
(*PlotMarkers->Automatic,*)
(*FrameTicks->{Range[19,19+18], Automatic},*)
(*PlotLegends->*)
(*  Placed[LineLegend[{"H(X|Y)","BDM(X|Y)"},*)
(*LegendFunction->(Framed[#,RoundingRadius->1]&),*)
(*LegendMargins->5],{0.51,0.23}],*)
(*Frame->True,*)
(*FrameLabel->{"Bias Coefficient","Normalized Value"}*)
(*]*)
