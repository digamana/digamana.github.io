---
layout: post
title: C-Sharp Unit Testing Use NUnit
date: 2022-11-09 16:15 +0800
---


NUnit
<script  type='text/javascript' src=''>

    NuGet\Install-Package NUnit -Version 3.13.3


NUnit3TestAdapter
<script  type='text/javascript' src=''>

    NuGet\Install-Package NUnit3TestAdapter -Version 4.3.0


UnitTesting.Test
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

重構過程如圖所示
![Desktop View](/assets/img/2022-11-09-c-sharp-unit-testing-use-nunit/6.png){: width="800" height="600" }  


不執行當前Method的測試內容 （by Pass）
 <script  type='text/javascript' src=''>

    [TestCase(1,2,3)]
    [Ignore("by Pass")]
    public void Add(int a,int b,int sum)
    {
    var result= main.Add(a, b);
    Assert.That(result,Is.EqualTo(sum));
    }


字串開頭是否相等
 <script  type='text/javascript' src=''>

    [Test]
    public void IsStartWith()
    {
    var result= "HellowWold";
    Assert.That(result,Does.StartWith("Hell"));
    }


字串結尾是否相等
 <script  type='text/javascript' src=''>

    [Test]
    public void IsStartWith()
    {
    var result= "HellowWold";
    Assert.That(result,Does.EndWith("Wold"));
    }

字串結尾是否包含
 <script  type='text/javascript' src=''>

    [Test]
    public void IsStartWith()
    {
    var result= "HellowWold";
    Assert.That(result,Does.Contain("wW"));
    }


確認陣列內容是否一樣
 <script  type='text/javascript' src=''>

    [Test]
    public void check_List_Context()
    {
        var result = new List<int>() {1,2,3 };//這裡代換成輸入的資料
        Assert.That(result, Is.EquivalentTo(new[] { 1,2,3}));//這裡代換成要比對的正確資料
    }


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

透過重構建立更適合進行測試的程式
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


Step2.提取
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



Step2.提取interface  FileReader
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
