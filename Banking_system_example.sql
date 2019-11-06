use adventureWorks2017
go

begin tran t1
go

IF OBJECT_ID('dbo.client', 'U') IS NOT NULL 
  DROP TABLE dbo.client;
  
  IF OBJECT_ID('dbo.balance', 'U') IS NOT NULL 
  DROP TABLE dbo.balance;

  IF OBJECT_ID('dbo.transaction', 'U') IS NOT NULL 
  DROP TABLE dbo.transaction;




create table dbo.client (
client_id numeric(12),
name varchar(50),
category integer )


create table dbo.balance (
client_id numeric(12),
currency varchar(3),
amount numeric(18,2) )

create table dbo.transaction (
transaction_id numeric(12),
client_id_debit numeric(12),
client_id_credit numeric(12),
date_v datetime,
currency varchar(3),
volume numeric(18,2) )
go


insert into dbo.client
values (1,'John Smith', 1),
(2,'John Smith 2', 1),
(3,'John Smith 3', 2),
(4,'John Smith 4', 2)


insert into dbo.balance
values (1,'USD', 100),
(2,'USD', 200),
(3,'USD', 300),
(4,'USD', 400),
(1,'EUR', -100),
(2,'JPN', 200),
(3,'GBP', 300),
(4,'CZK', 400)

insert into dbo.transaction
values (1,1,2,GETDATE(), 'USD', 100),
(2,1,2,GETDATE(), 'USD', 100),
(3,1,2,GETDATE(), 'USD', 100),
(4,1,2,GETDATE(), 'USD', 100),
(5,1,2,GETDATE()-1, 'USD', 100),
(6,1,2,GETDATE()-1, 'USD', 100),
(7,1,2,GETDATE()-1, 'USD', 100),
(8,1,2,GETDATE()-1, 'USD', 100)



select k.category, su.currency, sum(su.amount) 'sum of balances' from dbo.client k

inner join dbo.balance su on su.client_id = k.client_id
group by su.currency, k.category



select currency, 
   sum(case when amount < 0 then amount else 0 end) 'negative balance',
   sum(case when amount > 0 and amount <= 1000000 then amount else 0 end) 'balances below 1 million',
   sum(case when amount > 1000000 then amount else 0 end) 'balances over 1 million'
   
from dbo.balance
group by currency
order by currency asc


commit tran t1



BEGIN TRAN t2
GO
CREATE OR ALTER PROCEDURE dbo.flow 
       (
	   @client_id_debit numeric(12), 
       @client_id_credit numeric(12),
	   @currency varchar(3),
	   @volume numeric(18,2),
	   @Msg nvarchar(MAX)=null OUTPUT
	   )
AS 
BEGIN TRY
     DECLARE @amount1 int
	 DECLARE @amount2 int
     INSERT INTO dbo.transaction
          (                    
            transaction_id,
            client_id_debit,
            client_id_credit,
            date_v,
            currency,
            volume                 
          ) 
     VALUES 
          ( 
            (SELECT MAX (transaction_id) + 1 FROM dbo.transaction),
            @client_id_debit,
            @client_id_credit,
			GETDATE(),
            @currency,
			@volume
          ) 
   SELECT @Msg AS 'Data successfully inserted.'
  
   UPDATE dbo.balance
   SET amount =  amount + @volume
       WHERE client_id = @client_id_credit and currency = @currency
   UPDATE dbo.balance
   SET amount =  amount - @volume
       WHERE client_id = @client_id_debit and currency = @currency 	   
END TRY

BEGIN CATCH
   SET @Msg=ERROR_MESSAGE()
END CATCH

GO
exec dbo.flow 
    @client_id_debit = 2, 
       @client_id_credit = 3,
	   @currency = USD,
	   @volume = 10000

GO
COMMIT TRAN t2;

GO
begin tran t3
GO
CREATE OR ALTER PROCEDURE dbo.sum_to_date 
       (
	   @client_id numeric(12), 
       @date datetime
	   )
AS 
BEGIN
   DECLARE @suma numeric(15)
   DECLARE @suma2 numeric(15)
   DECLARE @suma3 numeric(15)
   SET @suma = (SELECT TOP 1 a.OV from 
   (SELECT SUM(T.volume) as OV, T.client_ID_debit FROM DBO.transaction T
   WHERE T.date_v > @date
   AND T.client_ID_debit = @client_id
   AND T.currency = 'USD'
   GROUP BY T.client_ID_debit) 
   a)
   SET @suma2 = (SELECT TOP 1 a.OV from 
   (SELECT SUM(T.volume) as OV, T.client_ID_credit FROM DBO.transaction T
   WHERE T.date_v > @date
   AND T.client_ID_credit = @client_id
   AND T.currency = 'USD'
   GROUP BY T.client_ID_credit) 
   a)
   SET @suma3 = (SELECT TOP 1 B.amount FROM DBO.balance B
   WHERE B.client_ID = @client_id
   AND B.currency = 'USD'
   )
   SELECT (@suma-@suma2+@suma3) as 'Balance', @date 'Date', @client_id 'client_id', 'USD' as 'currency'
   
   SET @suma = (SELECT TOP 1 a.OV from 
   (SELECT SUM(T.volume) as OV, T.client_ID_debit FROM DBO.transaction T
   WHERE T.date_v > @date
   AND T.client_ID_debit = @client_id
   AND T.currency = 'CZK'
   GROUP BY T.client_ID_debit) 
   a)
   SET @suma2 = (SELECT TOP 1 a.OV from 
   (SELECT SUM(T.volume) as OV, T.client_ID_credit FROM DBO.transaction T
   WHERE T.date_v > @date
   AND T.client_ID_credit = @client_id
   AND T.currency = 'CZK'
   GROUP BY T.client_ID_credit) 
   a)
   SET @suma3 = (SELECT TOP 1 B.amount FROM DBO.balance B
   WHERE B.client_ID = @client_id
   AND B.currency = 'CZK'
   )
   SELECT (@suma-@suma2+@suma3) as 'Balance', @date 'Date', @client_id 'client_id', 'CZK' as 'currency'
   
   SET @suma = (SELECT TOP 1 a.OV from 
   (SELECT SUM(T.volume) as OV, T.client_ID_debit FROM DBO.transaction T
   WHERE T.date_v > @date
   AND T.client_ID_debit = @client_id
   AND T.currency = 'EUR'
   GROUP BY T.client_ID_debit) 
   a)
   SET @suma2 = (SELECT TOP 1 a.OV from 
   (SELECT SUM(T.volume) as OV, T.client_ID_credit FROM DBO.transaction T
   WHERE T.date_v > @date
   AND T.client_ID_credit = @client_id
   AND T.currency = 'EUR'
   GROUP BY T.client_ID_credit) 
   a)
   SET @suma3 = (SELECT TOP 1 B.amount FROM DBO.balance B
   WHERE B.client_ID = @client_id
   AND B.currency = 'EUR'
   )
   SELECT (@suma-@suma2+@suma3) as 'Balance', @date 'Date', @client_id 'client_id', 'EUR' as 'currency'
 END

GO
exec dbo.sum_to_date
    @client_id = 2, 
       @date = '2019-10-21';

select * from dbo.transaction;

select * from dbo.client;

select * from dbo.balance;
commit tran t3;