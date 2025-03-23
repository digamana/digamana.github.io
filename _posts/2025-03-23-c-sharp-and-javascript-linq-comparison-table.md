---
layout: post
title: C-Sharp and JavaScript Linq 對照表
date: 2025-03-23 15:58 +0800
---

 
# C# LINQ vs JavaScript Array Methods

以下是 C# LINQ 方法與 JavaScript（JS）對應的方法對照表：



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
