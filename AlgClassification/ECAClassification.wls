#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*Classifying Cellular Automatons.*)


(* ::Text:: *)
(*In this experiment, we will classify cellular automatons according to its underlying rules.*)


(* ::Subchapter:: *)
(*The Set*)


(* ::Text:: *)
(*We will use the complete automaton range.*)


(* ::Input:: *)
(*automat[n_] := RandomSample[Range[255],n]*)


(* ::Input:: *)
(*SeedRandom[227019];*)
(*lAutomat = automat[10];*)


(* ::Input:: *)
(*lAutomat = DeleteDuplicates@Append[lAutomat,110]*)


(* ::Input:: *)
(*size = 32*)


(* ::Text:: *)
(*We will use 25 samples per class.*)


(* ::Input:: *)
(*nSamples = 25*)


(* ::Input:: *)
(*SeedRandom[2602019]*)
(**)
(*TrainingSample = *)
(*Catenate@Table[*)
(*Table[*)
(*With[{ini = RandomInteger[1,size]},*)
(*CellularAutomaton[*)
(*lAutomat[[i]], ini, size-1*)
(*]-> lAutomat[[i]]*)
(*]*)
(*,{i,Length[lAutomat]}*)
(*]*)
(*,{j,nSamples}];*)
(**)
(*ValidationSample = *)
(*Catenate@Table[*)
(*Table[*)
(*With[{ini = RandomInteger[1,size]},*)
(*CellularAutomaton[*)
(*lAutomat[[i]], ini, size-1*)
(*]-> lAutomat[[i]]*)
(*]*)
(*,{i,Length[lAutomat]}*)
(*]*)
(*,{j,nSamples}];*)
(**)
(*TestSample  =*)
(*Catenate@Table[*)
(*Table[*)
(*With[{ini = RandomInteger[1,size]},*)
(*CellularAutomaton[*)
(*lAutomat[[i]], ini, size-1*)
(*]-> lAutomat[[i]]*)
(*]*)
(*,{i,Length[lAutomat]}*)
(*]*)
(*,{j,5*nSamples}]; *)


(* ::Text:: *)
(*A sample is:*)


(* ::Input:: *)
(*(ArrayPlot[#[[1]]]-> #[[2]])&@TrainingSample[[1]]*)


(* ::Chapter:: *)
(*Accuracy of Naive Neural Networks.*)


(* ::Text:: *)
(*nn: Neural Network that takes in a flattened vector of 1s and 0s. (all timesteps in one go)*)


(* ::Input:: *)
(*nn =  NetChain[{FlattenLayer[], *)
(*LinearLayer[],*)
(*SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",lAutomat}],"Input"-> {size,size}];*)


(* ::Input:: *)
(*net = NetTrain[nn,TrainingSample, All,ValidationSet-> ValidationSample,*)
(*MaxTrainingRounds->500,TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*net["ErrorRateEvolutionPlot"]*)


(* ::Input:: *)
(*ClassifierMeasurements[net["TrainedNet"],TestSample,"Accuracy"]*)


(* ::Input:: *)
(*ClassifierMeasurements[net["TrainedNet"], TrainingSample,"Accuracy"]*)


(* ::Text:: *)
(*So, even with this simple model, we have a textbook example of overfitting. The linear layer has enough variance to reach a 100% accuracy on the training set, but only manages a 0.28% accuracy on the test set.*)


(* ::Input:: *)
(*nn2 =  NetChain[{FlattenLayer[], *)
(*LinearLayer[size*size],*)
(*LinearLayer[],*)
(*SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",lAutomat}],"Input"-> {size,size}];*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*net2 = NetTrain[nn2,TrainingSample, All,ValidationSet-> ValidationSample,*)
(*MaxTrainingRounds->500,*)
(*TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net2["TrainedNet"],TestSample,"Accuracy"]*)


(* ::Input:: *)
(*ClassifierMeasurements[net2["TrainedNet"], TrainingSample,"Accuracy"]*)


(* ::Text:: *)
(*We can see that Naive Neural Networks have low Accuracy on the problem.*)


(* ::Subsection:: *)
(*Final Neural Network.*)


(* ::Input:: *)
(*nn3 =  NetChain[{FlattenLayer[], *)
(*LinearLayer[size*size],*)
(*LinearLayer[size*size],*)
(*LinearLayer[],*)
(*SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",lAutomat}],"Input"-> {size,size}];*)


(* ::Input:: *)
(*net3 = NetTrain[nn3,TrainingSample, All,ValidationSet-> ValidationSample,*)
(*MaxTrainingRounds->500,*)
(*TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net3["TrainedNet"], TestSample,"Accuracy"]*)


(* ::Input:: *)
(*ClassifierMeasurements[net3["TrainedNet"], TrainingSample,"Accuracy"]*)


(* ::Input:: *)
(*net3["ErrorRateEvolutionPlot"]*)


(* ::Text:: *)
(*Another one.*)


(* ::Input:: *)
(*nn4 =  NetChain[{FlattenLayer[], *)
(*LinearLayer[size*size],*)
(*LinearLayer[size*size],*)
(*LinearLayer[size*size],*)
(*LinearLayer[],*)
(*SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",lAutomat}],"Input"-> {size,size}];*)


(* ::Input:: *)
(*net4 = NetTrain[nn4,TrainingSample, All,ValidationSet-> ValidationSample,*)
(*MaxTrainingRounds->500,*)
(*TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net4["TrainedNet"], TestSample,"Accuracy"]*)


(* ::Chapter:: *)
(*The Performance of a Convolutional Deep Network.*)


(* ::Text:: *)
(*The following Neural Network so far has shown excellent performance on this task. *)


(* ::Input:: *)
(*nn =  NetChain[{ ConvolutionLayer[16,{3,2}],Ramp,PoolingLayer[{size-2,size-3}],FlattenLayer[], LinearLayer[Length@lAutomat],SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",lAutomat}],"Input"-> {1,size,size}];*)


(* ::Text:: *)
(*We need to add one channel for this network to work.*)


(* ::Input:: *)
(*TrainingSample2 = Map[{#[[1]]}->#[[2]]&,TrainingSample];*)


(* ::Input:: *)
(*ValidationSample2=  Map[{#[[1]]}->#[[2]]&,ValidationSample];*)


(* ::Input:: *)
(*TestSample2 =  Map[{#[[1]]}->#[[2]]&,TestSample];*)


(* ::Input:: *)
(*SeedRandom[26022019]*)
(*net = NetTrain[nn,TrainingSample2,ValidationSet->ValidationSample2, TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net, TestSample2, "Accuracy"]*)


(* ::Text:: *)
(*The accuracy is very good.*)


(* ::Text:: *)
(*Now, given the requirements for the classifier that the input be of size 1xn...xn, we will define a second classifier to make the next code compatible.*)


(* ::Input:: *)
(*compNet[x_] := net[{x}]*)


(* ::Chapter:: *)
(*Breaking the Network With Small Pixel Attacks. *)


(* ::Text:: *)
(*Given a classifier and a sample, the following function will return a list of successful attacks. *)


(* ::Input:: *)
(*flipPixelL[ls_,idx_]:=*)
(*ReplacePart[ls,idx-> If[*)
(*ls[[idx]]==0,1,0]*)
(*]*)


(* ::Input:: *)
(*flipPixelS[sam_, idx_]:=With[*)
(*{*)
(*ogDim=Dimensions[sam[[1]]],*)
(*flat = Flatten[sam[[1]]]*)
(*},*)
(*With[*)
(*{*)
(*flipped =flipPixelL[flat,idx]},*)
(* ArrayReshape[flipped,ogDim]-> sam[[2]]*)
(*]*)
(*]*)


(* ::Input:: *)
(*(* flips all the pixels given in the list 'lIdx' *)*)
(*nflipPixelS[sam_, lIdx_]:= Fold[flipPixelS,sam,lIdx]*)


(* ::Input:: *)
(*(* The function *)*)
(*pixelAttack[class_,sample_]:=Select[*)
(*Range[*)
(*Fold[#1*#2&,1,#]&@Dimensions[sample[[1]]]*)
(*],*)
(*class[flipPixelS[sample, #][[1]]]!=sample[[2]]&*)
(*]*)


(* ::Text:: *)
(*Example of execution:*)


(* ::Input:: *)
(*x = TestSample[[1]];*)


(* ::Input:: *)
(*pixelAttack[compNet,x]*)


(* ::Input:: *)
(*(* function that can do 'n' pixel attacks *)*)


(* ::Input:: *)
(*npixelAttack[class_,sample_,nm_]:= With[*)
(*{cand = Subsets[*)
(*Range[Fold[#1*#2&,1,#]&@Dimensions[sample[[1]]]]*)
(*,{nm}]*)
(*},*)
(*Parallelize@Select[*)
(*cand,class[nflipPixelS[sample, #][[1]]]!=sample[[2]]&*)
(*]*)
(*]*)


(* ::Input:: *)
(*(* npixelAttack[compNet,x,2] *)*)


(* ::Text:: *)
(*Going through all the list is too computational expensive.*)


(* ::Subchapter:: *)
(*Expected Number of 1-Pixel attacks to break each Sample.*)


(* ::Text:: *)
(*Let's compute the expected number of 1-pixel attacks needed to break the prediction of a sample. *)


(* ::Text:: *)
(*First, a sample of the test set, otherwise this is very expensive.*)


(* ::Input:: *)
(*SeedRandom[02012019]*)
(*vSet = RandomSample[TestSample,1000];*)


(* ::Text:: *)
(*Now, the experiment.*)


(* ::Input:: *)
(*(* attacks = ParallelTable[*)
(*pixelAttack[compNet,vSet[[i]]]*)
(*,{i,Length[vSet]}*)
(*] *)*)


(* ::Input:: *)
(*expected = N@(Total@ParallelTable[*)
(*Length@pixelAttack[compNet,vSet[[i]]]*)
(*,{i,Length[vSet]}]/Length[vSet])*)


(* ::Text:: *)
(*140 per sample is a significant number.*)


(* ::Chapter:: *)
(*The Same Attack on our Algorithmic Classifier.*)


(* ::Text:: *)
(*Let' s try the same attack on the classifier.Since we have no reason to believe that the same pixels will work, we will try to find another list.*)


(* ::Subchapter:: *)
(*The BDM function:*)


(* ::Input:: *)
(*SetDirectory[NotebookDirectory[]]*)


(* ::Input:: *)
(*reducedD2=<<"squares2Dsize1to4.m";*)


(* ::Input:: *)
(*Table[With[{sq=reducedD2[[nS]]},HashSquares[sq[[1]]]=sq[[2]]],{nS,Length@reducedD2}];*)


(* ::Input:: *)
(*Clear[reducedD2];*)


(* ::Input:: *)
(*BDM[array_,dim_Integer:4]:=If[TrueQ[Min[Dimensions[array]]<dim],BDM[array,Min[Dimensions[array]]],First[Block[{part=Partition[array,{dim,dim}]},Total[{Log[2,#[[2]]]+#[[1]]}&/@({HashSquares[#[[1]]],#[[2]]}&/@Tally[Flatten[part,1]])]]]]*)


(* ::Section:: *)
(*Conditional BDM.*)


(* ::Text:: *)
(*Functions to parse through shared members.*)


(* ::Input:: *)
(*Clear[NotIn]*)


(* ::Input:: *)
(*NotIn[List[],rep_]:= List[]*)


(* ::Input:: *)
(*NotIn[x_,rep_]:=If[MemberQ[rep,x[[1]]],NotIn[x[[2;;]],rep],Prepend[NotIn[x[[2;;]],rep],x[[1]]]]*)


(* ::Input:: *)
(*Shrd[List[],rep_]:=List[]*)


(* ::Input:: *)
(*Shrd[x_,rep_]:= If[MemberQ[rep,x[[1]]],Prepend[Shrd[x[[2;;]],rep],x[[1]]],Shrd[x[[2;;]],rep]]*)


(* ::Subsubsection:: *)
(*Conditional Squared BDM Function.*)


(* ::Input:: *)
(*Clear[BDMC]*)


(* ::Input:: *)
(*BDMC[array_,array2_,dim_Integer, offset_:dim_Integer]:=*)
(*If[TrueQ[Min[Dimensions[array]]<dim],*)
(*BDMC[array,array2,Min[Dimensions[array]]],*)
(**)
(*Block[{*)
(*part=Catenate[Partition[array,{dim,dim},{offset,offset}]],*)
(*part2= Catenate[Partition[array2, {dim,dim},{offset,offset}]]*)
(*},*)
(*  Total[(HashSquares[#[[1]]]+Log[2,#[[2]]])&/@Tally[NotIn[part, part2]]] +*)
(*	Total[Log[2,#[[2]]]&/@Tally[Shrd[part, part2]]]*)
(*]*)
(*]*)


(* ::Subchapter:: *)
(*Training the Classifier.*)


(* ::Input:: *)
(*lossM[c_,x_]:=BDMC[x[[1]],c,4,1]^2*)


(* ::Input:: *)
(*costM[c_,set_]:= N@Total[*)
(*lossM[c,#]&/@set*)
(*]*)


(* ::Input:: *)
(*getClass[n_, set_]:= getClass2[n,set,Length[set],List[]]*)
(**)
(*getClass2[n_,set_,i_, acc_]:=If[*)
(*i>0,*)
(*getClass3[n, set, i, acc],*)
(*Return[acc]*)
(*]*)
(**)
(*getClass3[n_,set_,i_, acc_]:=If[*)
(*n==set[[i]][[2]],*)
(*getClass2[n,set,i-1, Append[acc,set[[i]]]],*)
(*getClass2[n,set,i-1, acc]*)
(*]*)


(* ::Input:: *)
(*(* needed for my program to work *)*)
(*$RecursionLimit=Infinity;*)
(*$IterationLimit=Infinity;*)
(*CloseKernels[];*)
(*ParallelEvaluate[$RecursionLimit=Infinity;$IterationLimit=Infinity,LaunchKernels[8]];*)


(* ::Input:: *)
(*Table[*)
(*partitions[lAutomat[[i]]]= *)
(*Catenate@Catenate@( *)
(*Partition[#,{4,4},{1,1}]&/@Keys@getClass[lAutomat[[i]],TrainingSample]*)
(*)*)
(*,{i,Length[lAutomat]}*)
(*];*)


(* ::Text:: *)
(*Let's make it unique.*)


(* ::Input:: *)
(*Table[*)
(*partitions[lAutomat[[i]]]=#[[1]]&/@Tally@partitions[lAutomat[[i]]]*)
(*,{i,Length[lAutomat]}*)
(*];*)


(* ::Input:: *)
(*(* firstM = lAutomat;*)
(*SetSharedVariable[firstM]*)
(* *)*)
(*ArrayPlot/@Table[*)
(*With[*)
(*{*)
(*aut = lAutomat[[i]],*)
(*set = getClass[lAutomat[[i]],TrainingSample],*)
(*search = partitions[lAutomat[[i]]]*)
(*},*)
(*firstM[aut]=  MinimalBy[*)
(*search,*)
(*costM[#, set]&,1*)
(*][[1]]*)
(*]*)
(*,{i,Length[lAutomat]}*)
(*]*)


(* ::Text:: *)
(*Function to iterate the previous code.*)


(* ::Text:: *)
(*First, some helper functions.*)


(* ::Input:: *)
(*(*  Function that constructs an square matrix of matrices *)*)
(*consTM[lm_]:=With[*)
(*{nRows = Sqrt[Length[lm]]},*)
(*With[*)
(*{rows = Partition[lm,nRows]},*)
(*Catenate[joinRow/@rows]*)
(*]*)
(*]*)
(**)
(*joinRow[rs_]:= joinRow2[Rest[rs],rs[[1]],Length[rs]-1]*)
(**)
(*joinRow2[rs_, acc_, n_]:= If[n==1,*)
(*Join[acc,rs[[1]],2],*)
(*joinRow2[Rest[rs],Join[acc,rs[[1]],2],n-1]*)
(*]*)


(* ::Input:: *)
(*(* Given the list of current matrices, it generates a new matriz with a padding of zeros*)*)
(*newMat[act_, ins_,nm_]:=*)
(*With[*)
(*{*)
(*pad=ConstantArray[*)
(*ConstantArray[0,Dimensions[ins]],nm-Length[act]-1]*)
(*},*)
(*consTM[*)
(*Join[Append[act,ins],pad]*)
(*]*)
(*]*)


(* ::Text:: *)
(*Now, the training algorithm.*)


(* ::Input:: *)
(*(* Given and Initial matrix, adds the next matrix that minimizes the loss function *)*)


(* ::Input:: *)
(*trainNext[cs_,search_,set_]:=*)
(*With[*)
(*{nextM = MinimalBy[*)
(*search,*)
(*costM[newMat[cs,#,16],set]&,1*)
(*][[1]]},*)
(*Append[cs,nextM]*)
(*]*)
(**)


(* ::Text:: *)
(*First, we need to set the recursion limit on all the kernels. *)


(* ::Input:: *)
(*(* SetSharedVariable[lAutomat,TrainingSample]; *)
(*$SharedVariables *)*)


(* ::Input:: *)
(*mats =ParallelTable[*)
(*With[*)
(*{*)
(*aut = lAutomat[[i]],*)
(*set = getClass[lAutomat[[i]],TrainingSample],*)
(*search = partitions[lAutomat[[i]]]*)
(*},*)
(*Nest[trainNext[#,search,set]&,{firstM[aut]},15]*)
(*]*)
(*,{i,Length[lAutomat]}];*)


(* ::Text:: *)
(*And the matrices chosen are (Lets put them in the model)*)


(* ::Input:: *)
(*ArrayPlot/@Table[Model[lAutomat[[i]]]=consTM[mats[[i]]],{i,Length@lAutomat}]*)


(* ::Input:: *)
(*pred[M_,x_]:=*)
(*Quiet@MinimalBy[lAutomat, BDMC[x,M[#],4,1]&][[1]]*)


(* ::Input:: *)
(*right = 0;*)
(*wrong = List[]*)
(*Table[*)
(*If[*)
(*pred[*)
(*Model, TestSample[[i]][[1]]*)
(*]== TestSample[[i]][[2]],*)
(*right = right +1,*)
(*wrong=Append[wrong,TestSample[[i]]]*)
(*]*)
(*,{i,Length[TestSample]}];*)


(* ::Input:: *)
(*right*)


(* ::Text:: *)
(*And the accuracy is:*)


(* ::Input:: *)
(*N@right/Length[TestSample]*)


(* ::Text:: *)
(*Which is lower than the perfect 100%, but still decent I believe.*)


(* ::Input:: *)
(*Model[lAutomat[[1]]]*)


(* ::Subchapter:: *)
(*Attacking the Model.*)


(* ::Input:: *)
(*expected2 = N@(Total@ParallelTable[*)
(*Length@pixelAttack[pred[Model,#]&,TestSample[[i]]]*)
(*,{i,5}]/5)*)


(* ::Text:: *)
(*11 per sample is a significant number is much lower than 140.*)
