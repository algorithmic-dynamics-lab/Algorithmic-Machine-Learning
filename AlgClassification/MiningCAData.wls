#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*Mining Data*)


(* ::Input:: *)
(*SetDirectory[NotebookDirectory[]];*)


(* ::Text:: *)
(*List of all 8-bit strings and their outputs.*)


(* ::Input:: *)
(*toBinaryInt[n_,bits_]:=IntegerDigits[n,2,bits]*)


(* ::Input:: *)
(*set = IntegerDigits[#,2,12]&/@Range[2^12];*)


(* ::Input:: *)
(*Length@set*)


(* ::Input:: *)
(*in =RandomChoice@set*)


(* ::Input:: *)
(*x =CellularAutomaton[110,in,4]*)


(* ::Text:: *)
(*Given an automaton of the form S1->S2, returns the associations of probabilities. *)


(* ::Input:: *)
(*relations [aut_, sz_, ds_]:=Merge[#,Total]&@With[*)
(*{*)
(*part1 = Partition[First@aut,sz,ds],*)
(*part2 = Flatten[Partition[Rest@aut,{4,sz},ds],1]*)
(*},*)
(*Table[*)
(*{part1[[i]][[5;;10]],(#[[5;;10]])&/@part2[[i]]}->1*)
(*,{i,Length@part1}*)
(*]*)
(*]*)


(* ::Input:: *)
(*relations[x,12,12]*)


(* ::Text:: *)
(*Catenates a list of associations by adding the values.  *)


(* ::Input:: *)
(*dataP = *)
(*Table[*)
(*Table[*)
(*(relations[#,12,12])&@CellularAutomaton[aut,set[[str]],4]*)
(*,{str,Length@set}*)
(*]*)
(*,{aut,0,128}*)
(*];*)


(* ::Text:: *)
(*Just to try.*)


(* ::Input:: *)
(*dataB = Merge[#,Total]&@dataP*)


(* ::Input:: *)
(*Export["dataB6-4v2.m",dataB]*)


(* ::Input:: *)
(*"dataB6-4v2.m"*)


(* ::Input:: *)
(*Length@dataB*)
