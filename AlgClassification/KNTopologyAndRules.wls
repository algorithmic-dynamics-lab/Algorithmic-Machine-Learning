#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*Classifying NK Networks.*)


(* ::Text:: *)
(*In this experiment, we will classify NK networks according to its topology and underlying rules.*)


(* ::Subsubsection:: *)
(*Helper Functions.*)


(* ::Input:: *)
(*toBinaryInt[n_,bits_]:=IntegerDigits[n,2,bits]*)


(* ::Text:: *)
(*The following code contains snips from and code inspired by https://demonstrations.wolfram.com/BooleanNKNetworks/*)


(* ::Input:: *)
(*ConnectivityMatrix[n_,k_]:=Table[RandomSample[Flatten[Prepend[Table[0,{n-k}],Table[1,{k}]]]],{n}]*)


(* ::Input:: *)
(*InitialStates[n_]:=RandomInteger[1,n]*)


(* ::Input:: *)
(*PositionsMatrix[conM_]:=Map[Flatten,Position[#,1]&/@conM];*)


(* ::Input:: *)
(*evolve[state_, topo_]:=*)
(*Table[*)
(*With[*)
(*{*)
(*inputs = (topo["Connections"])[[i]],*)
(*trans = (topo["Rules"])[[i]]*)
(*},*)
(*trans[state[[inputs]]]*)
(*]*)
(*,{i,Length@state}]*)


(* ::Input:: *)
(*flattenEvo[ str_,net_,t_]:= Flatten@Rest@NestList[evolve[#,net]&,str,t] *)


(* ::Subsubsection:: *)
(*First, we will define a subset of Boolean functions (the Interesting ones).*)


(* ::Text:: *)
(*Lists of rules.*)


(* ::Input:: *)
(*binToBool[x_]:=*)
(*If[x==0,False,True]*)


(* ::Input:: *)
(*boolToBin[x_]:=*)
(*If[x,1,0]*)


(* ::Text:: *)
(*Unary*)


(* ::Input:: *)
(*rNot[{x_}]:= boolToBin@Not@binToBool@x*)


(* ::Input:: *)
(*rId[{x_}]:=x*)


(* ::Text:: *)
(*Binary*)


(* ::Input:: *)
(*rAnd[{x1_,x2_}]:= *)
(*boolToBin[(binToBool@x1)&&(binToBool@x2)]*)


(* ::Input:: *)
(*rOr[{x1_,x2_}]:= *)
(*boolToBin[(binToBool@x1)||(binToBool@x2)]*)


(* ::Input:: *)
(*rNand[{x1_,x2_}]:= *)
(*boolToBin[(binToBool@x1)\[Nand](binToBool@x2)]*)


(* ::Input:: *)
(*rXor[{x1_,x2_}]:= *)
(*boolToBin[(binToBool@x1)\[Xor](binToBool@x2)]*)


(* ::Text:: *)
(*Tertiary*)


(* ::Input:: *)
(*RuleK3A[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==3,1,0]*)


(* ::Input:: *)
(*RuleK3B[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==3,0,1]*)


(* ::Input:: *)
(*RuleK3C[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==2,1,0]*)


(* ::Input:: *)
(*RuleK3D[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==2,0,1]*)


(* ::Input:: *)
(*RuleK3E[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==1,1,0]*)


(* ::Input:: *)
(*RuleK3F[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==1,0,1]*)


(* ::Input:: *)
(*RuleK3G[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==0,1,0]*)


(* ::Input:: *)
(*RuleK3H[{x1_,x2_,x3_}]:=*)
(*If[x1+x2+x3==0,0,1]*)


(* ::Text:: *)
(*Function to randomly select rules.*)


(* ::Input:: *)
(*randomRule[k_]:=*)
(*Which[*)
(*k==1,RandomChoice[{rNot,rId}],*)
(*k==2,RandomChoice[{rAnd,rOr,rNand,rXor}], *)
(*(*  k\[Equal]2,RandomChoice[{rNand,rXor}],*)*)
(*k==3,RandomChoice[{RuleK3A,RuleK3B,RuleK3C,RuleK3D,RuleK3E,RuleK3F,RuleK3G,RuleK3H}]*)
(*]*)


(* ::Text:: *)
(*Function that generates a random NK network topology.*)


(* ::Input:: *)
(*randomNetwork[n_,k_]:=*)
(*With[*)
(*{*)
(*rules = RandomChoice[*)
(*randomRule[k]&/@Range[n]*)
(*,n],*)
(*connections = PositionsMatrix[ConnectivityMatrix[n,k]]*)
(*},*)
(*Association[*)
(*{*)
(*"Connections"->connections,*)
(*"Rules"-> rules*)
(*}*)
(*]*)
(*]*)


(* ::Text:: *)
(*Function that generates a random NK network topology with reduced number of rules.*)


(* ::Input:: *)
(*(* R is the number of rules on each network*)*)
(*randomNetwork[n_,k_,r_]:= *)
(*With[*)
(*{*)
(*rules = RandomChoice[*)
(*randomRule[k]&/@Range[r]*)
(*,n],*)
(*connections = PositionsMatrix[ConnectivityMatrix[n,k]]*)
(*},*)
(*Association[*)
(*{*)
(*"Connections"->connections,*)
(*"Rules"-> rules*)
(*}*)
(*]*)
(*]*)


(* ::Input:: *)
(*randomNetwork[10,2,4]*)


(* ::Chapter:: *)
(*The Sets.*)


(* ::Input:: *)
(*nSamples = 20*)


(* ::Input:: *)
(*nClasses = 10*)


(* ::Input:: *)
(*FactorInteger[nClasses]*)


(* ::Text:: *)
(*Network parameters.*)


(* ::Input:: *)
(*n = 4;*)
(*k = 2;*)
(*(* r = 4; *)*)
(*t =10;*)
(*ini = ConstantArray[0,n];*)


(* ::Text:: *)
(*We will choose 10 classes for each cases: topologies and rules.*)


(* ::Text:: *)
(*I will define a random rule function so that at least one NAND is present and the evolution can always scape from the cero case.*)


(* ::Input:: *)
(*randomRuleL[2,n_] := RandomSample[Flatten@{rNand, randomRule[2]&/@Range[n-1]} ]*)


(* ::Input:: *)
(*SeedRandom[4122019]*)
(*classesTopo = DeleteDuplicates[#["Connections"]&/@(randomNetwork[n,k]&/@Range[nClasses])]*)
(*classesRules = randomRuleL[k,n] &/@Range[nClasses]*)


(* ::Subsubsection:: *)
(*Topology Test Set.*)


(* ::Input:: *)
(*SeedRandom[4122019]*)
(**)
(*TrainingSetTopo = Flatten@Table[*)
(*With[*)
(*{tp = classesTopo[[j]]},*)
(*Table[*)
(*With[*)
(*{cn = randomRuleL[k,n] },*)
(*flattenEvo[ ini,*)
(*<|"Connections"-> tp,"Rules"-> cn|>,*)
(*t]->j*)
(*]*)
(*,{i,nSamples}]*)
(*]*)
(*,{j,Length@classesTopo}*)
(*];*)
(**)
(*ValidationSetTopo = Flatten@Table[*)
(*With[*)
(*{tp = classesTopo[[j]]},*)
(*Table[*)
(*With[*)
(*{cn = randomRuleL[k,n] },*)
(*flattenEvo[ ini,*)
(*<|"Connections"-> tp,"Rules"-> cn|>,*)
(*t]->j*)
(*]*)
(*,{i,nSamples}]*)
(*]*)
(*,{j,Length@classesTopo}*)
(*];*)
(**)
(*TestSetTopo = Flatten@Table[*)
(*With[*)
(*{tp = classesTopo[[j]]},*)
(*Table[*)
(*With[*)
(*{cn = randomRuleL[k,n] },*)
(*flattenEvo[ ini,*)
(*<|"Connections"-> tp,"Rules"-> cn|>,*)
(*t]->j*)
(*]*)
(*,{i,10*nSamples}]*)
(*]*)
(*,{j,Length@classesTopo}*)
(*];*)


(* ::Input:: *)
(*Length@TrainingSetTopo*)


(* ::Subsubsection:: *)
(*Rules Test Sets*)


(* ::Input:: *)
(*SeedRandom[4122019]*)
(**)
(*TrainingSetRules = Flatten@Table[*)
(*With[*)
(*{rl = classesRules[[j]]},*)
(*Table[*)
(*With[*)
(*{cn = randomNetwork[n,k] },*)
(*flattenEvo[ ini,*)
(*<|"Connections"-> cn["Connections"],"Rules"-> rl|>,*)
(*t]->j*)
(*]*)
(*,{i,nSamples}]*)
(*]*)
(*,{j,Length@classesTopo}*)
(*];*)
(**)
(*ValidationSetRules = Flatten@Table[*)
(*With[*)
(*{rl = classesRules[[j]]},*)
(*Table[*)
(*With[*)
(*{cn = randomNetwork[n,k] },*)
(*flattenEvo[ ini,*)
(*<|"Connections"-> cn["Connections"],"Rules"-> rl|>,*)
(*t]->j*)
(*]*)
(*,{i,nSamples}]*)
(*]*)
(*,{j,Length@classesTopo}*)
(*];*)
(**)
(*TestSetRules = Flatten@Table[*)
(*With[*)
(*{rl = classesRules[[j]]},*)
(*Table[*)
(*With[*)
(*{cn = randomNetwork[n,k] },*)
(*flattenEvo[ ini,*)
(*<|"Connections"-> cn["Connections"],"Rules"-> rl|>,*)
(*t]->j*)
(*]*)
(*,{i,10*nSamples}]*)
(*]*)
(*,{j,Length@classesTopo}*)
(*];*)


(* ::Chapter:: *)
(*Classifying the Sets with Deep Learning*)


(* ::Text:: *)
(*Let's see how Mathematica does to classify this problem.*)


(* ::Subsubsection:: *)
(*Topology:*)


(* ::Input:: *)
(*c1Top = Classify[TrainingSetTopo]*)


(* ::Input:: *)
(*ClassifierMeasurements[c1Top, TestSetTopo, "Accuracy"]*)


(* ::Text:: *)
(*0.201% is very close to random.*)


(* ::Subsubsection:: *)
(*Rules:*)


(* ::Input:: *)
(*c1Rules = Classify[TrainingSetRules]*)


(* ::Input:: *)
(*ClassifierMeasurements[c1Rules, TestSetRules, "Accuracy"]*)


(* ::Text:: *)
(*0.82 is very good. Better than expected.*)


(* ::Subsection:: *)
(*A simple neural network.*)


(* ::Input:: *)
(*n*t*)


(* ::Input:: *)
(*Length@TrainingSetRules[[1,1]]*)


(* ::Input:: *)
(*nnT = NetChain[*)
(*{ *)
(*LinearLayer[n*t],Ramp,DropoutLayer[],*)
(*LinearLayer[],Ramp,SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",Range[Length@classesTopo ]}],"Input"-> {n*t}*)
(*]*)


(* ::Input:: *)
(*netT = NetTrain[nnT,*)
(*TrainingSetTopo, *)
(*ValidationSet->ValidationSetTopo*)
(*,TargetDevice->{"GPU",2} *)
(*]*)


(* ::Input:: *)
(*ClassifierMeasurements[netT, TestSetTopo, "Accuracy"]*)


(* ::Text:: *)
(*Better than nearest neighbor classifier but still low.*)


(* ::Subsubsection:: *)
(*For completeness sake, lets classify the rules.*)


(* ::Input:: *)
(*nnR = NetChain[*)
(*{ *)
(*LinearLayer[n*t],Ramp,DropoutLayer[],*)
(*LinearLayer[],Ramp,SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",Range[Length@classesRules]}],"Input"-> {n*t}*)
(*]*)


(* ::Input:: *)
(*netR = NetTrain[nnR,*)
(*TrainingSetRules, *)
(*ValidationSet->ValidationSetRules*)
(*,TargetDevice->{"GPU",2} *)
(*]*)


(* ::Input:: *)
(*ClassifierMeasurements[netR, TrainingSetRules, "Accuracy"]*)


(* ::Text:: *)
(*This is now expected given the previous result.*)


(* ::Chapter:: *)
(*Algorithmic Information Classifier*)


(* ::Text:: *)
(*Lets compute the conditional CTM for the reduced set of rules. *)


(* ::Input:: *)
(*set = toBinaryInt[#,8]&/@Range[2^8];*)


(* ::Text:: *)
(*Function that enumerates all the possible topologies.*)


(* ::Input:: *)
(*ConnectivityMatrix[4,2]*)


(* ::Input:: *)
(*conBits [n_,k_] :=Flatten[Prepend[Table[0,{n-k}],Table[1,{k}]]]*)


(* ::Input:: *)
(*rows[n_,k_]:=Permutations[conBits[n,k]]*)


(* ::Input:: *)
(*topo[n_,k_]:=Tuples[rows[n,k],n]*)


(* ::Text:: *)
(*For the following experiment I will focus on networks of size 5.*)


(* ::Input:: *)
(*Length@topo[5,2]*)


(* ::Text:: *)
(*Now, the list of all networks.*)


(* ::Input:: *)
(*ruleL[k_]:=*)
(*Which[*)
(*k==1,{rNot,rId},*)
(*k==2,{rAnd,rOr,rNand,rXor},*)
(*k==3,{RuleK3A,RuleK3B,RuleK3C,RuleK3D,RuleK3E,RuleK3F,RuleK3G,RuleK3H}*)
(*]*)


(* ::Input:: *)
(*rulesL[n_,k_]:=Tuples[ruleL[k],n]*)


(* ::Input:: *)
(*Remove[networks]*)


(* ::Input:: *)
(*(* R is the number of rules on each network*)*)
(*networks[n_,k_]:= *)
(*(<|"Connections"->PositionsMatrix@#[[1]],"Rules"->#[[2]]|>)&/@With[*)
(*{*)
(*tps = topo[n,k],*)
(*rls = rulesL[n,k]*)
(*},*)
(*Tuples[{tps,rls}]*)
(*]*)


(* ::Input:: *)
(*Length@networks[4,2]*)


(* ::Input:: *)
(*net =RandomChoice@networks[4,2]*)


(* ::Input:: *)
(*init = ConstantArray[0,4]*)


(* ::Input:: *)
(*net["Connections"]*)


(* ::Input:: *)
(*n2 =randomNetwork[4,2]*)


(* ::Input:: *)
(*flattenEvo[init,n2,10]*)


(* ::Input:: *)
(*flattenEvo[init,net,10]*)


(* ::Subsubsection:: *)
(*Now, to compute the incidences.*)


(* ::Text:: *)
(*We will always start with the strings of zeros.*)


(* ::Input:: *)
(*init = ConstantArray[0,n];*)


(* ::Input:: *)
(*nets = networks[n,k];*)


(* ::Text:: *)
(*A topological relation  (t->s) exists of the t produces the string s.*)


(* ::Input:: *)
(* topologies = Merge[#,Total]&@Table[*)
(*With[*)
(*{*)
(*n= nets[[i]]*)
(*},*)
(*{n["Connections"],flattenEvo[init,n,t]}->1*)
(*]*)
(*,*)
(*{i,Length@nets}];*)


(* ::Input:: *)
(*SetDirectory[NotebookDirectory[]];*)


(* ::Input:: *)
(*Export["topoN4K2.m",topologies]*)


(* ::Input:: *)
(*Length@(Keys@topologies)*)


(* ::Text:: *)
(*Let' s see an example of rules.*)


(* ::Input:: *)
(*(Keys@topologies)[[1111]]->(Values@topologies)[[1111]]*)


(* ::Input:: *)
(*rules= Merge[#,Total]&@Table[*)
(*With[*)
(*{*)
(*n= nets[[i]]*)
(*},*)
(*{n["Rules"],flattenEvo[init,n,t]}->1*)
(*]*)
(*,*)
(*{i,Length@nets}];*)


(* ::Input:: *)
(*Export["rulesN4K2.m",rules]*)


(* ::Input:: *)
(*Length@(Keys@rules)*)


(* ::Text:: *)
(*Let's see an example of rules.*)


(* ::Input:: *)
(*(Keys@rules)[[1111]]->(Values@rules)[[1111]]*)


(* ::Section:: *)
(*Algorithmic Probability*)


(* ::Text:: *)
(*The following function will be a convenient way to consult the previous database.*)


(* ::Input:: *)
(*fRelTop[s1_,s2_]:=With[*)
(*{out = topologies[{s1,s2}]},*)
(*If[MissingQ@out,*)
(*0,*)
(*out*)
(*]*)
(*]*)


(* ::Input:: *)
(*fRelRul[s1_,s2_]:=With[*)
(*{out = rules[{s1,s2}]},*)
(*If[MissingQ@out,*)
(*0,*)
(*out*)
(*]*)
(*]*)


(* ::Text:: *)
(*For example.*)


(* ::Input:: *)
(*fRelTop[*)
(*{{1,2},{1,2},{1,3},{3,4}},*)
(*{1,0,0,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0}*)
(*]*)


(* ::Input:: *)
(*fRelTop[*)
(*{{1,2},{1,2},{1,3},{3,4}},*)
(*{1,1,0,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0}*)
(*]*)


(* ::Text:: *)
(*Lets compute the totals.*)


(* ::Input:: *)
(*totalTop = Total@Values@topologies*)


(* ::Input:: *)
(*totalrules = Total@Values@rules*)


(* ::Input:: *)
(*Length@nets*)


(* ::Text:: *)
(*And now the probabilities.*)


(* ::Input:: *)
(*mTop[top_,st_]:=*)
(*fRelTop[top,st]/totalTop*)


(* ::Input:: *)
(*mRul[rl_,st_]:=*)
(*fRelRul[rl,st]/totalrules*)


(* ::Text:: *)
(*For example:*)


(* ::Input:: *)
(*mTop[*)
(*{{1,2},{1,2},{1,3},{3,4}},*)
(*{1,0,0,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0}*)
(*]*)


(* ::Text:: *)
(*Let's define a penalty value for the probability cero cases.*)


(* ::Input:: *)
(*N@(-Log[2,1/totalTop])*)


(* ::Input:: *)
(*penalty = 20*)


(* ::Subchapter:: *)
(*Conditional CTM*)


(* ::Input:: *)
(*kmTopCTM[top_,st_]:=*)
(*With[{p = mTop[top,st]},*)
(*If[*)
(*p<=0,penalty,*)
(* -Log[2,p]*)
(*]*)
(*]*)


(* ::Input:: *)
(*kmRulCTM[top_,st_]:=*)
(*With[{p = mRul[top,st]},*)
(*If[*)
(*p<=0,penalty,*)
(* -Log[2,p]*)
(*]*)
(*]*)


(* ::Text:: *)
(*For example.*)


(* ::Input:: *)
(*N@kmTopCTM[*)
(*{{1,2},{1,2},{1,3},{3,4}},*)
(*{1,0,0,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0,0,1,0,0,1,1,0,0,0,1,1,0,1,1,1,0}*)
(*]*)


(* ::Section:: *)
(*The Algorithmic Classifier*)


(* ::Text:: *)
(*Let us now define the model.*)


(* ::Text:: *)
(*The model is composed of either the topology or the rules of each set.*)


(* ::Input:: *)
(*topoSpace = PositionsMatrix/@topo[n,k];*)


(* ::Input:: *)
(*modelTopo1 = AssociationMap[{}&,Range[Length@classesTopo]]*)


(* ::Input:: *)
(*ChooseDat[data_, dig_]:=Select[data, (#[[2]]==dig)&]*)


(* ::Subsubsection:: *)
(*The Cost Function*)


(* ::Input:: *)
(*costTop[c_,set_ ]:=*)
(*N@Total@Table[*)
(*kmTopCTM[c,set[[i]][[1]]]*)
(*,{i,Length@set}]*)


(* ::Text:: *)
(*Sanity checks.*)


(* ::Input:: *)
(*costTop[classesTopo[[1]],ChooseDat[TrainingSetTopo, 1]]*)


(* ::Input:: *)
(*costTop[classesTopo[[1]],ChooseDat[TrainingSetTopo, 2]]*)


(* ::Input:: *)
(*costTop[classesTopo[[3]],ChooseDat[TrainingSetTopo,3]]*)


(* ::Text:: *)
(*Now, to train the model.*)


(* ::Input:: *)
(*modelTopo1=Association@Table[*)
(*With[*)
(*{*)
(*set = ChooseDat[TrainingSetTopo,i]*)
(*},*)
(*i->MinimalBy[topoSpace, costTop[#,set]&][[1]]*)
(*]*)
(*,{i,Length@classesTopo}*)
(*]*)


(* ::Input:: *)
(*classesTopo*)


(* ::Text:: *)
(*Looks like the training predicted perfectly the classes.*)


(* ::Text:: *)
(*Lets see its accuracy.*)


(* ::Input:: *)
(*predTopo[m_,x_]:= MinimalBy[Keys@m, (N@kmTopCTM[m[#],x])& ][[1]]*)


(* ::Text:: *)
(*For example.*)


(* ::Input:: *)
(*predTopo[modelTopo1, (Last@TestSetTopo)[[1]]]*)


(* ::Input:: *)
(*right = 0;*)
(*wrong = List[]*)
(*Table[*)
(*If[*)
(*predTopo[*)
(*modelTopo1, TestSetTopo[[i]][[1]]*)
(*]== TestSetTopo[[i]][[2]],*)
(*right = right +1,*)
(*wrong=Append[wrong,TestSetTopo[[i]]]*)
(*]*)
(*,{i,Length[TestSetTopo]}];*)


(* ::Input:: *)
(*right*)


(* ::Text:: *)
(*And the accuracy is :*)


(* ::Input:: *)
(*N@right/Length[TestSetTopo]*)


(* ::Text:: *)
(*0.73 % is a significant improvement.*)


(* ::Text:: *)
(*And our mistakes are in:*)


(* ::Input:: *)
(*Tally@Values@wrong*)


(* ::Text:: *)
(*Mostly in the class 6.*)


(* ::Text:: *)
(*Let's do a bit of research on the possible cause of this:*)


(* ::Input:: *)
(*MaximalBy[Tally[Keys@TestSetTopo],#[[2]]&,5]*)


(* ::Text:: *)
(*So, the string *)


(* ::Input:: *)
(*s=MaximalBy[Tally[Keys@TestSetTopo],#[[2]]&,5][[1,1]]*)


(* ::Text:: *)
(*Is the most common. Let's see to which classes it belongs too.*)


(* ::Input:: *)
(*rep=Select[TestSetTopo, (#[[1]]==s)&];*)


(* ::Input:: *)
(*Tally@Values@rep*)


(* ::Text:: *)
(*As we can see, it belongs to several classes therefore is impossible to correctly classify every time. However, is most probably it belongs to the class 1. Lets see what our classifier tell us:*)


(* ::Input:: *)
(*predTopo[modelTopo1, s]*)


(* ::Text:: *)
(*Yes, as expected, is assigned to class 1!*)


(* ::Subsubsection:: *)
(*For completeness sake, lets classify the operations too.*)


(* ::Input:: *)
(*modelRule = AssociationMap[{}&,Range[Length@classesRules]]*)


(* ::Input:: *)
(*costRule[c_,set_ ]:=*)
(*N@Total@Table[*)
(*kmRulCTM[c,set[[i]][[1]]]*)
(*,{i,Length@set}]*)


(* ::Text:: *)
(*Sanity check.*)


(* ::Input:: *)
(*costRule[classesRules[[1]],ChooseDat[TrainingSetRules, 1]]*)


(* ::Input:: *)
(*costRule[classesRules[[1]],ChooseDat[TrainingSetRules, 2]]*)


(* ::Text:: *)
(*Search space.*)


(* ::Input:: *)
(*rulesSpace =rulesL[n,k];*)


(* ::Text:: *)
(*Now to train the model.*)


(* ::Input:: *)
(*modelRule=Association@Table[*)
(*With[*)
(*{*)
(*set = ChooseDat[TrainingSetRules,i]*)
(*},*)
(*i->MinimalBy[rulesSpace, costRule[#,set]&][[1]]*)
(*]*)
(*,{i,Length@classesRules}*)
(*]*)


(* ::Input:: *)
(*classesRules*)


(* ::Text:: *)
(*The classifier is:*)


(* ::Input:: *)
(*predRule[m_,x_]:= MinimalBy[Keys@m, (N@kmRulCTM[m[#],x])& ][[1]]*)


(* ::Text:: *)
(*We reconstructed the rules.*)


(* ::Text:: *)
(*Now lets compute the accuracy.*)


(* ::Input:: *)
(*right = 0;*)
(*wrong = List[]*)
(*Table[*)
(*If[*)
(*predRule[*)
(*modelRule, TestSetRules[[i]][[1]]*)
(*]== TestSetRules[[i]][[2]],*)
(*right = right +1,*)
(*wrong=Append[wrong,TestSetRules[[i]]]*)
(*]*)
(*,{i,Length[TestSetRules]}];*)


(* ::Input:: *)
(*right*)


(* ::Input:: *)
(*N@right/Length[TestSetRules]*)


(* ::Text:: *)
(*91.35% accuracy.*)
