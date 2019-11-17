IF OBJECT_ID('tempdb.dbo.#Client', 'U') IS NOT NULL
  DROP TABLE #Client; 
IF OBJECT_ID('tempdb.dbo.#Private_Bankers', 'U') IS NOT NULL
  DROP TABLE #Private_Bankers; 
IF OBJECT_ID('tempdb.dbo.#Debts', 'U') IS NOT NULL
  DROP TABLE #Debts; 

GO

CREATE TABLE #Client
    (Client_ID Integer not null primary key, 
	 Name  VARCHAR(200), 
     Surname VARCHAR(200), 
     Phone    VARCHAR(20), 
     Address_   VARCHAR(200), 
     Email    VARCHAR(100)
    );

CREATE TABLE #Private_Bankers
    (Loan_ID  Integer not null primary key, 
     Type_of_loan  VARCHAR(200), 
     Banker VARCHAR(200),
	 Number_of_products Integer
    );

CREATE TABLE #Debts
    (Client_ID Integer not null primary key, 
	 Loan_ID  Integer not null, 
     Date_from Date not null, 
     Date_to Date default '2999-12-31'
    );

GO

insert into #Client values ('1','Jan','Novák','777987654','Újezd','jan.novak@seznam.cz');
insert into #Client values ('2','Jana','Nováková','777987654','Újezd','jana.novakova@seznam.cz');
insert into #Client values ('3','Jiří','Nováček','777987654','Újezd','jiri.novacek@seznam.cz');
insert into #Client values ('4','Jiří','Novák','777987654','Újezd','jiri.novak@seznam.cz');
insert into #Client values ('5','Julius','Novák','777987654','Újezd','julius.novak@seznam.cz');

GO

insert into #Private_Bankers values ('1','Short term loan','F. Rohlík','3');
insert into #Private_Bankers values ('2','Short term loan','L. Zele','3');
insert into #Private_Bankers values ('3','Short term loan','T. Shone','3');
insert into #Private_Bankers values ('4','Long term loan','S. Fabb','1');

GO

insert into #Debts values ('1','1',GETDATE()-15,GETDATE());
insert into #Debts values ('2','2',GETDATE()-200,GETDATE());
insert into #Debts values ('3','2',GETDATE()-25,GETDATE());
insert into #Debts values ('4','2',GETDATE()-200,GETDATE());
insert into #Debts values ('4','3',GETDATE()-200,GETDATE());
insert into #Debts values ('4','3',GETDATE()-400,GETDATE());
insert into #Debts values ('4','3',GETDATE()-400,DEFAULT);

GO

--SELECT Liabilities longer than 60 days
SELECT C.Client_ID, C.Name +' '+ C.Surname 'Customer' 
   FROM #Client C 
   JOIN #Debts Z ON Z.Client_ID = C.Client_ID
WHERE (DATEDIFF(day, Date_from, GETDATE())) > 60
AND Date_to = '2999-12-31'
GROUP BY C.Client_ID, C.Name, C.Surname
ORDER BY Client_ID
;

GO

--SELECT Performance of Private Bankers 
SELECT K.Type_of_loan 'Performance of Private Bankers', A.Number_of_products 
   FROM #Private_Bankers K 
   JOIN #Debts Z ON Z.Loan_ID = K.Loan_ID
   JOIN (SELECT Z.Loan_ID, COUNT(Z.Loan_ID) Number_of_products
            FROM #Private_Bankers K 
            JOIN #Debts Z ON Z.Loan_ID = K.Loan_ID
         GROUP BY Z.Loan_ID
        ) A ON A.Loan_ID = K.Loan_ID
AND K.Number_of_products = A.Number_of_products
GROUP BY K.Type_of_loan,Z.Loan_ID,K.Number_of_products,A.Number_of_products
;

GO

--SELECT Nonperforming Private Bankers
SELECT K.Type_of_loan 'Nonperforming Private Bankers', K.Number_of_products
   FROM #Private_Bankers K 
   LEFT JOIN #Debts Z ON Z.Loan_ID = K.Loan_ID 
WHERE Z.Loan_ID IS NULL
;

GO

--SELECT Client with the most personal loans
SELECT C.Client_ID, C.Name  + ' ' + C.Surname AS 'Customer', C.Phone, C.Address_, C.Email, COUNT (Z.Client_ID)  AS Vypujcky 
   FROM #Client C
   JOIN #Debts Z ON Z.Client_ID = C.Client_ID
   AND YEAR(Z.Date_from) = YEAR(GETDATE())
GROUP BY Z.Client_ID, C.Client_ID, C.Name, C.Surname, C.Phone, C.Address_, C.Email
HAVING COUNT (Z.Client_ID) = 
   (SELECT MAX (P.Amount) 
       FROM(
	   SELECT COUNT(Loan_ID) Amount 
          FROM #Debts Z
		  WHERE YEAR(Z.Date_from) = YEAR(GETDATE()) 
       GROUP BY Client_ID
       ) 
   P)
;
