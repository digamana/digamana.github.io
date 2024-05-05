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


## 連線與取得DateTable的Method


### Oracle

示範
<script  type='text/javascript' src=''>

     public DataTable UseExample(string connStr)
     {
         DataTable rtnDT = new DataTable();
         try
         {
             oraclecon = oracleConnetion(connStr);
             OracleCommand sqlCmdExe = new OracleCommand();
             string sqlCmd = " SELECT * from demo.user M where  M.DateTimes = :DATES";
             sqlCmdExe.CommandText = sqlCmd;
             sqlCmdExe.Parameters.Add(":DATES", OracleType.DateTime).Value = System.DateTime.Now.AddDays(-9).ToString("yyyy/MM/dd");
          
             rtnDT = DBReader(oraclecon, sqlCmdExe);
             rtnDT.TableName = "useDT";

         }
         catch (Exception ex)
         {
             Program._publicFun.logWriteCenter("getDBDataSend", ex);
         }
         return rtnDT;
     }z

    public OracleConnection oracleConnetion(string DataSource)
    {
        OracleConnection oracleConn = new OracleConnection();
        oracleConn.ConnectionString = DataSource;
        try
        {
            oracleConn.Open();
            return oracleConn;

        }
        catch (Exception ex)
        {
            return null;
        }

    }
	  /// <summary>
    /// 取得DB資料,使用 OracleConnection 
    /// </summary>
    /// <param name="DBConn">OracleConnection物件</param>
    /// <param name="sqlStr">SQL Command指令</param>
    /// <returns>DataTable</returns>
	  public DataTable DBReader(OracleConnection DBConn, OracleCommand DBCommand)
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
            string sqlcmd = DBCommand.CommandText;
        }
        return dt;
    }



### Mssql
示範
<script  type='text/javascript' src=''>


    public DataTable UserExample(string connStr)
		{
			DataTable rtnDT = new DataTable();
			try
			{
				var conn = sqlConnetion(connStr);
				SqlCommand sqlCmdExe = new SqlCommand();
				string sqlCmd = string.Empty;
				sqlCmd = $@" Select * from Demo where test = @DateString ";
        string formattedDate= "demoArgs";              

				sqlCmdExe.CommandText = sqlCmd;
				sqlCmdExe.Parameters.Add("@DateString", SqlDbType.VarChar).Value = formattedDate;
				 
				rtnDT = DBReader(conn, sqlCmdExe);
				rtnDT.TableName = $"useDT";

			}
			catch (Exception ex)
			{
				Program._publicFun.logWriteCenter("getDBDataSend", ex);
			}
			return rtnDT;
		}
	  public SqlConnection sqlConnetion(string connStr)
	  {
		  SqlConnection sqlConnection = new SqlConnection();
		  sqlConnection.ConnectionString = connStr;
		  try
		  {
			  sqlConnection.Open();
			  return sqlConnection;
		  }
		  catch
		  {
			  return null;
		  }
	  }

    public DataTable DBReader(SqlConnection DBConn, SqlCommand DBCommand)
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
            string sqlcmd = DBCommand.CommandText;
        }
        return dt;
    }



## 批次插入

### Oracle

Oracle 要安裝套件Oracle.ManagedDataAccess
<script  type='text/javascript' src=''>

    Install-Package Oracle.ManagedDataAccess -Version 21.14.0


示範
<script  type='text/javascript' src=''>

    public void WriteToServer( OracleConnection oracleConnection, string qualifiedDBName, DataTable dataTable )
    {
     try
     {
       using ( OracleBulkCopy bulkCopy = new OracleBulkCopy( oracleConnection ) )
       {
         bulkCopy.DestinationTableName = qualifiedDBName;
         bulkCopy.WriteToServer( dataTable );
       }
     }
     catch ( Exception exc )
     {
      LogException( exc, MethodBase.GetCurrentMethod( ) );
      throw;
     }
    }


### Mssql

示範
<script  type='text/javascript' src=''>

    using (var tx = new TransactionScope())
    {
        using (var sql = new SqlConnection(ConnectionString))
        {
            sql.Open();

            using (var sqlBulkCopy = new SqlBulkCopy(sql))
            {
                sqlBulkCopy.DestinationTableName = "dbo.TableTable";
                sqlBulkCopy.WriteToServer(dt);
            }
        }

        tx.Complete();
    }



## 快速產生Excel報表懶人包

### Oracle連線套件
安裝
<script  type='text/javascript' src=''>

    NuGet\Install-Package System.Data.OracleClient -Version 1.0.8

### Excel套件NPOI

安裝
<script  type='text/javascript' src=''>

    Install-Package NPOI -Version 2.7.0


### Main
如下
<script  type='text/javascript' src=''>

    test


### Method
如下
<script  type='text/javascript' src=''>

    #region 資料庫SQL讀取

    public DataTable DemoOracle(string connStr, DateTime StrDate)
    {
        DataTable rtnDT = new DataTable();
        try
        {
            oraclecon = dbObj.oracleConnetion(connStr);
            OracleCommand sqlCmdExe = new OracleCommand();
            string sqlCmd = @"";
            sqlCmdExe.CommandText = sqlCmd;
            sqlCmdExe.Parameters.Add(":PI_DATES", OracleType.DateTime).Value = StrDate;
            rtnDT = dbObj.DBReader(oraclecon, sqlCmdExe);
            rtnDT.TableName = "useDT";
        }
        catch (Exception ex)
        {
            Program._publicFun.logWriteCenter("MethodName", ex);
        }
        return rtnDT;
    }

    public DataTable DemoMssql(string connStr, string StrDate)
    {
        DataTable rtnDT = new DataTable(); ;
        try
        {
            conn = dbObj.sqlConnetion(connStr);
            SqlCommand sqlCmdExe = new SqlCommand();
            string sqlCmd = @"";
            //sqlCmdExe.Parameters.Add("@StrDate", SqlDbType.VarChar, 8).Value = StrDate; //Ex:20240324
            sqlCmdExe.CommandText = sqlCmd;
            rtnDT = dbObj.DBReader(conn, sqlCmdExe);
            rtnDT.TableName = "useDT";
        }
        catch (Exception ex)
        {
            Program._publicFun.logWriteCenter("MethodName", ex);
        }
        return rtnDT;
    }

    #endregion 資料庫SQL讀取
    #region 資料庫讀取
    #region Oralce
    /// <summary>
    /// 取得DB資料,使用 OracleConnection 
    /// </summary>
    /// <param name="DBConn">OracleConnection物件</param>
    /// <param name="sqlStr">SQL Command指令</param>
    /// <returns>DataTable</returns>
    public DataTable DBReader(OracleConnection DBConn, OracleCommand DBCommand)
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
            string sqlcmd = DBCommand.CommandText;
        }
        return dt;
    }
    #endregion Oralce
    #region Mssql
    public DataTable DBReader(SqlConnection DBConn, SqlCommand DBCommand)
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
            string sqlcmd = DBCommand.CommandText;
        }
        return dt;
    }
    #endregion Mssql
    #endregion 資料庫操作
    #region 建立Excel
    public bool CreateExcelFromDataSet(DataSet dataSet, string filePath)
    {
        bool result = true;
        try
        {
            IWorkbook workbook = new XSSFWorkbook();
            ISheet sheet = workbook.CreateSheet("Sheet1");
            int rowIndex = 0;
            foreach (DataTable dataTable in dataSet.Tables)
            {
                IRow titleRow = sheet.CreateRow(rowIndex);
                titleRow.Height = 30 * 20;
                ICell titleCell = titleRow.CreateCell(0);
                titleCell.SetCellValue($"{dataTable.TableName}");
                titleCell.CellStyle = GetTitleCellStyle(workbook);
                sheet.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(rowIndex, rowIndex, 0, dataTable.Columns.Count - 1));
                SetBorderForMergedCells(sheet, rowIndex, 0, dataTable.Columns.Count);
                rowIndex++;
                IRow headerRow = sheet.CreateRow(rowIndex);
                foreach (DataColumn column in dataTable.Columns)
                {
                    ICell cell = headerRow.CreateCell(column.Ordinal);
                    cell.SetCellValue(column.ColumnName);
                    cell.CellStyle = GetHeaderCellStyle(workbook);
                }
                SetBorderForCells(headerRow, dataTable.Columns.Count);
                rowIndex++;
                foreach (DataRow row in dataTable.Rows)
                {
                    IRow dataRow = sheet.CreateRow(rowIndex);
                    foreach (DataColumn column in dataTable.Columns)
                    {
                        ICell cell = dataRow.CreateCell(column.Ordinal);
                        cell.SetCellValue(row[column].ToString());
                        cell.CellStyle = GetDataCellStyle(workbook);
                    }
                    SetBorderForCells(dataRow, dataTable.Columns.Count); // 设置数据单元格的边框
                    rowIndex++;
                }
                rowIndex++;
            }
            using (FileStream fs = new FileStream(filePath, FileMode.Create, FileAccess.Write))
            {
                workbook.Write(fs);
            }
        }
        catch (Exception ex)
        {
            result = false;
        }
        return result;
    }

    private ICellStyle GetTitleCellStyle(IWorkbook workbook)
    {
        ICellStyle cellStyle = workbook.CreateCellStyle();
        cellStyle.Alignment = HorizontalAlignment.Center;
        cellStyle.VerticalAlignment = VerticalAlignment.Center;

        //   RGB (255, 242, 204)
        cellStyle.FillForegroundColor = IndexedColors.Gold.Index;
        cellStyle.FillPattern = FillPattern.SolidForeground;
        cellStyle.BorderBottom = BorderStyle.Thin;//設定框限線
        cellStyle.BorderTop = BorderStyle.Thin;
        cellStyle.BorderLeft = BorderStyle.Thin;
        cellStyle.BorderRight = BorderStyle.Thin;
        IFont font = workbook.CreateFont();
        font.FontHeightInPoints = 16;
        font.Boldweight = (short)FontBoldWeight.Bold;
        cellStyle.SetFont(font);
        return cellStyle;
    }

    private ICellStyle GetHeaderCellStyle(IWorkbook workbook)
    {
        ICellStyle cellStyle = workbook.CreateCellStyle();
        cellStyle.Alignment = HorizontalAlignment.Center;
        cellStyle.VerticalAlignment = VerticalAlignment.Center;
        cellStyle.BorderBottom = BorderStyle.Thin;
        cellStyle.BorderTop = BorderStyle.Thin;
        cellStyle.BorderLeft = BorderStyle.Thin;
        cellStyle.BorderRight = BorderStyle.Thin;
        IFont font = workbook.CreateFont();
        font.Boldweight = (short)FontBoldWeight.Bold;
        cellStyle.SetFont(font);
        return cellStyle;
    }

    private ICellStyle GetDataCellStyle(IWorkbook workbook)
    {
        ICellStyle cellStyle = workbook.CreateCellStyle();
        cellStyle.Alignment = HorizontalAlignment.Left;
        cellStyle.VerticalAlignment = VerticalAlignment.Center;
        cellStyle.BorderBottom = BorderStyle.Thin;
        cellStyle.BorderTop = BorderStyle.Thin;
        cellStyle.BorderLeft = BorderStyle.Thin;
        cellStyle.BorderRight = BorderStyle.Thin;
        return cellStyle;
    }

    private void SetBorderForCells(IRow row, int columnCount)
    {
        for (int i = 0; i < columnCount; i++)
        {
            ICell cell = row.GetCell(i) ?? row.CreateCell(i);
            ICellStyle cellStyle = cell.CellStyle;
            if (cellStyle == null)
            {
                cellStyle = row.Sheet.Workbook.CreateCellStyle();
            }

            cellStyle.BorderBottom = BorderStyle.Thin;
            cellStyle.BorderTop = BorderStyle.Thin;
            cellStyle.BorderLeft = BorderStyle.Thin;
            cellStyle.BorderRight = BorderStyle.Thin;

            cell.CellStyle = cellStyle;
        }
    }
    private void SetBorderForMergedCells(ISheet sheet, int rowIndex, int columnIndex, int columnCount)
    {
        for (int i = 0; i < columnCount; i++)
        {
            ICell cell = sheet.GetRow(rowIndex).GetCell(columnIndex + i) ?? sheet.GetRow(rowIndex).CreateCell(columnIndex + i);
            ICellStyle cellStyle = cell.CellStyle;
            if (cellStyle == null)
            {
                cellStyle = sheet.Workbook.CreateCellStyle();
            }

            cellStyle.BorderBottom = BorderStyle.Thin;
            cellStyle.BorderTop = BorderStyle.Thin;
            cellStyle.BorderLeft = BorderStyle.Thin;
            cellStyle.BorderRight = BorderStyle.Thin;

            cell.CellStyle = cellStyle;
        }
    }
    #endregion 建立Excel
