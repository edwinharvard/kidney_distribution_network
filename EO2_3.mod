param num_patients integer >= 1;
set PATIENTS := {1 .. num_patients}; # includes none to make the cycle set adaptable for both 2 and 3 cycles
param C {PATIENTS, PATIENTS} binary; # input matrix, 1 at (i,j) if i donor is a match for j patient

set C2 = # we define cycles as tuples of length 2
	setof {i in PATIENTS, j in PATIENTS: i < j and C[i,j] = 1 and C[j,i] = 1}
          (i,j);
set C3 = # cycles of length 3
	setof {i in PATIENTS, j in PATIENTS, k in PATIENTS:
           i < j and j < k and
           C[i,j] = 1 and C[j,k] = 1 and C[k,i] = 1}
          (i,j,k);


var X2 {(i,j) in C2} binary; # decision variable if cycle C2 gets used
var X3 {(i,j,k) in C3} binary; # decision variable if cycle C3 gets used
#var Y {p in PATIENTS}; # decision variable if patient p participates in the kidney exchange
 

#maximize kidney_delivery: sum {p in PATIENTS} Y[p]; # max number of patients participating 
maximize kidney_delivery:
	sum{(i,j) in C2}        2 * X2[i,j]
    + sum{(i,j,k) in C3}      3 * X3[i,j,k];

subject to patient_used {p in PATIENTS}:
	 sum{(i,j) in C2 : i = p  or j = p}                X2[i,j] # only cares about cycles where patient p is in the cycle
    + sum{(i,j,k) in C3 : i = p or j = p or k = p}     X3[i,j,k]
    <= 1;

#subject to link_Y {p in PATIENTS}:
   # Y[p] = (sum {c in C2: c[1]=p or c[2]=p} X[c] +
         #  sum {c in C3: c[1]=p or c[2]=p or c[3]=p} X[c]);
