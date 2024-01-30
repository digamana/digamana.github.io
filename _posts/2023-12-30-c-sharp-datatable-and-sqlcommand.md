---
layout: post
title: C# DataTable and SqlCommand 資料庫底層套件操作
date: 2023-12-30 20:58 +0800
---
## 前言

<p>演示C#利用底層套件SqlCommand 和 DataTable進行資料庫讀寫</p>

## 開始


## Oracle SQL版本

示範進行Insert、Update、Delete
<script  type='text/javascript' src=''>

    IDbConnection _connection = new OracleConnection("ConnectString");
    _connection.Open();
    IDbTransaction _transaction = _connection.BeginTransaction();
		OracleCommand sqlCmdExe = new OracleCommand();

		string sqlCmd = @"SELECT  ID,NAME from DEMO Where ID = :ID and NAME = :NAME";
		sqlCmdExe.Parameters.Add(":ID", OracleType.VarChar, 4).Value = ID;
		sqlCmdExe.Parameters.Add(":NAME", OracleType.VarChar, 2).Value = NAME;
		sqlCmdExe.CommandText = sqlCmd;

    sqlCmd.Connection = (OracleConnection)_connection;
    sqlCmd.Transaction = (OracleTransaction)_transaction;
    sqlCmd.ExecuteNonQuery();




示範進行Select Table並把資料放到DataTable中
<script  type='text/javascript' src=''>

    public static DataTable GetDEMO(string ID,string NAME)
    {
        IDbConnection _connection = new OracleConnection("ConnectString");
    		OracleCommand sqlCmdExe = new OracleCommand();

		    string sqlCmd = @"SELECT  ID,NAME from DEMO Where ID = :ID and NAME = :NAME"; //Oracle SQL寫語法時 要加上Owner
		    sqlCmd.Parameters.Add(":ID", OracleType.VarChar, 4).Value = ID;
        sqlCmd.Parameters.Add(":NAME", OracleType.VarChar, 2).Value = NAME;
		    sqlCmd.CommandText = sqlCmd;

        rtnDT = DBReader(_connection, sqlCmdExe);
        rtnDT.TableName = "useDT";
    }

    public static DataTable DBReader(IDbConnection DBConn, IDbCommand DBCommand)
    {
			
			  DataTable dt = new DataTable();
        try
        {
            if (DBConn.State == ConnectionState.Open) DBConn.Close();
            DBConn.Open();
            DBCommand.Connection = DBConn;
            dt.Load(DBCommand.ExecuteReader());
            DBConn.Close();
        }
        catch (Exception ex)
        {
            if (DBConn.State == ConnectionState.Open) DBConn.Close();
            ex.ToString();
        }
        return dt;
    }



## MSSQL版本

示範進行Insert、Update、Delete
<script  type='text/javascript' src=''>

    IDbConnection _connection = new SqlConnection("ConnectString");
    _connection.Open();
    IDbTransaction _transaction = _connection.BeginTransaction();
		SqlCommand sqlCmdExe = new SqlCommand();

		string sqlCmd = @"SELECT  ID,NAME from DEMO Where ID = @ID and NAME = @NAME";
		sqlCmdExe.Parameters.Add("@ID", SqlDbType.VarChar, 4).Value = ID;
		sqlCmdExe.Parameters.Add("@NAME", SqlDbType.VarChar, 2).Value = NAME;
		sqlCmdExe.CommandText = sqlCmd;

    sqlCmd.Connection = (SqlConnection)_connection;
    sqlCmd.Transaction = (SqlTransaction)_transaction;
    sqlCmd.ExecuteNonQuery();




示範進行Select Table並把資料放到DataTable中
<script  type='text/javascript' src=''>

    public static DataTable GetDEMO()
    {
        IDbConnection _connection = new SqlConnection("ConnectString");
    		SqlCommand sqlCmdExe = new SqlCommand();

		    string sqlCmd = @"SELECT ID,NAME from DEMO";
		    sqlCmdExe.Parameters.Add("@ID", SqlDbType.VarChar, 4).Value = ID;
		    sqlCmdExe.Parameters.Add("@NAME", SqlDbType.VarChar, 2).Value = NAME;
		    sqlCmdExe.CommandText = sqlCmd;

        rtnDT = DBReader(_connection, sqlCmdExe);
        rtnDT.TableName = "useDT";
    }

    public static DataTable DBReader(IDbConnection DBConn, IDbCommand DBCommand)
    {
			
			  DataTable dt = new DataTable();
        try
        {
            if (DBConn.State == ConnectionState.Open) DBConn.Close();
            DBConn.Open();
            DBCommand.Connection = DBConn;
            dt.Load(DBCommand.ExecuteReader());
            DBConn.Close();
        }
        catch (Exception ex)
        {
            if (DBConn.State == ConnectionState.Open) DBConn.Close();
            ex.ToString();
        }
        return dt;
    }

## DataTable進行Linq Where

示範
<script  type='text/javascript' src=''>

		/// <summary>
		/// 根據開始時間跟結束時間 找到名稱
		/// </summary>
		/// <param name="dt">資料表 裡面有startDate、endDate、Name</param>
    /// <param name="dateTime"></param>
		/// <returns></returns>
		public List<string> GetName(DataTable dt,DateTime dateTime)
		{
			List<string> lst = dt.AsEnumerable()
			.Where(row =>
			{
				DateTime startDate = row.Field<DateTime>("START_DATE");
				DateTime endDate = row.Field<DateTime>("END_DATE");
				return dateTime >= startDate && dateTime <= endDate;
			})
			.Select(row => row.Field<string>("Name"))
			.ToList();
			return lst;
		}


## 靜態擴展範例

示範
<script  type='text/javascript' src=''>


    public static class Extension
    {
	    /// <summary>
	    /// DataRow Mapping到 Class 
	    /// </summary>
	    /// <typeparam name="T"></typeparam>
	    /// <param name="row"></param>
	    /// <returns></returns>
	    public static T ToClass<T>(this DataRow row) where T : new()
	    {
		    T obj = new T();
		    if (row == null) return obj;
		    foreach (DataColumn column in row.Table.Columns)
		    {
			    PropertyInfo property = typeof(T).GetProperty(column.ColumnName);
			    if (property != null && row[column] != DBNull.Value)
			    {
				    property.SetValue(obj, Convert.ChangeType(row[column], property.PropertyType), null);
			    }
		    }
		    return obj;
	    }
	    /// <summary>
	    /// DataTable 轉 List<T>
	    /// </summary>
	    /// <typeparam name="T"></typeparam>
	    /// <param name="dt"></param>
	    /// <returns></returns>
	    public static IEnumerable<T> ToList<T>(this DataTable dt) where T : new()
	    {
		    List<T> lst = new List<T>();
		    foreach (DataRow dr in dt.Rows)
		    {
			    var temp = dr.ToClass<T>();
			    lst.Add(temp);
		    }
		    return lst;
      }
    }
