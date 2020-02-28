IF OBJECT_ID('tempdb.dbo.#Client', 'U') IS NOT NULL
  DROP TABLE #Client; 
IF OBJECT_ID('tempdb.dbo.#ClientFinal', 'U') IS NOT NULL
  DROP TABLE #ClientFinal; 

GO

CREATE TABLE #Client
    (ID VARCHAR(200), 
	 DateOfVisit  VARCHAR(200), 
     Country VARCHAR(200), 
     Cathegory    VARCHAR(200), 
     mobileDeviceBranding    VARCHAR(200),
	 mobileDeviceModel   VARCHAR(200),
	 mobileMarketingName VARCHAR(200),
	 PageViews   INTEGER,
	 ProjectID   INTEGER
    );


BULK INSERT [#Client] FROM 'C:\Data\data.csv'
WITH (FIRSTROW = 2
   , FIELDTERMINATOR = ','
   
   , ROWTERMINATOR = '0x0a'
   , CODEPAGE = 'ACP'
   , DATAFILETYPE ='char'
)

/*SELECT * FROM #Client
ORDER BY DateOfVisit,ID ASC;*/
-- CODEPAGE, DATAFILETYPE parameters do not work in my edition, there is workaround with a CAST or REPLACE function,
-- which is too much time consuming. Ths means that some characters may be mismatched or corrupted.
-- FIELDQUOTE parameter does not work, thus I use a workaround with REPLACE function
UPDATE [#Client]
SET ID = REPLACE(ID,'"', ''),
	 DateOfVisit = REPLACE(DateOfVisit,'"', '') , 
     Country = REPLACE(Country,'"', ''), 
     Cathegory = REPLACE(Cathegory,'"', ''), 
     mobileDeviceBranding = REPLACE(mobileDeviceBranding,'"', ''),
	 mobileDeviceModel = REPLACE(mobileDeviceModel,'"', ''),
	 mobileMarketingName = REPLACE(mobileMarketingName,'"', ''),
	 PageViews   = REPLACE(PageViews,'"', ''),
	 ProjectID  = REPLACE(ProjectID,'"', '')

-- Value (not set) is replaced with NULL value
-- I presume that (not set) indicates either IP with a unknown location
-- or an unknown IP or a crashed procedure. It is necessary to further investigate
-- a reason for this output.
UPDATE [#Client]
SET ID = NULLIF(ID,'(not set)'),
	DateOfVisit = NULLIF(DateOfVisit,'(not set)') , 
    Country = NULLIF(Country,'(not set)'), 
    Cathegory = NULLIF(Cathegory,'(not set)'), 
    mobileDeviceBranding = NULLIF(mobileDeviceBranding,'(not set)'),
	mobileDeviceModel = NULLIF(mobileDeviceModel,'(not set)'),
	mobileMarketingName = NULLIF(mobileMarketingName,'(not set)')--,
	--PageViews   = NULLIF(PageViews,'(not set)'),
	--ProjectID  = NULLIF(ProjectID,'(not set)')
-- There have been strings 'NULL', which should be changed to NULL value  
UPDATE [#Client]
SET ID = NULLIF(ID,'NULL'),
	DateOfVisit = NULLIF(DateOfVisit,'NULL') , 
    Country = NULLIF(Country,'NULL'), 
    Cathegory = NULLIF(Cathegory,'NULL'), 
    mobileDeviceBranding = NULLIF(mobileDeviceBranding,'NULL'),
	mobileDeviceModel = NULLIF(mobileDeviceModel,'NULL'),
	mobileMarketingName = NULLIF(mobileMarketingName,'NULL')--,
	--PageViews   = NULLIF(PageViews,'NULL'),
	--ProjectID  = NULLIF(ProjectID,'NULL')
-- Value NA is replaced with NULL value
UPDATE [#Client]
SET ID = NULLIF(ID,'NA'),
    DateOfVisit = NULLIF(DateOfVisit,'NA') , 
    Country = NULLIF(Country,'NA'), 
    Cathegory = NULLIF(Cathegory,'NA'), 
    mobileDeviceBranding = NULLIF(mobileDeviceBranding,'NA'),
    mobileDeviceModel = NULLIF(mobileDeviceModel,'NA'),
    mobileMarketingName = NULLIF(mobileMarketingName,'NA')	 
  
/*SELECT * FROM #Client;*/
--I can switch ID to integer after column consolidation (It was possible to define ID as 
--Integer in the first place, but it is more careful approach to start with strings, 
--when loading unknown data)

alter table [#Client] 
   alter column ID int;

GO

update [#Client]
   SET DateOfVisit = convert(date,convert(varchar(10),DateOfVisit,120));

/*SELECT * 
   FROM #Client
ORDER BY ID ASC;*/

SELECT DATENAME(weekday,A.DateOfVisit) Weekday_ ,A.* INTO #ClientFinal 
   FROM #Client A
ORDER BY ID ASC;

/*SELECT * 
   FROM #ClientFinal
ORDER BY ID ASC;
*/
GO

SELECT mobileDeviceBranding AS Brands_in_Germany_and_Nigeria_in_January_2017_on_Mondays 
   FROM #ClientFinal
WHERE Country IN ('Germany', 'Nigeria')
AND DateOfVisit Between convert(date,'2017-01-01') AND convert(date,'2017-01-31')
AND Weekday_ = 'Monday'
--AND mobileDeviceBranding IS NOT NULL --
GROUP BY mobileDeviceBranding
ORDER BY mobileDeviceBranding;

GO

SELECT SUM(PageViews) AS Total_Page_Views, ProjectID 
   FROM #ClientFinal
WHERE Weekday_ IN ('Sunday', 'Saturday')
GROUP BY ProjectID
ORDER BY Total_Page_Views DESC;

/*SELECT ProjectID 
   FROM #ClientFinal --Alternative solution
WHERE Weekday_ IN ('Saturday', 'Sunday')
GROUP BY ProjectID
ORDER BY Sum(PageViews) DESC;*/

GO
/*SELECT                    --Auxiliary SELECT
   SPV.ProjectID, SPV.Weekday_, SPV.Total_Page_Views FROM
   ( 
      SELECT
      ROW_NUMBER() 
      OVER (PARTITION BY PV.ProjectID ORDER BY PV.Total_Page_Views DESC) AS RN, 
      PV.ProjectID, PV.Weekday_, PV.Total_Page_Views 
      FROM(
         SELECT SUM(PageViews) AS Total_Page_Views, ProjectID, Weekday_ FROM #ClientFinal
         GROUP BY ProjectID, Weekday_
      ) AS PV
   ) AS SPV
WHERE RN <= 2
;*/

SELECT
   SPV.ProjectID, SPV.mobileDeviceBranding, SPV.Total_Page_Views FROM
   ( 
      SELECT
      ROW_NUMBER() 
      OVER (PARTITION BY PV.ProjectID ORDER BY PV.Total_Page_Views DESC) AS RN, 
      PV.ProjectID, PV.mobileDeviceBranding, PV.Total_Page_Views 
      FROM(
         SELECT SUM(PageViews) AS Total_Page_Views, ProjectID, mobileDeviceBranding FROM #ClientFinal
         GROUP BY ProjectID, mobileDeviceBranding
      ) AS PV
   ) AS SPV
WHERE RN <= 5
;

GO

SELECT 
   TOP 2 Weekday_, SUM(PageViews) AS "Page Views from iPhone"
   FROM #ClientFinal
WHERE mobileDeviceModel = 'iPhone'
GROUP BY Weekday_
ORDER BY SUM(PageViews) DESC
;

GO

SELECT
   SPV.Country, SPV.mobileDeviceBranding, SPV.Total_Page_Views FROM
   ( 
      SELECT
      ROW_NUMBER() 
      OVER (PARTITION BY PV.Country ORDER BY PV.Total_Page_Views DESC) AS RN, 
      PV.Country, PV.mobileDeviceBranding, PV.Total_Page_Views 
      FROM(
         SELECT SUM(PageViews) AS Total_Page_Views, Country, mobileDeviceBranding FROM #ClientFinal
            WHERE Country IN ('Denmark', 'Romania', 'Georgia', 'Nigeria', 'Tunisia')
	        GROUP BY Country, mobileDeviceBranding
      ) AS PV
   ) AS SPV
WHERE RN <= 1
ORDER BY SPV.Total_Page_Views DESC
;

GO
--SELECT * FROM #ClientFinal; --Auxiliary SELECT


