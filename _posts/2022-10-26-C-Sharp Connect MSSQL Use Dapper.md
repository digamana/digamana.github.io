---
layout: post
title: C# Connect MSSQL Use Dapper
date: 2022-10-26 15:41 +0800
categories: [Visual studio And MSSQL,C# CRUD MSSQL Use Dapper]
tags: [Dapper,C#]
published: true 
---

## 範例資料表  
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect MSSQL Use Dapper/1.png){: width="600" height="500" }  
上圖中的資料源可從這邊取得  
Github：https://github.com/digamana/Open-Sql-Data-Source


## 安裝Dapper
Use Nuget Setup Dapper  
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect MSSQL Use Dapper/2.png){: width="600" height="500" }
<script type='text/javascript' src=''>

    NuGet\Install-Package Dapper -Version 2.0.123



## 範例資料表的Class
Creat New Class Exmaple：DemoSheet.cs
<script  type='text/javascript' src=''>

    namespace DemmoDapper
    {
        using System.ComponentModel.DataAnnotations;
        using System.ComponentModel.DataAnnotations.Schema;

        [Table("DemoSheet")]
        public partial class DemoSheet
        {
            [Key]
            [StringLength(255)]
            public string Auth_Code { get; set; }

            [StringLength(255)]
            public string Auth_ZhName { get; set; }

            [StringLength(255)]
            public string Auth_EnName { get; set; }

            [StringLength(255)]
            public string Postal_Code { get; set; }

            [StringLength(255)]
            public string Auth_Addr { get; set; }

            [StringLength(255)]
            public string Auth_Phone { get; set; }

            [StringLength(255)]
            public string ComAuth_Code { get; set; }

            [StringLength(255)]
            public string ComAuth_Name { get; set; }

            [StringLength(255)]
            public string Fax { get; set; }

            public double? Auth_EffectDate { get; set; }

            public double? Auth_AbolitDate { get; set; }

            [StringLength(255)]
            public string Auth_Level { get; set; }

            [StringLength(255)]
            public string Auth_AbolitTag { get; set; }

            [StringLength(255)]
            public string NewAuth_Code { get; set; }

            [StringLength(255)]
            public string Auth_NewName { get; set; }

            [StringLength(255)]
            public string NewAuth_EffectDate { get; set; }

            [StringLength(255)]
            public string OddAuth_Code { get; set; }

            [StringLength(255)]
            public string OddAuth_Name { get; set; }
        }
    }


## 使用Dapper取得DB資料的範例
Use Dapper Get Data Example：
<script  type='text/javascript' src=''>

    using Dapper;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    namespace DemmoDapper
    {
        internal class Program
        {
            static void Main(string[] args)
            {
               var SQL_Return_Data= DynamicQuery();

            }
            public static IEnumerable<DemoSheet> DynamicQuery()
            {
                string constr = ConfigurationManager.ConnectionStrings["DemmoDapper"].ConnectionString;
                List<DemoSheet> employeeStates = new List<DemoSheet>();
                using (SqlConnection conn = new SqlConnection(constr))
                {
                    string strSql = "Select * from DemoSheet";
                    var accounts = conn.Query<DemoSheet>(strSql);
                    return accounts;
                }
            }
        }
    }



## 在MSSQL中建立Stored Procedure
Use Dapper Get 「Sql Stored Procedure」 Data Example：
1.Creat Sql Stored Procedure Example
<script  type='text/javascript' src=''>

    USE [TestDB]
    GO

    /****** Object:  StoredProcedure [dbo].[spGetAllTestDB]    Script Date: 2022/11/4 下午 05:35:22 ******/
    SET ANSI_NULLS ON
    GO

    SET QUOTED_IDENTIFIER ON
    GO

    /*創建預存程序語法: CREATE PROCEDURE {程序名稱}*/
    CREATE PROCEDURE [dbo].[spGetAllTestDB] /*注意: 名稱不能是sp_開頭!("sp_"是預留給系統的))*/
    AS
    BEGIN
     /*從這邊開始輸入要預存的SQL指令*/
     SELECT * FROM  TestDB.dbo.DemoSheet   
    END 
    GO




## 使用Dapper執行Stored Procedure的範例
2.Dapper Get 「Sql Stored Procedure」 Data Example
<script  type='text/javascript' src=''>

    using Dapper;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    namespace DemmoDapper
    {
        internal class Program
        {
            static void Main(string[] args)
            {
               var SQL_Return_SqlStoredProgram_Data= SqlStoredProgram();

            }
            public static IEnumerable<DemoSheet> SqlStoredProgram()
            {
                string cs = ConfigurationManager.ConnectionStrings["DemmoDapper"].ConnectionString;
                List<DemoSheet> demoSheetDetails = new List<DemoSheet>();
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("spGetAllTestDB", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        DemoSheet demoSheet = new DemoSheet();
                        demoSheet.Auth_Code = reader["Auth_Code"].ToString();
                        demoSheet.Auth_ZhName = reader["Auth_ZhName"].ToString();
                        demoSheet.Auth_EnName = reader["Auth_EnName"].ToString();
                        demoSheet.Postal_Code = reader["Postal_Code"].ToString();
                        demoSheet.Auth_Addr = reader["Auth_Addr"].ToString();
                        demoSheet.Auth_Phone = reader["Auth_Phone"].ToString();
                        demoSheet.ComAuth_Code = reader["ComAuth_Code"].ToString();
                        demoSheet.ComAuth_Name = reader["ComAuth_Name"].ToString();
                        demoSheet.Fax = reader["Fax"].ToString();
                        demoSheetDetails.Add(demoSheet);
                    }
                }
                return demoSheetDetails;
            }
        }
    }



![Desktop View](/assets/img/2022-10-26-C-Sharp Connect MSSQL Use Dapper/3.png){: width="600" height="500" }
