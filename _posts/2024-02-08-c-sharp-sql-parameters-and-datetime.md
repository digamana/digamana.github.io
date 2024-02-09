---
layout: post
title: C# Sql Parameters and DateTime
date: 2024-02-08 12:46 +0800
---
## 前言
<p>有鑑於經常需要在C#存取DB中的Date欄位</p>

<p>在SQL Manager中就算只是簡單的 Select * from demo where ToDay = '2024-02-08' 這種語法</p>

<p>放到C#中卻還是會需要想 這邊的'2024-02-08'底是要使用DateTime型態 還是 String型態</p>

<p>所以在這邊紀錄透過C#動態參數 存取SQL的DateTime欄位的方式</p>

## MSSQL

### C# 提供String日期,在SQL語法轉換型態 

如下
<script  type='text/javascript' src=''>

    public int Test1(string ID, string SALES_DATES, string TRANS_NO)
    {
      string sqlCmdStr = @"
			Select * from Demo 
		where  1 = 1 
		And ID = @ID 
		and TRANS_NO = @TRANS_NO
		and SALES_DATE = @SALES_DATES
			";

            SqlConnection conn = new SqlConnection("");
            SqlCommand sqlCmd = new SqlCommand();

            sqlCmd.CommandText = sqlCmdStr;
            sqlCmd.Parameters.Add("@ID", SqlDbType.VarChar, 6).Value = ID;
            sqlCmd.Parameters.Add("@TRANS_NO", SqlDbType.VarChar, 20).Value = TRANS_NO;
            sqlCmd.Parameters.Add("@SALES_DATES", SqlDbType.VarChar, 10).Value = SALES_DATES;
            var result = sqlCmd.ExecuteNonQuery();
            return result;
    }


### C# 提供DateTime日期 
如下
<script  type='text/javascript' src=''>

    public int Test1(string ID, DateTime SALES_DATES, string TRANS_NO)
    {
      string sqlCmdStr = @"
			  Select * from Demo 
		    where  1 = 1 
		    And ID = @ID 
		    and TRANS_NO = @TRANS_NO
		    and SALES_DATE = @SALES_DATES
			    ";

        SqlConnection conn = new SqlConnection("");
        SqlCommand sqlCmd = new SqlCommand();

        sqlCmd.CommandText = sqlCmdStr;
        sqlCmd.Parameters.Add("@ID", SqlDbType.VarChar, 6).Value = ID;
        sqlCmd.Parameters.Add("@TRANS_NO", SqlDbType.VarChar, 20).Value = TRANS_NO;
        sqlCmd.Parameters.Add("@SALES_DATES", SqlDbType.DateTime, 10).Value = SALES_DATES;
        var result = sqlCmd.ExecuteNonQuery();
        return result;
    }

### C# 提供多個String日期,在SQL語法查詢多個指定日期的Method寫法
如下
<script  type='text/javascript' src=''>

    public int Test2(List<string> SALES_DATES)
    {
        string sqlCmdStr = @"Select * from DEMO_LOG where 1 = 1 ";

        SqlConnection conn = new SqlConnection("");
        SqlCommand sqlCmd = new SqlCommand();
        string sqlWhere = string.Empty;
        int i = 0;
  
        foreach (string SALES_DATE in SALES_DATES)
        {
            sqlWhere += string.Format("	( YEAR(sales_date) = @Year{0} AND MONTH(sales_date) = @Month{0}", i);
            sqlCmd.Parameters.Add(string.Format("@Year{0}", i), SqlDbType.VarChar, 4).Value = SALES_DATE.Split('-')[0];
            sqlCmd.Parameters.Add(string.Format("@Month{0}", i), SqlDbType.VarChar, 2).Value = SALES_DATE.Split('-')[1];
            if (SALES_DATE.Split('-').Count() >= 3)
            {
                sqlWhere += string.Format(" And	Day(sales_date) = @Day{0} ", i);
                sqlCmd.Parameters.Add(string.Format("@Day{0}", i), SqlDbType.VarChar, 2).Value = SALES_DATE.Split('-')[2];
            }
            i++;
            sqlWhere += " )  or";
        }

        sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 2);
        sqlWhere = string.Format("And ( {0} )", sqlWhere);
        sqlCmdStr += sqlWhere;
        sqlCmd.CommandText = sqlCmdStr;

        var result = sqlCmd.ExecuteNonQuery();
        return result;
    }



### 搜尋指定"年"

如下 EX:搜尋日期2023年
<script  type='text/javascript' src=''>

    Select * from DEMO_LOG M where 1 = 1
    AND YEAR(M.sales_date) = '2023'

### 搜尋指定"年月"
如下  EX:搜尋日期2023年2月
<script  type='text/javascript' src=''>

    Select * from DEMO_LOG M where 1 = 1
    AND YEAR(M.sales_date) = '2023'
    AND MONTH(M.sales_date) ='02'


### 搜尋指定"年月日"
如下 EX:搜尋日期2023年2月1日
<script  type='text/javascript' src=''>

    Select * from DEMO_LOG M where 1 = 1
    AND YEAR(M.sales_date) = '2023'
    AND MONTH(M.sales_date) ='02'
    AND Day(M.sales_date) ='01'

## Oracle

### C# 提供String日期,在SQL語法轉換型態
如下
<script  type='text/javascript' src=''>

      public int Test(string ID, string SALES_DATES, string TRANS_NO)
      {
          string sqlCmdStr = @"
			        Select * from Onwer.Demo t
			        where 1 = 1 
			        and t.ID = :ID
			        and t.SALES_DATE =  to_date( :SALES_DATES ,'yyyy-MM-dd')	
			        and t.trans_No = :TRANS_NO
			        ";
              OracleConnection conn = new OracleConnection("");
              OracleCommand sqlCmd = new OracleCommand();

              sqlCmd.Parameters.Add(":ID", OracleType.VarChar, 6).Value = ID;
              sqlCmd.Parameters.Add(":TRANS_NO", OracleType.VarChar, 20).Value = TRANS_NO;
              sqlCmd.Parameters.Add(":SALES_DATES", OracleType.VarChar, 10).Value = SALES_DATES;
              sqlCmd.CommandText = sqlCmdStr;
              var result = sqlCmd.ExecuteNonQuery();
          return result;
      }

### C# 提供DateTime日期


### C# 提供多個String日期,在SQL語法查詢多個指定日期的Method寫法
如下
<script  type='text/javascript' src=''>

    public DataTable Test3(List<string> SALES_DATES)
    {
        DataTable rtnObj = new DataTable();
        OracleConnection conn = new OracleConnection("");
        OracleCommand sqlCmd = new OracleCommand();
                
            string sqlCmdStr = "";
            sqlCmdStr = @"
              SELECT * From OWNER.DEMO D 
              Where 1 = 1 
		    ";
            string sqlWhere = string.Empty;
            int i = 0;
            foreach (string SALES_DATE in SALES_DATES)
            {
                sqlWhere += string.Format("(EXTRACT(YEAR FROM D.sales_date) = :Year{0} AND EXTRACT(MONTH FROM D.sales_date) = :Month{0} ", i);
                sqlCmd.Parameters.Add(string.Format(":Year{0}", i), OracleType.VarChar, 4).Value = SALES_DATE.Split('-')[0];
                sqlCmd.Parameters.Add(string.Format(":Month{0}", i), OracleType.VarChar, 2).Value = SALES_DATE.Split('-')[1];
                if (SALES_DATE.Split('-').Count() >= 3)
                {
                    sqlWhere += string.Format(" AND EXTRACT(Day FROM D.sales_date) = :Day{0} ", i);
                    sqlCmd.Parameters.Add(string.Format(":Day{0}", i), OracleType.VarChar, 2).Value = SALES_DATE.Split('-')[2];
                }
                sqlWhere += " ) or";
                i++;
            }
            sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 2);
            sqlWhere = string.Format("And ( {0} )", sqlWhere);
            sqlWhere += "order by D.STORE_ID , D.SALES_DATE,D.TRANS_NO";
            sqlCmdStr += sqlWhere;
            sqlCmd.CommandText = sqlCmdStr;
            return rtnObj;
    }


### 搜尋指定"年"
如下 EX:搜尋日期2023年
<script  type='text/javascript' src=''>

    SELECT * From OWNER.DEMO D 
    Where 1 = 1 
    And EXTRACT(YEAR FROM D.sales_date) = '2023'

### 搜尋指定"年月"
如下  EX:搜尋日期2023年2月
<script  type='text/javascript' src=''>

    SELECT * From OWNER.DEMO D 
    Where 1 = 1 
    And EXTRACT(YEAR FROM D.sales_date) = '2023'
    AND EXTRACT(MONTH FROM D.sales_date) = '02'

### 搜尋指定"年月日"
如下 EX:搜尋日期2023年2月1日
<script  type='text/javascript' src=''>

    SELECT * From OWNER.DEMO D 
    Where 1 = 1 
    And EXTRACT(YEAR FROM D.sales_date) = '2023'
    AND EXTRACT(MONTH FROM D.sales_date) = '02'
    AND EXTRACT(Day FROM D.sales_date) = '01'


## 靜態擴展
如下
