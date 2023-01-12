---
layout: post
title: C# AutoMapper 自動映射
date: 2023-01-12 14:35 +0800
---

## 情境說明

## 安裝AutoMapper
![Desktop View](/assets/img/2023-01-12-c-sharp-automapper/1.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package AutoMapper -Version 10.0.0

## Class的Property存在相同命名
<p>兩個Class可能長這樣</p>
![Desktop View](/assets/img/2023-01-12-c-sharp-automapper/4.png){: width="600" height="500" }
<p>不使用AutoMapper時,一般會這樣手動Mapping資料</p>
![Desktop View](/assets/img/2023-01-12-c-sharp-automapper/5.png){: width="600" height="500" }
### Mapping方式
<p>使用AutoMapper的Mapping方式</p>
![Desktop View](/assets/img/2023-01-12-c-sharp-automapper/6.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    IEnumerable<AssetEquipment> oriLst = getOriAsset();
    var config = new MapperConfiguration(cfg =>
    cfg.CreateMap<AssetEquipment, AssetEquipmentDto>()
    );
    IMapper mapper = config.CreateMapper();
    IEnumerable<AssetEquipmentDto> result = mapper.Map<IEnumerable<AssetEquipmentDto>>(oriLst); // 轉換型別



## Class的Property命名完全不同

<p>兩個Class可能長這樣</p>
<p>假設有個AssetEquipment.cs 與OriAsset.cs ，其中有幾個欄位儲存相同的資料</p>
![Desktop View](/assets/img/2023-01-12-c-sharp-automapper/2.png){: width="600" height="500" }
AssetEquipment.cs
 <script  type='text/javascript' src=''>

     public class AssetEquipment
     {
        public string AssetId { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public string DepartmentId { get; set; }
        public string Department { get; set; }
        public string EmploeeID { get; set; }
        public string Emploee { get; set; }
     }

OriAsset.cs
 <script  type='text/javascript' src=''>

    public class OriAsset
    {
        public string PERNR { get; set; }
        public string ANLN1 { get; set; }
        public string TXT50 { get; set; }
        public string AIBN1 { get; set; }
        public string PATH_HEAD { get; set; }
        public string PATH_ITEM { get; set; }
        public string ANLHTXT { get; set; }
    }



### Mapping方式
<p>透過AutoMapper可以設定兩個Class之間的Mapping欄位</p>
![Desktop View](/assets/img/2023-01-12-c-sharp-automapper/3.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

     class Program
    {
        static void Main(string[] args)
        {
        IEnumerable<OriAsset> oriLst = getOriAsset();
        var config = new MapperConfiguration(cfg =>
        cfg.CreateMap<OriAsset, AssetEquipment>()
        .ForMember(x => x.AssetId, y => y.MapFrom(o => o.PERNR))
        .ForMember(x => x.ItemName, y => y.MapFrom(o => o.ANLN1))
        .ForMember(x=>x.ItemDescription, y => y.MapFrom(o => o.TXT50))
         );
            IMapper mapper = config.CreateMapper();
            IEnumerable<AssetEquipment> result = mapper.Map<IEnumerable<AssetEquipment>>(oriLst); // 轉換型別
        }
        public static IEnumerable<OriAsset> getOriAsset()
        {
            var temp = new List<OriAsset>()
            {
                new OriAsset{PERNR="1",ANLN1="2",TXT50="a" }
            };
            return temp;
        } 
    }
