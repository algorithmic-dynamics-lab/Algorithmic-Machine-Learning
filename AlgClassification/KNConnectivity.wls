#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*Classifying NK Networks.*)


(* ::Text:: *)
(*An NK network is a boolean network where n specify the number of nodes or vertexes and k is the number of incoming connections that each vertex has. According to Kauffman, the parameter K defines the stability (or lack of thereof) of the network, where k = 2 is a critical point that approximates the properties of gene regulatory networks. Bellow that (k=1) we have too much regularity (frozen state) and beyond it (K>=3) we have chaos. *)


(* ::Chapter:: *)
(*The Problem*)


(* ::Text:: *)
(*The classification problem to solve is, can we find out whenever the evolution of an NK network correspond to k=1 (frozen), k = 2 (criticality) and k=3 (chaos)?*)


(* ::Subsubsection:: *)
(*Legacy Functions*)


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


(* ::Subchapter:: *)
(*Rules*)


(* ::Text:: *)
(*The following functions randomly generates boolean rules of degree K.*)


(* ::Input:: *)
(*randomRule[k_]:=*)
(*With[*)
(*{*)
(*outputs =RandomChoice[{0,1},2^k],*)
(*inputs = Flatten[toBinaryInt[#,k]&/@Range[2^{k}],1]*)
(*},*)
(*AssociationThread[inputs-> outputs]*)
(*]*)
(**)


(* ::Input:: *)
(*randomRule[3]*)


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
(*For example:*)


(* ::Input:: *)
(*randomNetwork[10,2]*)


(* ::Text:: *)
(*Given a network topology, the following function evolves a vector of n vectors.*)


(* ::Input:: *)
(*Remove[evolve]*)


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


(* ::Text:: *)
(*For example:*)


(* ::Input:: *)
(*net = randomNetwork[10,2];*)


(* ::Input:: *)
(*evolve[{1,0,0,1,0,1,0,1,0,1},net]*)


(* ::Input:: *)
(*v = ConstantArray[0,10]*)


(* ::Text:: *)
(*An evolution of the system for 10 steps is:*)


(* ::Input:: *)
(*NestList[evolve[#,net]&,v,10] *)


(* ::Chapter:: *)
(*The Data Sets*)


(* ::Text:: *)
(*The data sets consists of the evolution up time t=10 of 24 vertex nk-Boolean networks for each category of k=1,2,3.*)


(* ::Input:: *)
(*n= 24*)


(* ::Input:: *)
(*start = ConstantArray[0,n]*)


(* ::Text:: *)
(*According to Kaufman, k=2 represents a critical point, where the network becomes interesting. *)


(* ::Text:: *)
(*Let's see how is the evolution of the network.*)


(* ::Input:: *)
(*size = 100;*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*s1 = evolve[start,randomNetwork[n,1]]&/@Range[size];*)
(*s2 = evolve[start,randomNetwork[n,2]]&/@Range[size];*)
(*s3 = evolve[start,randomNetwork[n,3]]&/@Range[size];*)
(*s4 = evolve[start,randomNetwork[n,4]]&/@Range[size];*)


(* ::Text:: *)
(*Let's see if there's any BDM regularity.*)


(* ::Section:: *)
(*String BDM.*)


(* ::Input:: *)
(*SetDirectory[NotebookDirectory[]];*)


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
(*StringBDM[string_,len_:1]:= *)
(*N@Total[HashStrings[#[[1]]]+Log[2,#[[2]]]&/@Tally[If[TrueQ[StringLength[string]>12],StringPartition[string,12,len],{string}]]]*)


(* ::Text:: *)
(*Modified version of String Entropy to be able to setup partition sizes.*)


(* ::Input:: *)
(*StringBDMS[string_,len_:1, dis_:1]:= *)
(*N@Total[HashStrings[#[[1]]]+Log[2,#[[2]]]&/@Tally[*)
(*StringPartition[string,len,dis]]*)
(*]*)


(* ::Input:: *)
(*BinaryBDM[input_,len_:1]:=*)
(*With[*)
(*{str = StringJoin[ToString/@input]},*)
(*StringBDM[str,len]*)
(*]*)


(* ::Section:: *)
(*The Sets:*)


(* ::Text:: *)
(*We will include the evolution of a network up to 10 times.*)


(* ::Input:: *)
(*flattenEvo[ str_,net_,t_]:= Flatten@Rest@NestList[evolve[#,net]&,str,t] *)


(* ::Input:: *)
(*net = randomNetwork[24,2];*)


(* ::Input:: *)
(*BinaryBDM@RandomChoice[{0,1},n*10]*)


(* ::Text:: *)
(*Let's see the expected values for these sets.*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*s1 = flattenEvo[start,randomNetwork[n,1],10]&/@Range[size];*)
(*s2 = flattenEvo[start,randomNetwork[n,2],10]&/@Range[size];*)
(*s3 = flattenEvo[start,randomNetwork[n,3],10]&/@Range[size];*)
(*s4 = flattenEvo[start,randomNetwork[n,4],10]&/@Range[size];*)


(* ::Input:: *)
(*Mean[BinaryBDM/@s1]*)


(* ::Input:: *)
(*Mean[BinaryBDM/@s2]*)


(* ::Input:: *)
(*Mean[BinaryBDM/@s3]*)


(* ::Input:: *)
(*Mean[BinaryBDM/@s4]*)


(* ::Text:: *)
(*Looks like we will be able to separate sets according to the BDM!*)


(* ::Subchapter:: *)
(*The Sets*)


(* ::Input:: *)
(*classes = {1,2,3}*)


(* ::Input:: *)
(*size = 100;*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*TrainingSample =*)
(* Flatten@Table[*)
(*Table[*)
(*flattenEvo[*)
(*start,*)
(*randomNetwork[n,classes[[j]]],*)
(*10]->classes[[j]]*)
(*,{i,size}]*)
(*,{j,Length@classes}];*)
(**)
(*ValidationSample =*)
(* Flatten@Table[*)
(*Table[*)
(* flattenEvo[*)
(*start,*)
(*randomNetwork[n,classes[[j]]],*)
(*10]->classes[[j]]*)
(*,{i,size}]*)
(*,{j,Length@classes}];*)
(**)
(*TestSample =*)
(* Flatten@Table[*)
(*Table[*)
(* flattenEvo[*)
(*start,*)
(*randomNetwork[n,classes[[j]]],*)
(*10]->classes[[j]]*)
(*,{i,size}]*)
(*,{j,Length@classes}];*)


(* ::Text:: *)
(*The data has the form:*)


(* ::Input:: *)
(*TrainingSample[[1]]*)


(* ::Input:: *)
(*Length@TrainingSample[[1,1]]*)


(* ::Text:: *)
(*Where the object to classify is the evolution to 10 steps of the Boolean network while the class if the $K$ parameter that was used to generate the network.  *)


(* ::Chapter:: *)
(*Solving the Classification Problem With Neural Networks.*)


(* ::Text:: *)
(*Lets see if a neural network can solve classify the previous set.*)


(* ::Input:: *)
(*nn = NetChain[*)
(*{ *)
(*LinearLayer[n*10],Ramp,DropoutLayer[],*)
(*LinearLayer[],Ramp,SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",classes}],"Input"-> {n*10}*)
(*]*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*net = NetTrain[nn,*)
(*TrainingSample, *)
(*ValidationSet->ValidationSample,*)
(*TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net, TestSample, "Accuracy"]*)


(* ::Input:: *)
(*ClassifierMeasurements[net, TrainingSample, "Accuracy"]*)


(* ::Input:: *)
(*nn2 = NetChain[*)
(*{ *)
(*LinearLayer[n*10],Ramp,DropoutLayer[],*)
(*LinearLayer[],SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",classes}],"Input"-> {n*10}*)
(*]*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*net2 = NetTrain[nn2,*)
(*TrainingSample, *)
(*ValidationSet->ValidationSample,*)
(*TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net2, TestSample, "Accuracy"]*)


(* ::Text:: *)
(*As expected, the NN is not good at classifying this problem, and the network has enough variance to perfectly fit the set.*)


(* ::Input:: *)
(*ClassifierMeasurements[net, TrainingSample, "Accuracy"]*)


(* ::Input:: *)
(*ClassifierMeasurements[net2, TestSample , "ConfusionMatrixPlot"]*)


(* ::Text:: *)
(*Looks like most incorrect classifications are assigned to the k=1 class.*)


(* ::Text:: *)
(*Lets see if Mathematica can find a good classifier.*)


(* ::Input:: *)
(*mClass = Classify[TrainingSample]*)


(* ::Input:: *)
(*ClassifierMeasurements[mClass, TestSample, "Accuracy"]*)


(* ::Input:: *)
(*ClassifierMeasurements[mClass, TrainingSample, "Accuracy"]*)


(* ::Text:: *)
(*Using GradientBoostedTrees performed worse, nearly as bad as random classification.*)


(* ::Subsection:: *)
(*An Attempt of Using a Prior Information of the Problem.*)


(* ::Text:: *)
(*By construction, we know that the starting strings are of size 24, so how can we use that information to define a better topology for the Neural Network? The one solution that comes to mind is to use convolutional layers of size {24,10} with*)


(* ::Input:: *)
(*TrainingSample2 = ({#[[1]]}->#[[2]])&/@TrainingSample;*)
(*ValidationSample2 = ({#[[1]]}->#[[2]])&/@ValidationSample;*)
(*TestSample2 = ({#[[1]]}->#[[2]])&/@TestSample;*)


(* ::Input:: *)
(*nn3 =  NetChain[{ ConvolutionLayer[10,{24}],Ramp, (* DropoutLayer[], *)*)
(*PoolingLayer[{24}, "Function"->Mean],FlattenLayer[], *)
(*LinearLayer[Length@classes],SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",classes}],"Input"-> {1,n*10}];*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*net3 = NetTrain[nn3,TrainingSample2, ValidationSet->ValidationSample2, TargetDevice->{"GPU",2}]*)


(* ::Input:: *)
(*ClassifierMeasurements[net3, TestSample2, "Accuracy"]*)


(* ::Text:: *)
(*At the least we managed to somewhat control overfitting:*)


(* ::Input:: *)
(*ClassifierMeasurements[net3, TrainingSample2, "Accuracy"]*)


(* ::Text:: *)
(*Predictably, that approach didn't work.*)


(* ::Chapter:: *)
(*Algorithmic Classification*)


(* ::Text:: *)
(*Let's classify purely by using the BDM of the samples.*)


(* ::Input:: *)
(*BDMTrainingSample = (BinaryBDM[#[[1]]]->#[[2]])&/@TrainingSample;*)
(*BDMTestSample = (BinaryBDM[#[[1]]]->#[[2]])&/@TestSample;*)


(* ::Input:: *)
(*bdmClass = Classify[BDMTrainingSample, Method->"NearestNeighbors"]*)


(* ::Text:: *)
(*Let us see the accuracy of this classifier:*)


(* ::Input:: *)
(*ClassifierMeasurements[bdmClass , BDMTestSample , "Accuracy"]*)


(* ::Text:: *)
(*70% by means of nearest neighbors based on its BDM value is much better than 46%. But, can we do better?*)


(* ::Text:: *)
(*Let's see the confusion Matrix:*)


(* ::Input:: *)
(*ClassifierMeasurements[bdmClass , BDMTestSample , "ConfusionMatrixPlot"]*)


(* ::Text:: *)
(*The class 2, aka the rich one, is the hardest to classify. And most erroneous predictions went to the k=3 case. However, unlike the tested traditional methods, *)


(* ::Input:: *)
(*ClassifierMeasurements[bdmClass , BDMTrainingSample , "Accuracy"]*)


(* ::Subchapter:: *)
(*Boosting the classifier by using both data points.*)


(* ::Text:: *)
(*Let's combine the data points.*)


(* ::Input:: *)
(*combTrainingSample = (Catenate[{#[[1]],{BinaryBDM[#[[1]]]}}]->#[[2]])&/@TrainingSample;*)
(*combValidationSample = (Catenate[{#[[1]],{BinaryBDM[#[[1]]]}}]->#[[2]])&/@ValidationSample;*)
(*combTestSample = (Catenate[{#[[1]],{BinaryBDM[#[[1]]]}}]->#[[2]])&/@TestSample;*)


(* ::Input:: *)
(*combClass = Classify[combTrainingSample ]*)


(* ::Input:: *)
(*ClassifierMeasurements[combClass , combTestSample, "Accuracy"]*)


(* ::Text:: *)
(*70%, the small difference is not significant.*)


(* ::Text:: *)
(*Let's try a simple Neural Network.*)


(* ::Input:: *)
(*nn2 = NetChain[*)
(*{ *)
(*LinearLayer[n*10+1],Ramp,DropoutLayer[],*)
(*LinearLayer[],Ramp,SoftmaxLayer[]},*)
(*"Output"->NetDecoder[{"Class",{1,2,3}}],"Input"-> {n*10+1}*)
(*]*)


(* ::Input:: *)
(*SeedRandom[02042019]*)
(*net2 = NetTrain[nn2,combTrainingSample, ValidationSet->combValidationSample]*)


(* ::Input:: *)
(*ClassifierMeasurements[net2, combTestSample, "Accuracy"]*)


(* ::Text:: *)
(*Performance dropped significantly to random classification. I did not expected this result. But help us to show that the used topology has no real way to discern on the useful information for the classification.*)


(* ::Input:: *)
(*ClassifierMeasurements[net2, combTrainingSample, "Accuracy"]*)


(* ::Subchapter:: *)
(*The Model*)


(* ::Text:: *)
(*The first task is to define the proper model. For this problem, a class is an integer that defines the number of interactions between the nodes of the networks. Follows that a class is composed of all possible interactions of degree k.*)


(* ::Text:: *)
(*In other words, the model is composed of the sets of adjacency matrices of the interactions between the vertices of the network corresponding to the evolution of the model and the . This is of course a really big set. But the complexity of these matrices, *)


(* ::Text:: *)
(*The main challenge we have with algorithmic classification is that NW networks is that mutations aren't local, therefore we can expect that the the block partition approach used by the Cellular automaton case will yield worse results. Also, doing conditional algorithmic complexity over 2^24 strings in order to get over the block size limitation (for this case) is too costly. *)


(* ::Text:: *)
(*Now, from the previous experiment, is clear that BDM works on some capacity, but that is with the universal distribution. I'm not confident that algorithmic  classification restricted to the set of rules will work nearly as well.*)


(* ::Text:: *)
(*As consequence of the previous points, we have that classification by BDM weights is an instance of algorithmic classification given the following:*)


(* ::Text:: *)
(*The real centers are the sets of all possible algorithmic relations, including the adjacency matrix and related binary operations, related to k=3. Therefore, the expected complexity of specifying a member of each class increases in function of this value (k). *)


(* ::Text:: *)
(*For instance, the number of possible boolean operations of degree k is 2^(2^k) and the number of possible adjacency matrices is n\times Comb(n,k) (for row of each matrix, we must choose k incoming edges out of n possible nodes) . Follows that the total number of possible network topologies is n^2 \times 2^(2^k) \times  Comb(n,k)  and the expected number of bits required to specify a member of this set is Log(n^2 \times 2^(2^k) \times  Comb(n,k)).*)


(* ::Text:: *)
(*Therefore, the expected algorithmic complexity of the members of  each class increases with k and n and we can do a coarse algorithmic classification instance according to this idea.*)


(* ::Input:: *)
(*model = AssociationMap[0&, classes]*)


(* ::Text:: *)
(*Training the model:*)


(* ::Input:: *)
(*ChooseDat[data_, dig_]:=Select[data, (#[[2]]==dig)&]*)


(* ::Input:: *)
(*Mean@Keys@ChooseDat[BDMTestSample,1]*)


(* ::Input:: *)
(*Table[*)
(*With[*)
(*{cls=classes[[i]]}*)
(*,model[cls]= Mean@Keys@ChooseDat[BDMTestSample,cls]*)
(*]*)
(*,{i,Length@classes}*)
(*]*)


(* ::Text:: *)
(*And we classify a sample with respect to which BDM is the closest to it.*)


(* ::Input:: *)
(*Remove[pred]*)


(* ::Input:: *)
(*pred[m_,x_]:= MinimalBy[Keys@m, Abs[m[#]-x]&][[1]]*)


(* ::Input:: *)
(*right = 0;*)
(*wrong = List[]*)
(*Table[*)
(*If[*)
(*pred[*)
(*model, BDMTestSample[[i]][[1]]*)
(*]== BDMTestSample[[i]][[2]],*)
(*right = right +1,*)
(*wrong=Append[wrong,BDMTestSample[[i]]]*)
(*]*)
(*,{i,Length[BDMTestSample]}];*)


(* ::Text:: *)
(*And the accuracy is:*)


(* ::Input:: *)
(*N@right/Length[BDMTestSample]*)


(* ::Text:: *)
(*On the test set.*)


(* ::Input:: *)
(*right = 0;*)
(*wrong2 = List[]*)
(*Table[*)
(*If[*)
(*pred[*)
(*model, BDMTrainingSample[[i]][[1]]*)
(*]== BDMTrainingSample[[i]][[2]],*)
(*right = right +1,*)
(*wrong2=Append[wrong2,BDMTrainingSample[[i]]]*)
(*]*)
(*,{i,Length[BDMTrainingSample]}];*)


(* ::Input:: *)
(*N@right/Length[BDMTrainingSample]*)


(* ::Text:: *)
(*71 % for which is almost the same as nearest neighbors!*)


(* ::Chapter:: *)
(*Entropy-based Classification*)


(* ::Text:: *)
(*For completeness sake, we will try to see how entropy-based algorithmic information measure does in this classification task.*)


(* ::Input:: *)
(*EntropyTrainingSample = (Entropy[#[[1]]]->#[[2]])&/@TrainingSample;*)
(*EntropyTestSample = (Entropy[#[[1]]]->#[[2]])&/@TestSample;*)


(* ::Input:: *)
(*entClass = Classify[EntropyTrainingSample ]*)


(* ::Input:: *)
(*ClassifierMeasurements[entClass, EntropyTestSample , "Accuracy"]*)


(* ::Text:: *)
(*Barely above random choice.*)


(* ::Input:: *)
(*ClassifierMeasurements[entClass, EntropyTrainingSample , "Accuracy"]*)
