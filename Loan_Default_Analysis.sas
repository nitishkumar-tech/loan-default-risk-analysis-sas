/* Step 1: Import the dataset */
PROC IMPORT DATAFILE="loan_data.csv"
     OUT=loan_data
     DBMS=CSV
     REPLACE;
     GETNAMES=YES;
RUN;

/* Step 2: Data Preparation */
DATA clean_data;
    SET loan_data;
    IF Gender = "Male" THEN Gender_num = 1;
    ELSE IF Gender = "Female" THEN Gender_num = 0;

    IF Previous_Default = "Yes" THEN Prev_Default = 1;
    ELSE IF Previous_Default = "No" THEN Prev_Default = 0;

    IF Defaulted = "Yes" THEN Defaulted_flag = 1;
    ELSE IF Defaulted = "No" THEN Defaulted_flag = 0;
RUN;

/* Step 3: Summary Statistics */
PROC MEANS DATA=clean_data N MEAN STD MIN MAX;
RUN;

PROC FREQ DATA=clean_data;
    TABLES Defaulted Gender Loan_Purpose Previous_Default / CHISQ;
RUN;

/* Step 4: Visualizations */
PROC SGPLOT DATA=clean_data;
    VBAR Loan_Purpose / GROUP=Defaulted;
RUN;

/* Step 5: Logistic Regression */
PROC LOGISTIC DATA=clean_data;
    MODEL Defaulted_flag(event='1') = Age Income Credit_Score Loan_Amount Loan_Term Gender_num Prev_Default;
RUN;

/* Step 6: ROC Curve */
PROC LOGISTIC DATA=clean_data PLOTS=ROC;
    MODEL Defaulted_flag(event='1') = Age Income Credit_Score Loan_Amount Loan_Term;
RUN;
