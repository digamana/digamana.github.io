---
layout: post
title: C# Unit Testing Use NUnit
date: 2022-11-09 16:15 +0800
---

## 快速建立專案的示範影片
<iframe width="560" height="315" src="https://www.youtube.com/embed/I2_C-lyRAzk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
## 選擇測試專案

### 選擇1.建立NUnit測試專案
<p>直接建立NUnit 測試專案</p>
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/10.png){: width="800" height="300" }  

### 選擇2.建立MSTest測試專案
<p>直接建立MSTest測試專案,並安裝NUnit相關套件</p>

<p>安裝NUnit 與 NUnit3TestAdapter</p>
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/11.png){: width="800" height="300" }  
NUnit：
<script  type='text/javascript' src=''>

    NuGet\Install-Package NUnit -Version 3.13.3

NUnit3TestAdapter：
<script  type='text/javascript' src=''>

    NuGet\Install-Package NUnit3TestAdapter -Version 4.3.0


## NUnit.第一個測試

### Hello World
<p>如下方範例,主要使用的是Assert.That</p>
UnitTesting.Test
Source Code：
<script  type='text/javascript' src=''>

    namespace UnitTesting.Test
    {
        public class Tests
        {
            [SetUp]
            public void Setup()
            {
            }

            [Test]
            public void Test1()
            {
                var result = true;
                //下面三種寫法，選擇一種
                Assert.IsTrue(result);
                Assert.That(result, Is.True);
                Assert.That(result==true);
            }
        }
    }

### SetUp的使用方式
SetUp用法，用來減少Method中，每次都需要重新寫new Class
<script  type='text/javascript' src=''>

    namespace UnitTesting.Test
    {
        public class Tests
        {
            private Main main;
            [SetUp]
            public void Setup()
            {
                main=new Main();
            }

            [Test]
            public void Add()
            {
                var result= main.Add(1, 2);
                Assert.That(result,Is.EqualTo(3));
            }
            [Test]
            public void Add2()
            {
                var result = main.Add(1, 2);
                Assert.That(result, Is.EqualTo(3));
            }
        }
    }

### 參數與TestCase的使用方式
 如果相同的Method需要根據參數做不同的測試
 <script  type='text/javascript' src=''>

    namespace UnitTesting.Test
    {
        public class Tests
        {
            private Main main;
            [SetUp]
            public void Setup()
            {
                main=new Main();
            }

            [Test]
            [TestCase(1,2,3)]
            [TestCase(1,2,3)]
            public void Add(int a,int b,int sum)
            {
                var result= main.Add(a, b);
                Assert.That(result,Is.EqualTo(sum));
            }

        }
    }

### 重構單元測試的方式
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/6.png){: width="800" height="600" }  

## 參考語法
### by Pass的方式
使用Ignore將不會執行當前Method的測試內容 （by Pass）
 <script  type='text/javascript' src=''>

    [TestCase(1,2,3)]
    [Ignore("by Pass")]
    public void Add(int a,int b,int sum)
    {
    var result= main.Add(a, b);
    Assert.That(result,Is.EqualTo(sum));
    }


### 檢查字串開頭的方式
字串開頭是否相等
 <script  type='text/javascript' src=''>

    [Test]
    public void IsStartWith()
    {
    var result= "HellowWold";
    Assert.That(result,Does.StartWith("Hell"));
    }


### 檢查字串結尾的方式
字串結尾是否相等
 <script  type='text/javascript' src=''>

    [Test]
    public void IsStartWith()
    {
    var result= "HellowWold";
    Assert.That(result,Does.EndWith("Wold"));
    }

### 檢查字串是否包含特定字串的方式
字串結尾是否包含
 <script  type='text/javascript' src=''>

    [Test]
    public void IsStartWith()
    {
    var result= "HellowWold";
    Assert.That(result,Does.Contain("wW"));
    }


### 檢查陣列資料的方式
<p>方法2</p>
確認陣列內容是否一樣
 <script  type='text/javascript' src=''>

    [Test]
    public void check_List_Context()
    {
        var result = new List<int>() {1,2,3 };//這裡代換成輸入的資料
        Assert.That(result, Is.EquivalentTo(new[] { 1,2,3}));//這裡代換成要比對的正確資料
    }


### 檢查回拋Error的方式
Error判斷
如果有個物件長這樣
 <script  type='text/javascript' src=''>

    public  class Main
    {
       public string LastError { get; set; }
        public event EventHandler<Guid> Err;
        public void Log(string err)
        {
            if (string.IsNullOrWhiteSpace(err))
            {
                throw new ArgumentNullException();
            }
            LastError = err;
        }
    }

測試要這樣寫
 <script  type='text/javascript' src=''>

    [Test]
    [TestCase(null)]
    [TestCase("")]
    [TestCase(" ")]
    public void check_List_Context(string err)
    {
        var log=new Main();
        Assert.That(() => log.Log(err), Throws.ArgumentNullException);
    }


## 透過重構建立更適合進行測試的程式
假設有個程式如下
 <script  type='text/javascript' src=''>

    public class service
    {
      public string readTitle()
      {
          var str = File.ReadAllText("");
          return str;
      }
    }
    public class Video 
    {
      public int id { get; set; }
      public string title { get; set; }
      public string IsProcessed { get; set; }
    }


Step2.將「File.ReadAllText("")」這個功能，提取到到新的Class中,爾後調用這個Class進行使用
<script  type='text/javascript' src=''>

    public class service
    {
        public string readTitle()
        {
            var str = new FileReader().Read("");
            return str;
        }
    }
    public class Video 
    {
        public int id { get; set; }
        public string title { get; set; }
        public string IsProcessed { get; set; }
    }
    public class FileReader
    {
        public string Read(string Path)
        {
            return File.ReadAllText(Path);
        }
    }



Step2.從新建的Class中,將Method提煉到到Interface中,爾後
<script  type='text/javascript' src=''>

    public class service
    {
        public string readTitle()
        {
            var str = new FileReader().Read("");
            return str;
        }
    }
    public class Video 
    {
        public int id { get; set; }
        public string title { get; set; }
        public string IsProcessed { get; set; }
    }
    public interface IFileReader
    {
        string Read(string str);
    }
    public class FileReader: IFileReader
    {
        public string Read(string Path)
        {
            return File.ReadAllText(Path);
        }
    }

重構過程如圖所示  
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/7.png){: width="800" height="600" }  


## 使用FluentAssertions陣列資料
安裝FluentAssertions
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/12.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package FluentAssertions -Version 6.8.0


使用方式
<script  type='text/javascript' src=''>

    Punlic class Member
    {
        public int Id { get; set; }

        public string Name { get; set; }
    }

    [Test]
    public void Test()
    {
        var m1 = new Member() { Id = 1, Name = "111",Code="A" };
        var m2 = new Member() { Id = 3, Name = "211",Code="B" };

        m1.ShouldBeEquivalentTo(m2);
    }

<p>備註:ShouldBeEquivalentTo與Assert 同為測試驗證的語法</p>
如果只想驗證Name欄位,不想驗證ID跟CODE欄位則追加 Excluding進行驗證
<script  type='text/javascript' src=''>

    m1.ShouldBeEquivalentTo(m2,c=>c.Excluding(su=>su.Id)
    . Excluding(su=>su.Code));
           



<p>備註2:參考至</p>
[https://dotblogs.com.tw/yc421206/2015/06/20/151606](https://dotblogs.com.tw/yc421206/2015/06/20/151606)

## 新增用來測試的假物件的方式
在單元測試裡面，新增用來測試的假物件
<script  type='text/javascript' src=''>

    namespace UnitTesting.Test
    {
        internal class FakeReader : IFileReader
        {
            public string Read(string str)
            {
                return "";
            }
        }
    }


三種使用假物件進行測試的方式
1.
Method  Argument is interface 
<script  type='text/javascript' src=''>

    public string readTitle(IFileReader fileReader)
    {
        var str = fileReader.Read("");
        return str;
    }

then Testing Code
<script  type='text/javascript' src=''>

    [Test]
    public void test2()
    {
        var service =new service();
        var result = service.readTitle(new FakeReader());
        Assert.That(result, Does.Contain("ERR"));
    }

2.
initial
<script  type='text/javascript' src=''>

    public class service
    {
        public IFileReader FileRead{get;set;}
        public service()
        {
          FileRead =new FileReader();
        }
        public string readTitle()
        {
            var str = FileRead.Read("");
            return str;
        }
    }

then Testing Code
<script  type='text/javascript' src=''>

    [Test]
    public void test2()
    {
        var service =new service();
        service.FileRead = new FileReader();
        var result = service.readTitle();
        Assert.That(result, Does.Contain("ERR"));
    }

3.
initial
<script  type='text/javascript' src=''>

    public class service
    {
        private IFileReader _FileRead;

        public service(IFileReader fileReader =null)
        {
          _FileRead =fileReader ?? new FileReader();
        }
        public string readTitle()
        {
            var str = _FileRead.Read("");
            //var Conver = JsonConvert.DeserializeObject<Video>(str);
            //if (Conver == null) return "Err";
            //return Conver.title;
            return str;
        }
    }

then Testing Code
<script  type='text/javascript' src=''>

    [Test]
    public void test2()
    {
        var service = new service(new FakeReader());
        var result = service.readTitle();
        Assert.That(result, Does.Contain("ERR"));
    }


## 簡單使用Moq建立假物件
Nuget如下
<script  type='text/javascript' src=''>

    NuGet\Install-Package Moq -Version 4.18.2

加入Moq後的重構方式
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/8.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    using Moq;

    namespace UnitTesting.Test
    {
        public class Tests
        {
            private Main main;
            private Mock<IFileReader> _fileReader;
            private service _service;

            [SetUp]
            public void Setup()
            {
                main=new Main();
                 _fileReader = new Mock<IFileReader>();
                 _service = new service(_fileReader.Object);
            }
            [Test]
            public void test2()
            {    
                _fileReader.Setup(c=>c.Read(@"C:\temp\MyTxt.txt")).Returns("ERR");
                var result = _service.readTitle();
                Assert.That(result, Does.Contain("ERR"));
            }
        }
    }


## UnitOfWork 與 單元測試
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/9.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    namespace UnitTesting
    {
        public class BookHelp 
        {
            public static string BookingIsExust(Booking booking, IBookingRepository bookingRepository)
            {
                if (booking.Status == "Cancelled") return String.Empty;
                var tempBook = bookingRepository.GetBookings(booking.Id);
                var overlappingBooking = tempBook.FirstOrDefault();
                return overlappingBooking == null ? string.Empty : overlappingBooking.Ref;
            }
        }
        internal class UnitOfWork
        {
            public IQueryable<Booking> Query<T>()
            { 
                return new List<Booking>().AsQueryable(); 
            }
        }
        public interface IBookingRepository
        {
            IQueryable<Booking> GetBookings(int? id = null);
        }
        public class BookingRepository : IBookingRepository
        {
            public IQueryable<Booking> GetBookings(int? id=null)
            {
                var unitOfwork =new UnitOfWork();
                var bookings = unitOfwork.Query<Booking>().Where(c => c.Status != "Cancelled");
                if(id.HasValue)bookings=bookings.Where(c => c.Id != id.Value);  
                return bookings;
            }
        }
        public class Booking 
        {
            public string Status { get; set; }
            public int Id { get; set; }
            public DateTime ArrivalData { get; set; }
            public DateTime DepartureData { get; set; }
            public string Ref { get; set; }
        }
    }

建立單元測試
<script  type='text/javascript' src=''>

    [Test]
    public void test3()
    { 
        var mock =new Mock<IBookingRepository>();
        mock.Setup(c => c.GetBookings(1)).Returns(new List<Booking>
        {
            new Booking { Id = 2,
                ArrivalData = new DateTime(2022, 01, 01),
                DepartureData = new DateTime(2022, 03, 03),
                Ref="bbb"
            }
        }.AsQueryable());
        var result=BookHelp.BookingIsExust(new Booking
        {
            Id = 2,
            ArrivalData = new DateTime(2022, 01, 01),
            DepartureData = new DateTime(2022, 03, 03),
            Ref = "bbb"
        }, mock.Object);
        Assert.That(result,Is.Empty);
    }


## 可以搭配的技術
- [Unit Of Work (Repository Pattern)]({{ site.baseurl }}{% link _posts/2022-11-06-c-sharp-connect-mssql-use-entity-framework-repository-pattern.md %})
- [使用Autofac實現DI注入容器]({{ site.baseurl }}{% link _posts/2022-11-09-C-Sharp Container Use Autofac.md %})


