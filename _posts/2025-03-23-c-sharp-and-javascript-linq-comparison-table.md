---
layout: post
title: C-Sharp and JavaScript Linq 對照表
date: 2025-03-23 15:58 +0800
---

 
# C# LINQ vs JavaScript Array Methods

以下是 C# LINQ 方法與 JavaScript（JS）對應的方法對照表：

| C# LINQ 方法         | JavaScript 方法               | 說明                     |
|----------------------|-----------------------------|--------------------------|
| `Where`             | `filter`                     | 篩選符合條件的元素       |
| `Select`            | `map`                        | 轉換每個元素             |
| `First`             | `find`                       | 取得第一個符合條件的元素 |
| `FirstOrDefault`    | `find() || null`             | 取得第一個符合條件的元素，找不到則回傳 `null` |
| `Single`            | `filter().at(0)` 或 `find()` | 取得唯一符合條件的元素，否則拋出錯誤 |
| `SingleOrDefault`   | `filter()[0] || null`        | 取得唯一符合條件的元素，若無則回傳 `null` |
| `Any`               | `some`                       | 是否有符合條件的元素     |
| `All`               | `every`                      | 是否所有元素都符合條件   |
| `Count`             | `filter().length`           | 計算符合條件的元素數量   |
| `OrderBy`           | `sort`                       | 依指定條件排序（遞增）   |
| `OrderByDescending` | `sort((a, b) => b - a)`      | 依指定條件排序（遞減）   |
| `GroupBy`          | `reduce`                      | 將元素依指定條件分組     |
| `Distinct`          | `new Set([...arr])` 或 `filter((v, i, a) => a.indexOf(v) === i)` | 去除重複值 |
| `Aggregate`         | `reduce`                      | 累積計算（如求和、乘積） |
| `Take`             | `slice(0, n)`                 | 取得前 `n` 個元素       |
| `Skip`             | `slice(n)`                    | 略過前 `n` 個元素       |
| `Concat`           | `concat`                      | 串接兩個集合             |
| `Contains`         | `includes`                    | 是否包含特定元素         |
| `ToList`           | `[...arr]` 或 `Array.from(arr)` | 轉換為陣列               |

## 範例對照：
### C# LINQ
```csharp
var numbers = new List<int> { 1, 2, 3, 4, 5 };

// Where
var evenNumbers = numbers.Where(n => n % 2 == 0).ToList();

// Select
var squaredNumbers = numbers.Select(n => n * n).ToList();

// Distinct
var uniqueNumbers = numbers.Distinct().ToList();


### JavaScript LINQ
```csharp
const numbers = [1, 2, 3, 4, 5];

// filter
const evenNumbers = numbers.filter(n => n % 2 === 0);

// map
const squaredNumbers = numbers.map(n => n * n);

// Distinct (去重)
const uniqueNumbers = [...new Set(numbers)];

const set = new Set([1, 2, 3, 3, 4, 5]);

// 轉換 Set 為陣列
const arrayFromSet = [...set]; 

console.log(arrayFromSet); // [1, 2, 3, 4, 5]
